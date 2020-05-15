//
//  WTVPUGCProfilePlayView.m
//  WoTV
//
//  Created by 周健平 on 2020/5/12.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "WTVPUGCProfilePlayView.h"
#import "WTVPUGCOptionButton.h"

@interface WTVPUGCProfilePlayView ()
@property (nonatomic, weak) CALayer *shadowLayer;
@property (nonatomic, strong) NSMutableArray *livingLayers;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, weak) UIView *pursueView;
@end
@implementation WTVPUGCProfilePlayView
{
    BOOL _playerTouching;
    BOOL _isFollowed;
    BOOL _isLiving;
    CGFloat _topSubviewSpace;
}

+ (CGFloat)topSubviewHeight {
    return JPScaleValue(21);
}
+ (CGFloat)topSubviewSpace {
    return JPScaleValue(4);
}
+ (UIFont *)videoTitleFont {
    return JPScaleBoldFont(18);
}
+ (UIColor *)videoTitleColor {
    return UIColor.whiteColor;
}
+ (CGFloat)videoTitleMaxWidth {
    return JPPortraitScreenWidth - JPScaleValue(16) * 2 - JP12Margin * 2;
}
+ (NSUInteger)videoTitleMaxRows {
    return 2;
}

+ (UIFont *)bottomLabelFont {
    return JPScaleFont(10);
}
+ (CGFloat)bottomLabelMinWidth {
    return JPScaleValue(36);
}

+ (CGSize)viewSizeWithIsVerVideo:(BOOL)isVerVideo isRelate:(BOOL)isRelate {
    CGFloat w = JPPortraitScreenWidth - JPScaleValue(16) * 2;
    CGFloat h = isVerVideo ? (w * 1.14) : (w * (9.0 / 16.0));
    if (isRelate) h += JPScaleValue(62);
    return CGSizeMake(w, h);
}

+ (instancetype)playView {
    CGFloat w = JPPortraitScreenWidth - JPScaleValue(16) * 2;
    CGFloat h = w * (9.0 / 16.0);
    return [[self alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scale = 0.98;
        self.scaleDuration = 0.2;
        self.recoverSpeed = 20;
        self.recoverBounciness = 15;
        _topSubviewSpace = self.class.topSubviewSpace;
        
        CGFloat cornerRadius = JPScaleValue(6);
        
        CALayer *shadowLayer = [CALayer layer];
        shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius].CGPath;
        shadowLayer.shadowOffset = CGSizeMake(0, 2);
        shadowLayer.shadowRadius = 5;
        shadowLayer.shadowColor = UIColor.blackColor.CGColor;
        shadowLayer.shadowOpacity = 0.2;
        [self.layer addSublayer:shadowLayer];
        self.shadowLayer = shadowLayer;
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = UIColor.whiteColor;
        contentView.clipsToBounds = YES;
        contentView.layer.cornerRadius = cornerRadius;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.contentView = contentView;
        
        UIImageView *coverView = ({
            UIImageView *aImgView = [[UIImageView alloc] initWithFrame:self.bounds];
            aImgView.contentMode = UIViewContentModeScaleAspectFill;
            aImgView.backgroundColor = UIColor.lightGrayColor;
            aImgView;
        });
        coverView.userInteractionEnabled = YES;
        [contentView addSubview:coverView];
        self.coverView = coverView;
        
        CGFloat wh = floor(JPScaleValue(36));
        UIView *playBtn = [[UIView alloc] init];
        playBtn.layer.cornerRadius = JP8Margin;
        playBtn.backgroundColor = JPRGBAColor(0, 0, 0, 0.6);
        UIImageView *playIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_icon_play"]];
        [playBtn addSubview:playIcon];
        [playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(CGSizeMake(JPScaleValue(15), JPScaleValue(15))));
            make.centerY.equalTo(playBtn);
            make.centerX.equalTo(playBtn).offset(1);
        }];
        [coverView addSubview:playBtn];
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(CGSizeMake(wh, wh)));
            make.left.equalTo(@(JP10Margin));
            make.bottom.equalTo(@(-JP8Margin));
        }];
        self.playBtn = playBtn;
        
        UIImageView *shadowView = ({
            UIImage *shadowImage = [UIImage imageNamed:@"rect_shadow"];
            UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width * (shadowImage.size.height / shadowImage.size.width))];
            aImgView.image = shadowImage;
            aImgView;
        });
        [contentView addSubview:shadowView];
        self.shadowView = shadowView;
        
        CGFloat topSubviewHeight = self.class.topSubviewHeight;
        
        UIFont *videoTitleFont = self.class.videoTitleFont;
        NSUInteger videoTitleRows = self.class.videoTitleMaxRows;
        CGFloat videoTitleW = self.class.videoTitleMaxWidth;
        CGFloat videoTitleH = videoTitleFont.lineHeight * videoTitleRows;
        CGFloat videoTitleY = JPHalfOfDiff(topSubviewHeight, videoTitleFont.lineHeight);
        
        CGFloat x = JP12Margin;
        CGFloat y = JP10Margin;
        CGFloat w = videoTitleW;
        CGFloat h = videoTitleY + videoTitleH + videoTitleY;
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        topView.clipsToBounds = NO;
        [contentView addSubview:topView];
        self.topView = topView;
        
        x = 0;
        y = videoTitleY;
        h = videoTitleH;
        YYLabel *titleLabel = [YYLabel new];
        titleLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        titleLabel.displaysAsynchronously = YES;
