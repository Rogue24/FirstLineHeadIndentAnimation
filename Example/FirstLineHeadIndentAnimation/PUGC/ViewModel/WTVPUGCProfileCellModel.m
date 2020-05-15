//
//  WTVPUGCProfileCellModel.m
//  WoTV
//
//  Created by 周健平 on 2020/4/14.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "WTVPUGCProfileCellModel.h"
#import "NSString+JPExtension.h"
#import "UIImageView+JPExtension.h"

NSString * const WTVPUGCFollowNotifiCation = @"WTVPUGCFollowNotifiCation";
NSString * const WTVPUGCGiveUpNotifiCation = @"WTVPUGCGiveUpNotifiCation";
NSString * const WTVVideoCollectNotifiCation = @"WTVVideoCollectNotifiCation";

@implementation WTVPUGCTextLinePositionModifier
- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _font.ascender + line.row * _font.lineHeight; // baseline的位置
        line.position = position;
    }
}
- (id)copyWithZone:(NSZone *)zone {
    WTVPUGCTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    return one;
}
@end

@implementation WTVPUGCProfileCellModel

#pragma mark - 初始化

+ (instancetype)cellModelForCellStyle_1withModel:(WTVPUGCProfileModel *)model index:(NSInteger)index contrastUid:(NSString *)contrastUid isNoProfileStyle:(BOOL)isNoProfileStyle {
    return [[self alloc] initWithModel:model index:index cellStyle:WTVPUGCProfileCellStyle_1 contrastUid:contrastUid isNoProfileStyle:isNoProfileStyle];
}
+ (instancetype)cellModelForCellStyle_2withModel:(WTVPUGCProfileModel *)model index:(NSInteger)index contrastUid:(NSString *)contrastUid {
    return [[self alloc] initWithModel:model index:index cellStyle:WTVPUGCProfileCellStyle_2 contrastUid:contrastUid isNoProfileStyle:YES];
}
- (instancetype)initWithModel:(WTVPUGCProfileModel *)model index:(NSInteger)index cellStyle:(WTVPUGCProfileCellStyle)cellStyle contrastUid:(NSString *)contrastUid isNoProfileStyle:(BOOL)isNoProfileStyle {
    if (self = [super init]) {
        self.model = model;
        self.index = index;
        self.uid = model.authorId;
        self.isMe = [self.uid isEqualToString:contrastUid];
        
        self.cellStyle = cellStyle;
        self.isNoProfileStyle = isNoProfileStyle;
        self.isNoPugcStyle = cellStyle == WTVPUGCProfileCellStyle_2 && model.videoType != 14;
        
        self.isRelate = model.relateModel != nil;
        self.isVerVideo = model.portrait;
        
        self.cellSize = CGSizeMake(JPPortraitScreenWidth,
                        [WTVPUGCProfileCell cellHeight:cellStyle
                                            isVerVideo:self.isVerVideo
                                              isRelate:self.isRelate
                                         isNoPugcStyle:self.isNoPugcStyle]);
        
        [self __setupUserInfo];
        [self __setupVideoInfo];
        [self __setupOthers];
        [self __setupNotifications];
    }
    return self;
}
- (void)dealloc {
    JPRemoveNotification(self);
}

- (void)__setupUserInfo {
    if (self.isNoPugcStyle) return;
    
    WTVPUGCProfileModel *model = self.model;
    
    self.iconURL = [NSURL URLWithString:model.headPhoto];
    self.logoName = [self __getLogoName:model.authorCategory];
    self.userName = [model.nickname stringByRemovingPercentEncoding];
    self.bottomStr = self.isNoProfileStyle ? ((self.logoName && model.position.jp_isNotNull) ? model.position : model.desc) : model.publishTime;
    
    self.isLiving = model.updateState == 2; // 更新状态（0： 近期无更新  1：有更新  2：正在直播）
    self.isFollowed = self.isMe ? NO : model.attentioned;
}

