//
//  WTVPUGCProfileCell.m
//  WoTV
//
//  Created by 周健平 on 2020/4/13.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "WTVPUGCProfileCell.h"
#import "WTVPUGCProfileCellModel.h"

@implementation WTVPUGCProfileBottomView
- (instancetype)init {
    if (self = [super init]) {
        self.commentBtn = [WTVPUGCOptionButton commentButton];
        self.moreBtn = [WTVPUGCOptionButton moreButton];
        
        self.jp_size = CGSizeMake(JPPortraitScreenWidth, self.commentBtn.jp_height);
        
        self.moreBtn.jp_x = self.jp_width - self.moreBtn.jp_width;
        [self addSubview:self.moreBtn];
        
        self.commentBtn.jp_x = self.moreBtn.jp_x - self.commentBtn.jp_width;
        [self addSubview:self.commentBtn];
    }
    return self;
}
- (void)createZanBtn:(void (^)(JPBounceView *))viewTouchUpInside {
    if (_zanBtn) return;
    _zanBtn = [WTVPUGCOptionButton zanButton];
    _zanBtn.viewTouchUpInside = viewTouchUpInside;
    [self addSubview:_zanBtn];
}
- (void)createCollectBtn:(void (^)(JPBounceView *))viewTouchUpInside {
    if (_collectBtn) return;
    _collectBtn = [WTVPUGCOptionButton collectButton];
    _collectBtn.viewTouchUpInside = viewTouchUpInside;
    _collectBtn.jp_x = _collectBtn.jp_width;
    [self addSubview:_collectBtn];
}
- (void)createForwardBtn:(void (^)(JPBounceView *))viewTouchUpInside {
    if (_forwardBtn) return;
    _forwardBtn = [WTVPUGCOptionButton forwardButton];
    _forwardBtn.viewTouchUpInside = viewTouchUpInside;
    _forwardBtn.jp_x = _forwardBtn.jp_width * 2;
    [self addSubview:_forwardBtn];
}
@end

@interface WTVPUGCProfileCell () <UIGestureRecognizerDelegate>
@end
@implementation WTVPUGCProfileCell

+ (CGFloat)cellHeight:(WTVPUGCProfileCellStyle)cellStyle isVerVideo:(BOOL)isVerVideo isRelate:(BOOL)isRelate isNoPugcStyle:(BOOL)isNoPugcStyle {
    CGFloat h = [WTVPUGCProfilePlayView viewSizeWithIsVerVideo:isVerVideo isRelate:isRelate].height;
    if (cellStyle == WTVPUGCProfileCellStyle_1) {
        h += JPScaleValue(60 + 46);
    } else if (cellStyle == WTVPUGCProfileCellStyle_2) {
        h += JPScaleValue(12);
        if (isNoPugcStyle) {
            h += JPScaleValue(46);
        } else {
            h += JPScaleValue(60);
        }
    }
    return h;
}

+ (CGSize)moreBtnSize {
    return CGSizeMake(JPScaleValue(22), JPScaleValue(40));
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _cellStyle = 99;
        self.backgroundColor = UIColor.whiteColor;
        
        // bottomView
        self.bottomView = [[WTVPUGCProfileBottomView alloc] init];
        [self.contentView addSubview:self.bottomView];
        
        @jp_weakify(self);
        
        self.bottomView.moreBtn.viewTouchUpInside = ^(JPBounceView *bounceView) {
            @jp_strongify(self);
            if (!self || ![self.delegate respondsToSelector:@selector(moreAction:)]) return;
            [self.delegate moreAction:self];
        };
        
        self.bottomView.commentBtn.viewTouchUpInside = ^(JPBounceView *bounceView) {
            @jp_strongify(self);
            if (!self || ![self.delegate respondsToSelector:@selector(commentAction:)]) return;
            [self.delegate commentAction:self];
        };
        
        // playView
        self.playView = [WTVPUGCProfilePlayView playView];
        [self.contentView addSubview:self.playView];
        
        self.playView.viewTouchUpInside = ^(JPBounceView *bounceView) {
            @jp_strongify(self);
            if (!self || ![self.delegate respondsToSelector:@selector(playAction:)]) return;
            [self.delegate playAction:self];
        };
        
        self.playView.cetegoryLabel.userInteractionEnabled = YES;
        [self.playView.cetegoryLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCetegoryLabel)]];
        
        self.playView.relatePlayBlock = ^{
            @jp_strongify(self);
            if (!self || ![self.delegate respondsToSelector:@selector(relatePlayAction:)]) return;
            [self.delegate relatePlayAction:self];
        };
        
        self.playView.relateCollectBlock = ^{
            @jp_strongify(self);
            if (!self || ![self.delegate respondsToSelector:@selector(relateCollectAction:)]) return;
            [self.delegate relateCollectAction:self];
        };
        
        // 分隔线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = JPRGBAColor(170, 170, 170, 0.3);
        line.layer.cornerRadius = 0.25;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(JPScaleValue(16));
            make.right.equalTo(self.contentView).offset(-JPScaleValue(16));
            make.height.equalTo(@(0.5));
        }];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell)];
        tapGR.delegate = self;
        [self.contentView addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)createIconView {
    if (_iconView) return;
    _iconView = [WTVPUGCProfileIconView iconView];
    [self.contentView addSubview:_iconView];
    CGFloat iconWH = WTVPUGCProfileIconView.iconWH;
    if (_cellStyle == WTVPUGCProfileCellStyle_1) {
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(JP12Margin));
            make.left.right.equalTo(self.playView);
            make.height.equalTo(@(iconWH));
        }];
        [_iconView.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(JP12Margin));
            make.top.equalTo(_iconView.nameLabel.mas_bottom).offset(JPScaleValue(4));
            make.left.equalTo(_iconView.nameLabel);
            make.right.equalTo(_iconView);
        }];
    } else if (_cellStyle == WTVPUGCProfileCellStyle_2) {
        CGFloat maxW = self.bottomView.commentBtn.jp_x - self.playView.jp_x;
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playView.mas_bottom).offset(JP12Margin);
            make.left.equalTo(self.playView);
            make.height.equalTo(@(iconWH));
            make.width.lessThanOrEqualTo(@(maxW)); // <=
        }];
        maxW -= (iconWH + JP8Margin);
        [_iconView.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(JP12Margin));
            make.top.equalTo(_iconView.nameLabel.mas_bottom).offset(JPScaleValue(4));
            make.left.equalTo(_iconView.nameLabel);
            make.width.equalTo(@(maxW));
        }];
    }
    
    [_iconView.icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIcon)]];
    [_iconView.followBtn addTarget:self action:@selector(tapFollowBtn) forControlEvents:UIControlEventTouchUpInside];
}
- (void)createZanCollectForwardBtns {
    @jp_weakify(self);
    [self.bottomView createZanBtn:^(JPBounceView *bounceView) {
        @jp_strongify(self);
        if (!self || ![self.delegate respondsToSelector:@selector(zanAction:)]) return;
        [self.delegate zanAction:self];
    }];
    
    [self.bottomView createCollectBtn:^(JPBounceView *bounceView) {
        @jp_strongify(self);
        if (!self || ![self.delegate respondsToSelector:@selector(collectAction:)]) return;
        [self.delegate collectAction:self];
    }];
    
    [self.bottomView createForwardBtn:^(JPBounceView *bounceView) {
        @jp_strongify(self);
        if (!self || ![self.delegate respondsToSelector:@selector(forwardAction:)]) return;
        [self.delegate forwardAction:self];
    }];
}