//        titleLabel.ignoreCommonProperties = YES; // 需要刷新exclusionPaths，这个属性不能为YES
        titleLabel.fadeOnHighlight = NO;
        titleLabel.fadeOnAsynchronouslyDisplay = NO;
        titleLabel.frame = CGRectMake(x, y, w, h);
        titleLabel.clipsToBounds = NO;
        titleLabel.userInteractionEnabled = NO;
        [topView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = UIColor.clearColor;
        [contentView addSubview:bottomView];
        self.bottomView = bottomView;
        
        UILabel *durationLabel = ({
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.font = self.class.bottomLabelFont;
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.textColor = UIColor.whiteColor;
            aLabel.text = @"05:30";
            aLabel.backgroundColor = JPRGBAColor(0, 0, 0, 0.6);
            aLabel.layer.cornerRadius = JPScaleValue(4);
            aLabel.layer.masksToBounds = YES;
            aLabel;
        });
        [bottomView addSubview:durationLabel];
        self.durationLabel = durationLabel;
        
        UILabel *cetegoryLabel = ({
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.font = self.class.bottomLabelFont;
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.textColor = UIColor.whiteColor;
            aLabel.text = @"帅气";
            aLabel.backgroundColor = JPRGBAColor(0, 0, 0, 0.6);
            aLabel.layer.cornerRadius = JPScaleValue(4);
            aLabel.layer.masksToBounds = YES;
            aLabel;
        });
        [bottomView addSubview:cetegoryLabel];
        self.cetegoryLabel = cetegoryLabel;
        
        JPObserveNotification(self, @selector(appDidEnterBackground), UIApplicationWillResignActiveNotification, nil);
        JPObserveNotification(self, @selector(appDidEnterPlayground), UIApplicationDidBecomeActiveNotification, nil);
    }
    return self;
}
- (void)dealloc {
    JPRemoveNotification(self);
    [self removeLink];
}

#pragma mark - 直播、关注状态的动画、标题处理

- (void)setIsFollowed:(BOOL)isFollowed isLiving:(BOOL)isLiving {
    [self removeLink];
    if (_isFollowed == isFollowed && _isLiving == isLiving) return;
    _isFollowed = isFollowed;
    _isLiving = isLiving;
    
    CGFloat followedViewX = 0;
    
    if (isLiving) {
        if (!self.livingView) [self createLivingView];
        [self addLivingAnim];
        self.livingView.jp_x = 0;
        self.livingView.alpha = 1;
        followedViewX = self.livingView.jp_maxX + _topSubviewSpace;
    } else {
        [self removeLivingAnim];
        self.livingView.alpha = 0;
    }
    
    if (isFollowed) {
        if (!self.followedView) [self createFollowedView];
        self.followedView.jp_x = followedViewX;
        self.followedView.alpha = 1;
    } else {
        self.followedView.alpha = 0;
    }
}

- (void)setTitleLayout:(YYTextLayout *)titleLayout {
    [self removeLink];
    self.titleLabel.textLayout = titleLayout;
    self.pursueView = _isFollowed ? self.followedView : (_isLiving ? self.livingView : nil);
    [self updateTitleLabelExclusionPaths];
}

- (void)addLink {
    [self removeLink];
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTitleLabelExclusionPaths)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLink {
    if (self.link) {
        [self.link invalidate];
        self.link = nil;
    }
}