- (void)__setupVideoInfo {
    WTVPUGCProfileModel *model = self.model;
    
    self.coverURL = [NSURL URLWithString:(self.isVerVideo ? model.screenUrl : model.screenShotUrl)];
    [self __setupVideoTitle:model.name];
    
    self.duration = [self __convertDurationFormat:model.duration];
    self.cetegory = self.isNoPugcStyle ? (model.sort ? model.sort : @"其他") : model.interest;
    [self __solveDurationAndCetegoryFrame];
    
    [self __setupRelateVideoInfo];
}

- (void)__setupOthers {
    WTVPUGCProfileModel *model = self.model;
    if (self.cellStyle == WTVPUGCProfileCellStyle_1 || self.isNoPugcStyle) {
        self.isZaned = model.hasGiveUp;
        self.isCollected = model.love;
        
        self.zanCountStr = [self __correctCountString:model.good isAboutZero:NO];
        self.collectCountStr = [self __correctCountString:model.collects isAboutZero:NO];
        self.shareCountStr = [self __correctCountString:model.shares isAboutZero:NO];
    }
    self.commentCountStr = [self __correctCountString:model.comments isAboutZero:NO];
}

- (void)__setupNotifications {
    JPObserveNotification(self, @selector(updateZanState:), WTVPUGCGiveUpNotifiCation, nil);
    JPObserveNotification(self, @selector(updateCollectState:), WTVVideoCollectNotifiCation, nil);
    if (!self.isNoPugcStyle && !self.isMe) {
        JPObserveNotification(self, @selector(updateFollowState:), WTVPUGCFollowNotifiCation, nil);
    }
}

#pragma mark 初始化计算

// 0：兴趣认证用户   1：专业个人认证用户   2：专业企业认证用户   3：普通用户
- (NSString *)__getLogoName:(NSInteger)authorCategory {
    if (authorCategory == 0) {
        return @"hotspot_icon_interest_authentication";
    } else if (authorCategory == 1 || authorCategory == 2) {
        return @"hotspot_icon_professional_authentication";
    } else {
        return nil;
    }
}

- (NSString *)__correctCountString:(NSInteger)count isAboutZero:(BOOL)isAboutZero {
    return count <= 0 ? (isAboutZero ? @"0" : nil) : (count >= 10000 ? [NSString stringWithFormat:@"%zdw", count / 10000] : [NSString stringWithFormat:@"%zd", count]);
}

- (void)__setupVideoTitle:(NSString *)videoTitle {
    UIFont *font = WTVPUGCProfilePlayView.videoTitleFont;
    
    NSDictionary *attDic = @{NSFontAttributeName: font,
                             NSForegroundColorAttributeName: WTVPUGCProfilePlayView.videoTitleColor};
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:videoTitle attributes:attDic];
    
    WTVPUGCTextLinePositionModifier *modifier = [WTVPUGCTextLinePositionModifier new];
    modifier.font = font;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(WTVPUGCProfilePlayView.videoTitleMaxWidth, 999)];
    container.maximumNumberOfRows = WTVPUGCProfilePlayView.videoTitleMaxRows;
    container.linePositionModifier = modifier;
    container.truncationType = YYTextTruncationTypeEnd;
    container.truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:attDic];
    
    self.videoTitleLayout = [YYTextLayout layoutWithContainer:container text:attStr];
}