#pragma mark - 初始化配置

- (void)setCellStyle:(WTVPUGCProfileCellStyle)cellStyle isVerVideo:(BOOL)isVerVideo isRelate:(BOOL)isRelate isNoPugcStyle:(BOOL)isNoPugcStyle {
    
    [self.playView setIsVerVideo:isVerVideo isRelate:isRelate];
    
    if (_cellStyle != cellStyle) {
        _cellStyle = cellStyle;
        if (cellStyle == WTVPUGCProfileCellStyle_1) {
            self.playView.jp_origin = CGPointMake(JPScaleValue(16), JPScaleValue(60));
        } else if (cellStyle == WTVPUGCProfileCellStyle_2) {
            self.playView.jp_origin = CGPointMake(JPScaleValue(16), JPScaleValue(12));
        }
    }
    
    BOOL iconViewHidden = NO;
    BOOL leftBottomBtnHidden = NO;
    CGFloat bottomViewY = self.playView.jp_maxY;
    if (cellStyle == WTVPUGCProfileCellStyle_1) {
        [self createIconView];
        [self createZanCollectForwardBtns];
        bottomViewY += JP5Margin;
    } else if (cellStyle == WTVPUGCProfileCellStyle_2) {
        if (isNoPugcStyle) {
            [self createZanCollectForwardBtns];
            iconViewHidden = YES;
            bottomViewY += JP5Margin;
        } else {
            [self createIconView];
            leftBottomBtnHidden = YES;
            bottomViewY += JPScaleValue(16);
        }
    }
    self.iconView.hidden = iconViewHidden;
    self.bottomView.zanBtn.hidden = leftBottomBtnHidden;
    self.bottomView.collectBtn.hidden = leftBottomBtnHidden;
    self.bottomView.forwardBtn.hidden = leftBottomBtnHidden;
    self.bottomView.jp_y = bottomViewY;
}

#pragma mark - 点击事件

- (void)tapIcon {
    if ([self.delegate respondsToSelector:@selector(tapCellIcon:)]) {
        [self.delegate tapCellIcon:self];
    }
}

- (void)tapFollowBtn {
    if ([self.delegate respondsToSelector:@selector(cellFollowAction:)]) {
        [self.delegate cellFollowAction:self];
    }
}

- (void)tapCetegoryLabel {
    if ([self.delegate respondsToSelector:@selector(cetegoryAction:)]) {
        [self.delegate cetegoryAction:self];
    }
}

- (void)tapCell {
    if ([self.delegate respondsToSelector:@selector(tapCellEmptyPlace:)]) {
        [self.delegate tapCellEmptyPlace:self];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view == self.contentView) {
        CGPoint point = [gestureRecognizer locationInView:self.contentView];
        if (CGRectContainsPoint(self.bottomView.frame, point)) {
            point = [self.contentView convertPoint:point toView:self.bottomView];
            if ((self.bottomView.zanBtn && !self.bottomView.zanBtn.hidden && CGRectContainsPoint(self.bottomView.zanBtn.frame, point)) ||
                (self.bottomView.collectBtn && !self.bottomView.collectBtn.hidden && CGRectContainsPoint(self.bottomView.collectBtn.frame, point)) ||
                (self.bottomView.forwardBtn && !self.bottomView.forwardBtn.hidden && CGRectContainsPoint(self.bottomView.forwardBtn.frame, point)) ||
                CGRectContainsPoint(self.bottomView.commentBtn.frame, point) ||
                CGRectContainsPoint(self.bottomView.moreBtn.frame, point)) {
                return NO;
            }
        } else if (CGRectContainsPoint(self.playView.frame, point)) {
            return NO;
        }
    } else if (gestureRecognizer.view == self.playView) {
        return NO;
    }
    return YES;
}

@end