- (void)updateTitleLabelExclusionPaths {
    if (self.pursueView) {
        CGFloat w = (self.link ? self.pursueView.layer.presentationLayer.jp_maxX : self.pursueView.jp_maxX) + _topSubviewSpace;
        self.titleLabel.exclusionPaths = @[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, w, 1)]];
    } else {
        self.titleLabel.exclusionPaths = nil;
    }
}

- (void)setIsFollowed:(BOOL)isFollowed animated:(BOOL)isAnimated {
    if (_isFollowed == isFollowed) {
        return;
    }
    _isFollowed = isFollowed;
    
    CGFloat alpha = 0;
    CGFloat x = _isLiving ? (self.livingView.jp_maxX + _topSubviewSpace) : 0;
    if (isFollowed) {
        if (!self.followedView) [self createFollowedView];
        alpha = 1;
    } else {
        x -= (self.followedView.jp_width + _topSubviewSpace);
    }
    
    self.pursueView = self.followedView ? self.followedView : self.livingView;
    
    if (isAnimated) {
        if (isFollowed) {
            self.followedView.alpha = 0;
            self.followedView.jp_x = x - (self.followedView.jp_width + _topSubviewSpace);
        }
        self.titleLabel.displaysAsynchronously = NO;
        [self addLink];
        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:kNilOptions animations:^{
            self.followedView.alpha = alpha;
            self.followedView.jp_x = x;
        } completion:^(BOOL finished) {
            [self removeLink];
            [self updateTitleLabelExclusionPaths];
            self.titleLabel.displaysAsynchronously = YES;
        }];
    } else {
        [self removeLink];
        self.followedView.alpha = alpha;
        self.followedView.jp_x = x;
        [self updateTitleLabelExclusionPaths];
    }
}
- (BOOL)isFollowed {
    return _isFollowed;
}

- (void)setIsLiving:(BOOL)isLiving animated:(BOOL)isAnimated {
    if (_isLiving == isLiving) {
        return;
    }
    _isLiving = isLiving;
    
    CGFloat alpha = 0;
    CGFloat x = 0;
    CGFloat followedViewX = 0;
    
    if (isLiving) {
        if (!self.livingView) [self createLivingView];
        [self addLivingAnim];
        alpha = 1;
        followedViewX = self.livingView.jp_width + _topSubviewSpace;
    } else {
        x -= (self.livingView.jp_width + _topSubviewSpace);
    }
    
    self.pursueView = _isFollowed ? self.followedView : self.livingView;
    
    if (isAnimated) {
        if (isLiving) {
            self.livingView.alpha = 0;
            self.livingView.jp_x = x - (self.livingView.jp_width + _topSubviewSpace);
        }
        self.titleLabel.displaysAsynchronously = NO;
        [self addLink];
        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:kNilOptions animations:^{
            self.livingView.alpha = alpha;
            self.livingView.jp_x = x;
            self.followedView.jp_x = followedViewX;
        } completion:^(BOOL finished) {
            [self removeLink];
            if (!self->_isLiving) [self removeLivingAnim];
            [self updateTitleLabelExclusionPaths];
            self.titleLabel.displaysAsynchronously = YES;
        }];
    } else {
        [self removeLink];
        if (!_isLiving) [self removeLivingAnim];
        self.livingView.alpha = alpha;
        self.livingView.jp_x = x;
        self.followedView.jp_x = followedViewX;
        [self updateTitleLabelExclusionPaths];
    }
}
- (BOOL)isLiving {
    return _isLiving;
}

- (void)createFollowedView {
    UIView *followedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JPScaleValue(48), self.class.topSubviewHeight)];
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.colors = @[(id)JPRGBColor(255, 191, 0).CGColor, (id)JPRGBColor(255, 151, 0).CGColor];
    gLayer.startPoint = CGPointMake(0, 0.5);
    gLayer.endPoint = CGPointMake(1, 0.5);
    gLayer.cornerRadius = JPScaleValue(4);
    gLayer.frame = followedView.bounds;
    [followedView.layer addSublayer:gLayer];
    UILabel *titleLabe = ({
        UILabel *aLabel = [[UILabel alloc] initWithFrame:followedView.bounds];
        aLabel.font = JPScaleFont(12);
        aLabel.textAlignment = NSTextAlignmentCenter;
        aLabel.textColor = UIColor.whiteColor;
        aLabel.text = @"已关注";
        aLabel;
    });
    [followedView addSubview:titleLabe];
    [self.topView addSubview:followedView];
    self.followedView = followedView;
}