- (void)__setupRelateVideoInfo {
    if (!self.isRelate) return;
    WTVPUGCProfileModel *relateModel = self.model.relateModel;
    
    self.relateCoverURL = [NSURL URLWithString:relateModel.screenShotUrl];
    self.relateVideoTitle = relateModel.name;
    
    self.isRelateCollected = relateModel.love;
    
    NSMutableString *relateVideoInfo = [NSMutableString string];
    NSString *watchCountStr = [self __correctCountString:relateModel.watchs isAboutZero:NO];
    if (watchCountStr) [relateVideoInfo appendFormat:@"%@次播放", watchCountStr];
    if (relateModel.sort.jp_isNotNull) {
        if (relateVideoInfo.length) [relateVideoInfo appendString:@"·"];
        [relateVideoInfo appendString:relateModel.sort];
    }
    if (relateModel.onlinetime.jp_isNotNull) {
        if (relateVideoInfo.length) [relateVideoInfo appendString:@"·"];
        [relateVideoInfo appendString:[relateModel.onlinetime componentsSeparatedByString:@"-"].firstObject];
    }
    self.relateVideoInfo = relateVideoInfo;
}

- (NSString *)__convertDurationFormat:(NSInteger)intTotalTime {
    if (intTotalTime <= 0) {
        return nil;
    }
    NSInteger hour = [JPSolveTool hourPart:intTotalTime];
    NSInteger minute = [JPSolveTool minutePart:intTotalTime];
    NSInteger second = [JPSolveTool secondPart:intTotalTime];
    BOOL isMoreThanOneHour = hour > 0;
    return isMoreThanOneHour ? [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hour, minute, second] : [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

- (void)__solveDurationAndCetegoryFrame {
    if (!self.duration && !self.cetegory) {
        return;
    }
    
    CGSize playViewSize = [WTVPUGCProfilePlayView viewSizeWithIsVerVideo:self.isVerVideo isRelate:NO];
    UIFont *font = [WTVPUGCProfilePlayView bottomLabelFont];
    CGFloat minWidth = [WTVPUGCProfilePlayView bottomLabelMinWidth];
    
    CGFloat labelH = JPScaleValue(18);
    CGFloat labelMargin = JP8Margin;
    CGFloat viewH = labelMargin + labelH + labelMargin;
    CGFloat viewY = playViewSize.height - viewH;
    
    CGFloat viewW;
    if (self.cetegory) {
        CGFloat cetegoryW = [JPSolveTool oneLineTextFrameWithText:self.cetegory font:font].size.width + JP8Margin;
        if (cetegoryW < minWidth) cetegoryW = minWidth;
        self.cetegoryFrame = CGRectMake(labelMargin, labelMargin, cetegoryW, labelH);
    }
    if (self.duration) {
        CGFloat durationW = [JPSolveTool oneLineTextFrameWithText:self.duration font:font].size.width + JP8Margin;
        if (durationW < minWidth) durationW = minWidth;
        
        if (self.cetegory) {
            self.durationFrame = CGRectMake(CGRectGetMaxX(self.cetegoryFrame) + JPScaleValue(4), labelMargin, durationW, labelH);
        } else {
            self.durationFrame = CGRectMake(labelMargin, labelMargin, durationW, labelH);
        }
        
        viewW = CGRectGetMaxX(self.durationFrame) + labelMargin;
    } else {
        viewW = CGRectGetMaxX(self.cetegoryFrame) + labelMargin;
    }
    
    CGFloat viewX = playViewSize.width - viewW;
    self.bottomViewFrame = CGRectMake(viewX, viewY, viewW, viewH);
}

#pragma mark - 配置cell

- (void)setCell:(WTVPUGCProfileCell *)cell {
    if (_cell != cell) {
        _cell.cm = nil; // 这里的_cell.cm就是self，下面就会引用新的cell，引用前先把这个即将抛弃的cell的引用置nil，防止同时被两个cell使用到self
        cell.cm.cell = nil; // 这里设置的cell，要么是新建的，要么是复用的（已经看不到的），所以不用担心会影响显示中的cell
    }
    _cell = cell;
    _cell.cm = self;
}

- (void)setupCell:(WTVPUGCProfileCell *)cell {
    self.cell = cell;
    [cell setCellStyle:self.cellStyle
            isVerVideo:self.isVerVideo
              isRelate:self.isRelate
         isNoPugcStyle:self.isNoPugcStyle];
    [self __setupCellPlayView];
    [self __setupCellIconView];
    [self __setupCellOthers];
}

- (void)__setupCellPlayView {
    WTVPUGCProfilePlayView *playView = self.cell.playView;
    
    [playView setIsFollowed:self.isFollowed isLiving:self.isLiving];
    [playView setTitleLayout:self.videoTitleLayout];
    
    [playView.coverView jp_fakeSetPictureWithURL:self.coverURL placeholderImage:nil];
    
    if (self.bottomViewFrame.size.width) {
        playView.bottomView.hidden = NO;
        playView.bottomView.frame = self.bottomViewFrame;
        if (self.duration) {
            playView.durationLabel.hidden = NO;
            playView.durationLabel.text = self.duration;
            playView.durationLabel.frame = self.durationFrame;
        } else {
            playView.durationLabel.hidden = YES;
        }
        if (self.cetegory) {
            playView.cetegoryLabel.hidden = NO;
            playView.cetegoryLabel.text = self.cetegory;
            playView.cetegoryLabel.frame = self.cetegoryFrame;
        } else {
            playView.cetegoryLabel.hidden = YES;
        }
    } else {
        playView.bottomView.hidden = YES;
    }
    
    if (self.isRelate) {
        [playView.relateCoverView jp_fakeSetPictureWithURL:self.relateCoverURL placeholderImage:nil];
        playView.relateTitleLabel.text = self.relateVideoTitle;
        playView.relateInfoLabel.text = self.relateVideoInfo;
        playView.relatCollectBtn.isSelected = self.isRelateCollected;
    }
}

- (void)__setupCellIconView {
    WTVPUGCProfileIconView *iconView = self.cell.iconView;
    if (self.isNoPugcStyle) {
        iconView.icon.isLiving = NO;
        return;
    }
    
    [iconView.icon.imageView jp_setPictureWithURL:self.iconURL options:JPWebImageOptionSetImageWithFadeAnimation isRounded:YES placeholderImage:[UIImage imageNamed:@"my_icon_colours"] progress:nil transform:nil completed:nil];
    if (self.logoName) {
        iconView.icon.logoView.image = [UIImage imageNamed:self.logoName];
        [iconView.icon showLogo:NO];
    } else {
        iconView.icon.logoView.image = nil;
        [iconView.icon hideLogo:NO];
    }
    iconView.nameLabel.text = self.userName;
    iconView.bottomLabel.text = self.bottomStr;
    
    // 💃
    iconView.icon.isLiving = self.isLiving;
    // 💃
    if (!self.isNoProfileStyle || self.isMe) {
        iconView.isNotNeedFollow = YES;
    } else {
        iconView.isNotNeedFollow = NO;
        iconView.followBtn.selected = self.isFollowed;
    }
}

- (void)__setupCellOthers {
    WTVPUGCProfileBottomView *bottomView = self.cell.bottomView;
    if (self.cellStyle == WTVPUGCProfileCellStyle_1 || self.isNoPugcStyle) {
        // 💃
        bottomView.zanBtn.isSelected = self.isZaned;
        bottomView.zanBtn.countStr = self.zanCountStr;
        // 💃
        bottomView.collectBtn.isSelected = self.isCollected;
        bottomView.collectBtn.countStr = self.collectCountStr;
        
        bottomView.forwardBtn.countStr = self.shareCountStr;
    }
    bottomView.commentBtn.countStr = self.commentCountStr;
}

#pragma mark - 交互

- (void)setIsLiving:(BOOL)isLiving {
    [self setIsLiving:isLiving animated:NO];
}
- (void)setIsLiving:(BOOL)isLiving animated:(BOOL)isAnimated {
    if (self.isNoPugcStyle) {
        _isLiving = NO;
        return;
    }
    _isLiving = isLiving;
    if (!self.cell) return;
    
    [self.cell.iconView.icon setIsLiving:isLiving animated:isAnimated];
    [self.cell.playView setIsLiving:isLiving animated:isAnimated];
}

- (void)setIsFollowed:(BOOL)isFollowed {
    [self setIsFollowed:isFollowed byUserInteraction:NO];
}
- (void)setIsFollowed:(BOOL)isFollowed byUserInteraction:(BOOL)byUserInteraction {
    if (self.isNoPugcStyle || self.isMe) {
        _isFollowed = NO;
        return;
    }
    _isFollowed = isFollowed;
    
    if (byUserInteraction) {
        NSInteger fansCount = self.model.fans;
        if (isFollowed) {
            fansCount += 1;
        } else {
            fansCount -= 1;
            if (fansCount < 0) fansCount = 0;
        }
        self.model.attentioned = isFollowed;
        self.model.fans = fansCount;
        
//        [[WTVPUGCProfileTool sharedInstance] follow:isFollowed ID:self.model.authorId sender:self targetFollowCount:fansCount followName:nil];
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        result[@"authorId"] = self.model.authorId;
        result[@"sender"] = self;
        result[@"success"] = @(YES);
        result[@"follow"] = @(isFollowed);
        result[@"followCount"] = @(fansCount);
        JPPostNotification(WTVPUGCFollowNotifiCation, nil, result);
    }
    
    if (self.isNoProfileStyle && self.cell) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cell.iconView setIsFollowed:isFollowed animated:byUserInteraction];
            [self.cell.playView setIsFollowed:isFollowed animated:byUserInteraction];
        });
    }
}