- (void)createLivingView {
    UIView *livingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JPScaleValue(4 + 4 + 38 + 4) + 10, self.class.topSubviewHeight)];
    [self.topView addSubview:livingView];
    self.livingView = livingView;
    
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.colors = @[(id)JPRGBColor(255, 0, 138).CGColor, (id)JPRGBColor(255, 0, 29).CGColor];
    gLayer.startPoint = CGPointMake(0, 0.5);
    gLayer.endPoint = CGPointMake(1, 0.5);
    gLayer.cornerRadius = JPScaleValue(4);
    gLayer.frame = livingView.bounds;
    [livingView.layer addSublayer:gLayer];
    
    CGFloat x = JPScaleValue(4);
    CGFloat w = 10; // JP10Margin;
    CGFloat h = 13; // JPScaleValue(13);
    CGFloat y = JPHalfOfDiff(livingView.jp_height, h);
    CALayer *livingLayer = [CALayer layer];
    livingLayer.frame = CGRectMake(x, y, w, h);
    livingLayer.backgroundColor = UIColor.clearColor.CGColor;
    [livingView.layer addSublayer:livingLayer];
    
    x = livingLayer.jp_maxX + JPScaleValue(4);
    y = 0;
    w = JPScaleValue(38);
    h = livingView.jp_height;
    UILabel *titleLabe = ({
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        aLabel.font = JPScaleFont(12);
        aLabel.textAlignment = NSTextAlignmentCenter;
        aLabel.textColor = UIColor.whiteColor;
        aLabel.text = @"直播中";
        aLabel;
    });
    [livingView addSubview:titleLabe];
    
    self.livingLayers = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        CALayer *layer = [CALayer layer];
        layer.position = CGPointMake(1 + i * 4, 7);
        layer.bounds = CGRectMake(0, 0, 2, 13);
        layer.cornerRadius = 1;
        layer.masksToBounds = YES;
        layer.backgroundColor = UIColor.whiteColor.CGColor;
        [livingLayer addSublayer:layer];
        [self.livingLayers addObject:layer];
    }
}

#pragma mark 直播状态动画

- (void)addLivingAnim {
    if (!_isLiving || self.livingLayers.count != 3) return;
    for (NSInteger i = 0; i < 3; i++) {
        CALayer *layer = self.livingLayers[i];
        
//        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBounds];
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds"];
        
        NSTimeInterval duration = 0.4;
        switch (i) {
            case 0:
                anim.beginTime = CACurrentMediaTime() + duration * 0.8;
                break;
            case 1:
                anim.beginTime = CACurrentMediaTime();
                break;
            case 2:
                anim.beginTime = CACurrentMediaTime() + duration * 0.6;
                break;
            default:
                break;
        }
        
        anim.fromValue = @(CGRectMake(0, 0, 2, 13));
        anim.toValue = @(CGRectMake(0, 5, 2, 3));
        anim.duration = duration;
//        anim.repeatForever = YES;
        anim.repeatCount = NSUIntegerMax;
        anim.autoreverses = YES;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        [layer pop_addAnimation:anim forKey:kPOPViewBounds];
        [layer addAnimation:anim forKey:@"bounds"];
    }
}

- (void)removeLivingAnim {
    for (CALayer *layer in self.livingLayers) {
//        [layer pop_removeAllAnimations];
        [layer removeAllAnimations];
    }
}

#pragma mark - 通知回调

/** 应用退到后台 */
- (void)appDidEnterBackground {
    [self removeLivingAnim];
}

/** 应用进入前台 */
- (void)appDidEnterPlayground {
    [self addLivingAnim];
}

#pragma mark - 竖直、包含关联视频的UI刷新