- (void)setIsZaned:(BOOL)isZaned {
    [self setIsZaned:isZaned byUserInteraction:NO];
}
- (void)setIsZaned:(BOOL)isZaned byUserInteraction:(BOOL)byUserInteraction {
    _isZaned = isZaned;
    
    if (byUserInteraction) {
        NSInteger zanCount = self.model.good;
        if (isZaned) {
            zanCount += 1;
        } else {
            zanCount -= 1;
            if (zanCount < 0) zanCount = 0;
        }
        self.model.hasGiveUp = isZaned;
        self.model.good = zanCount;
        self.zanCountStr = [self __correctCountString:zanCount isAboutZero:NO];
        
//        [[WTVPUGCProfileTool sharedInstance] zan:isZaned ID:self.model.cid sender:self targetZanCount:zanCount];
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        result[@"cid"] = self.model.cid;
        result[@"sender"] = self;
        result[@"success"] = @(YES);
        result[@"giveUp"] = @(isZaned);
        result[@"agreeNum"] = @(zanCount);
        JPPostNotification(WTVPUGCGiveUpNotifiCation, nil, result);
    }
    
    if (self.cell) {
        dispatch_async(dispatch_get_main_queue(), ^{
            WTVPUGCProfileBottomView *bottomView = self.cell.bottomView;
            bottomView.zanBtn.countStr = self.zanCountStr;
            [bottomView.zanBtn setIsSelected:isZaned animated:byUserInteraction];
        });
    }
}

- (void)setIsCollected:(BOOL)isCollected {
    [self setIsCollected:isCollected byUserInteraction:NO];
}
- (void)setIsCollected:(BOOL)isCollected byUserInteraction:(BOOL)byUserInteraction {
    _isCollected = isCollected;
    
    if (byUserInteraction) {
        NSInteger collectCount = self.model.collects;
        if (isCollected) {
            collectCount += 1;
        } else {
            collectCount -= 1;
            if (collectCount < 0) collectCount = 0;
        }
        self.model.collects = collectCount;
        self.model.love = isCollected;
        self.collectCountStr = [self __correctCountString:collectCount isAboutZero:NO];
        
//        [[WTVPUGCProfileTool sharedInstance] collect:isCollected model:self.model sender:self targetCollectCount:collectCount];
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        result[@"collect"] = @(isCollected);
        result[@"cid"] = self.model.cid;
        result[@"collectCount"] = @(collectCount);
        result[@"sender"] = self;
        JPPostNotification(WTVVideoCollectNotifiCation, nil, result);
    }
    
    if (self.cell) {
        dispatch_async(dispatch_get_main_queue(), ^{
            WTVPUGCProfileBottomView *bottomView = self.cell.bottomView;
            bottomView.collectBtn.countStr = self.collectCountStr;
            [bottomView.collectBtn setIsSelected:isCollected animated:byUserInteraction];
        });
    }
}