- (void)createRelateView {
    UIView *relateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.jp_width, JPScaleValue(62))];
    relateView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:relateView];
    self.relateView = relateView;
    
    CGFloat x = JP12Margin;
    CGFloat y = x;
    CGFloat h = relateView.jp_height - 2 * y;
    CGFloat w = h * (16.0 / 9.0);
    UIImageView *relateCoverView = ({
        UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        aImgView.backgroundColor = UIColor.lightGrayColor;
        aImgView.contentMode = UIViewContentModeScaleAspectFill;
        aImgView;
    });
    [relateCoverView jp_addRoundedCornerWithSize:relateCoverView.jp_size radius:JPScaleValue(4) maskColor:relateView.backgroundColor];
    [relateView addSubview:relateCoverView];
    self.relateCoverView = relateCoverView;
    
    w = JPScaleValue(64);
    h = JPScaleValue(30);
    x = relateView.jp_width - w - JP8Margin;
    y = JPHalfOfDiff(relateView.jp_height, h);
    JPBounceView *relatePlayBtn = [[JPBounceView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    relatePlayBtn.scale = 0.88;
    [relateView addSubview:relatePlayBtn];
    self.relatePlayBtn = relatePlayBtn;
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = relatePlayBtn.bounds;
    bgLayer.cornerRadius = JPScaleValue(6);
    bgLayer.backgroundColor = JPRGBAColor(255, 191, 0, 0.2).CGColor;
    [relatePlayBtn.layer addSublayer:bgLayer];
    UILabel *btnTitleLabel = ({
        UILabel *aLabel = [[UILabel alloc] initWithFrame:relatePlayBtn.bounds];
        aLabel.font = JPScaleBoldFont(12);
        aLabel.textAlignment = NSTextAlignmentCenter;
        aLabel.textColor = JPRGBColor(255, 151, 0);
        aLabel.text = @"看正片";
        aLabel;
    });
    [relatePlayBtn addSubview:btnTitleLabel];
    @jp_weakify(self);
    relatePlayBtn.viewTouchUpInside = ^(JPBounceView *bounceView) {
        @jp_strongify(self);
        if (!self) return;
        !self.relatePlayBlock ? : self.relatePlayBlock();
    };
    
    w = h;
    x = relatePlayBtn.jp_x - w - JPScaleValue(4);
    WTVPUGCOptionButton *relatCollectBtn = [WTVPUGCOptionButton collectButton];
    relatCollectBtn.frame = CGRectMake(x, y, w, h);
    relatCollectBtn.layer.cornerRadius = JPScaleValue(6);
    relatCollectBtn.backgroundColor = JPRGBAColor(170, 170, 170, 0.2);
    [relateView addSubview:relatCollectBtn];
    self.relatCollectBtn = relatCollectBtn;
    relatCollectBtn.viewTouchUpInside = ^(JPBounceView *bounceView) {
        @jp_strongify(self);
        if (!self) return;
        !self.relateCollectBlock ? : self.relateCollectBlock();
    };
    
    x = relateCoverView.jp_maxX + JP8Margin;
    w = relatCollectBtn.jp_x - JP8Margin - relateCoverView.jp_maxX - JP8Margin;
    y = JPScaleValue(18);
    h = JPScaleValue(12);
    UILabel *relateTitleLabel = ({
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        aLabel.font = JPScaleBoldFont(12);
        aLabel.textAlignment = NSTextAlignmentLeft;
        aLabel.textColor = JPRGBColor(43, 43, 43);
        aLabel;
    });
    [relateView addSubview:relateTitleLabel];
    self.relateTitleLabel = relateTitleLabel;
    
    y = relateTitleLabel.jp_maxY + JPScaleValue(4);
    h = JPScaleValue(10);
    UILabel *relateInfoLabel = ({
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        aLabel.font = JPScaleFont(10);
        aLabel.textAlignment = NSTextAlignmentLeft;
        aLabel.textColor = JPRGBColor(170, 170, 170);
        aLabel;
    });
    [relateView addSubview:relateInfoLabel];
    self.relateInfoLabel = relateInfoLabel;
}

- (void)setIsVerVideo:(BOOL)isVerVideo isRelate:(BOOL)isRelate {
    if (_isVerVideo == isVerVideo && _isRelate == isRelate) return;
    _isVerVideo = isVerVideo;
    _isRelate = isRelate;
    self.jp_size = [self.class viewSizeWithIsVerVideo:isVerVideo isRelate:isRelate];
    if (isRelate) {
        if (!self.relateView) [self createRelateView];
        self.coverView.jp_height = self.jp_height - self.relateView.jp_height;
    } else {
        self.coverView.jp_height = self.jp_height;
    }
    self.relateView.jp_y = self.coverView.jp_maxY;
    self.shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
}

//#pragma mark - 视频预览
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view == self.bottomView) {
//        return view;
//    }
//    return nil;
//}

- (BOOL)isPlayerTouching:(CGPoint)point {
    if ( (!self.bottomView.hidden && CGRectContainsPoint(self.bottomView.frame, point)) ||
         (self.relateView && CGRectContainsPoint(self.relateView.frame, point))) {
        _playerTouching = NO;
    } else {
        _playerTouching = YES;
    }
    return _playerTouching;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self isPlayerTouching:point]) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self isPlayerTouching:point]) {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_playerTouching) {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_playerTouching) {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end