- (void)setIsRelateCollected:(BOOL)isRelateCollected {
    [self setIsRelateCollected:isRelateCollected byUserInteraction:NO];
}
- (void)setIsRelateCollected:(BOOL)isRelateCollected byUserInteraction:(BOOL)byUserInteraction {
    _isRelateCollected = isRelateCollected;
    
    if (byUserInteraction) {
        NSInteger collectCount = self.model.relateModel.collects;
        if (isRelateCollected) {
            collectCount += 1;
        } else {
            collectCount -= 1;
            if (collectCount < 0) collectCount = 0;
        }
        self.model.relateModel.collects = collectCount;
        self.model.relateModel.love = isRelateCollected;
        
//        [[WTVPUGCProfileTool sharedInstance] collect:isRelateCollected model:self.model.relateModel sender:self targetCollectCount:collectCount];
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        result[@"collect"] = @(isRelateCollected);
        result[@"cid"] = self.model.relateModel.cid;
        result[@"collectCount"] = @(collectCount);
        result[@"sender"] = self;
        JPPostNotification(WTVVideoCollectNotifiCation, nil, result);
    }
    
    if (self.cell) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cell.playView.relatCollectBtn setIsSelected:isRelateCollected animated:byUserInteraction];
        });
    }
}

#pragma mark - 通知监听

- (void)updateAuthState:(NSNotification *)noti {
    NSDictionary *result = noti.userInfo;
    
    NSInteger authorCategory = [result[@"authorCategory"] integerValue];
    self.model.authorCategory = authorCategory;
    self.logoName = [self __getLogoName:authorCategory];
    
    if (self.cell) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.logoName) {
                self.cell.iconView.icon.logoView.image = [UIImage imageNamed:self.logoName];
                [self.cell.iconView.icon showLogo:NO];
            } else {
                self.cell.iconView.icon.logoView.image = nil;
                [self.cell.iconView.icon hideLogo:NO];
            }
        });
    }
}

- (void)updateUserInfo:(NSNotification *)noti {
    NSDictionary *result = noti.userInfo;
    
    self.model.headPhoto = result[@"headPhoto"];
    self.model.nickname = result[@"nickname"];
    
    self.iconURL = [NSURL URLWithString:self.model.headPhoto];
    self.userName = self.model.nickname;
    
    if (self.cell) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cell.iconView.icon.imageView jp_setPictureWithURL:self.iconURL options:JPWebImageOptionSetImageWithFadeAnimation isRounded:YES placeholderImage:[UIImage imageNamed:@"my_icon_colours"] progress:nil transform:nil completed:nil];
            self.cell.iconView.nameLabel.text = self.userName;
        });
    }
}

- (void)updateFollowState:(NSNotification *)noti {
    NSDictionary *result = noti.userInfo;
    
    NSString *ID = result[@"authorId"];
    if (![self.uid isEqualToString:ID]) return;
    
    BOOL isFollow = [result[@"follow"] boolValue];

    NSInteger fansCount;
    if (result[@"followCount"]) {
        // 自己传入的目标数
        fansCount = [result[@"followCount"] integerValue];
    } else {
        fansCount = self.model.fans;
        id sender = result[@"sender"];
        BOOL success = [result[@"success"] boolValue];
        if ((sender == self && !success) ||
            (sender != self && success)) {
            // 自己发出的话，发出前已经刷新了，如果不成功，返回发出前的状态，重新回滚数值
            // 而不是自己发出的，如果成功则自己计算新值
            if (isFollow) {
                fansCount += 1;
            } else {
                fansCount -= 1;
                if (fansCount < 0) fansCount = 0;
            }
        }
    }
    self.model.fans = fansCount;
    self.model.attentioned = isFollow;
    
    _isFollowed = isFollow;
    if (self.isNoProfileStyle && self.cell) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cell.iconView setIsFollowed:isFollow animated:YES];
            [self.cell.playView setIsFollowed:isFollow animated:YES];
        });
    }
}

- (void)updateZanState:(NSNotification *)noti {
    NSDictionary *result = noti.userInfo;
    
    NSString *ID = result[@"cid"];
    if (![self.model.cid isEqualToString:ID]) return;
    
    BOOL isZan = [result[@"giveUp"] boolValue];
    
    NSInteger zanCount;
    if (result[@"agreeNum"]) {
        // 自己传入的目标点赞数
        zanCount = [result[@"agreeNum"] integerValue];
    } else {
        zanCount = self.model.good;
        id sender = result[@"sender"];
        BOOL success = [result[@"success"] boolValue];
        if ((sender == self && !success) ||
            (sender != self && success)) {
            // 自己发出的话，发出前已经刷新了，如果不成功，返回发出前的状态，重新回滚数值
            // 而不是自己发出的，如果成功则自己计算新值
            if (isZan) {
                zanCount += 1;
            } else {
                zanCount -= 1;
                if (zanCount < 0) zanCount = 0;
            }
        }
    }
    self.model.good = zanCount;
    self.model.hasGiveUp = isZan;
    
    self.zanCountStr = [self __correctCountString:zanCount isAboutZero:NO];
    
    _isZaned = isZan;
    if (self.cell && (self.cellStyle == WTVPUGCProfileCellStyle_1 || self.isNoPugcStyle)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            WTVPUGCProfileBottomView *bottomView = self.cell.bottomView;
            bottomView.zanBtn.countStr = self.zanCountStr;
            bottomView.zanBtn.isSelected = isZan;
        });
    }
}

- (void)updateCollectState:(NSNotification *)noti {
    NSDictionary *result = noti.userInfo;
    
    id sender = result[@"sender"];
    if (self == sender) return;
    
    NSString *ID = result[@"cid"];
    BOOL isRelate = NO;
    
    if (![self.model.cid isEqualToString:ID]) {
        if (self.isRelate && [self.model.relateModel.cid isEqualToString:ID]) {
            isRelate = YES;
        } else {
            return;
        }
    }
    
    WTVPUGCProfileModel *model = isRelate ? self.model.relateModel : self.model;
    
    BOOL isCollect = [result[@"collect"] boolValue];
    
    NSInteger collectCount;
    if (result[@"collectCount"]) {
        // 自己传入的目标点赞数
        collectCount = [result[@"collectCount"] integerValue];
    } else {
        collectCount = model.collects;
        if (isCollect) {
            collectCount += 1;
        } else {
            collectCount -= 1;
            if (collectCount < 0) collectCount = 0;
        }
    }
    model.collects = collectCount;
    model.love = isCollect;
    
    if (isRelate) {
        _isRelateCollected = isCollect;
    } else {
        self.collectCountStr = [self __correctCountString:model.collects isAboutZero:NO];
        _isCollected = isCollect;
    }
    
    if (self.cell) {
        if (isRelate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cell.playView.relatCollectBtn.isSelected = isCollect;
            });
        } else if (self.cellStyle == WTVPUGCProfileCellStyle_1 || self.isNoPugcStyle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                WTVPUGCProfileBottomView *bottomView = self.cell.bottomView;
                bottomView.collectBtn.countStr = self.collectCountStr;
                bottomView.collectBtn.isSelected = isCollect;
            });
        }
    }
}

@end
