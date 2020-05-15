//
//  WTVPUGCProfileIcon.m
//  WoTV
//
//  Created by 周健平 on 2020/4/17.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "WTVPUGCProfileIcon.h"

@interface WTVPUGCProfileIcon () <CAAnimationDelegate>
@property (nonatomic, weak) CAGradientLayer *gLayer;
@property (nonatomic, weak) CALayer *bgLayer;
@property (nonatomic, weak) CAShapeLayer *liveLayer;
@property (nonatomic, weak) CAShapeLayer *livingLayer;
@end

@implementation WTVPUGCProfileIcon
{
    CGRect _iconBounds;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_icon_colours"]];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] init];
        _logoView.alpha = 0;
        [self addSubview:_logoView];
    }
    return _logoView;
}

- (instancetype)initWithFrame:(CGRect)frame logoWH:(CGFloat)logoWH {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        
        self.imageView.frame = self.bounds;
        
        CGFloat diffXY = JPScaleValue(2);
        self.logoView.frame = CGRectMake(self.jp_width - logoWH + diffXY,
                                         self.jp_height - logoWH + diffXY,
                                         logoWH,
                                         logoWH);
    }
    return self;
}

- (instancetype)initWithLogoWH:(CGFloat)logoWH {
    if (self = [super init]) {
        self.clipsToBounds = NO;
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGFloat diffXY = JPScaleValue(2);
        [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(logoWH));
            make.right.bottom.equalTo(self).offset(diffXY);
        }];
    }
    return self;
}

- (void)dealloc {
    [self.liveLayer removeAllAnimations];
    [self.imageView.layer pop_removeAllAnimations];
}

- (void)showLogo:(BOOL)isAnimated {
    [self updateLogo:NO animated:isAnimated];
}
- (void)hideLogo:(BOOL)isAnimated {
    [self updateLogo:YES animated:isAnimated];
}
- (void)updateLogo:(BOOL)isHide animated:(BOOL)isAnimated {
    CGFloat alpha = isHide ? 0 : 1;
    if (self.logoView.alpha == alpha) return;
    CGFloat scale = isHide ? 0.1 : 1;
    if (isAnimated) {
        [self.logoView jp_addPOPBasicAnimationWithPropertyNamed:kPOPViewAlpha toValue:@(alpha) duration:0.15];
        CGFloat fromScale = isHide ? 1 : 0.1;
        [self.logoView jp_addPOPSpringAnimationWithPropertyNamed:kPOPViewScaleXY fromValue:@(CGPointMake(fromScale, fromScale)) toValue:@(CGPointMake(scale, scale)) springSpeed:20 springBounciness:10 beginTime:0 completionBlock:nil];
    } else {
        self.logoView.transform = CGAffineTransformMakeScale(scale, scale);
        self.logoView.alpha = alpha;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isLiving && self.gLayer && !CGRectEqualToRect(_iconBounds, self.bounds)) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.liveLayer removeAllAnimations];
        [self updateLiveLayerLayout];
        [CATransaction commit];
        [self addShapeAnim];
    }
}

- (void)setIsLiving:(BOOL)isLiving {
    [self setIsLiving:isLiving animated:NO];
}

- (void)updateLiveLayerLayout {
    _iconBounds = self.bounds;
    self.gLayer.frame = CGRectInset(_iconBounds, -9, -9);
    self.bgLayer.frame = self.gLayer.bounds;
    self.liveLayer.path = self.livingLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(9, 9, _iconBounds.size.width, _iconBounds.size.height), -3, -3)].CGPath;
}

- (void)setIsLiving:(BOOL)isLiving animated:(BOOL)isAnimated {
    if (_isLiving == isLiving) return;
    _isLiving = isLiving;
    
    if (isLiving) {
        
        if (!self.gLayer) {
            CAGradientLayer *gLayer = [CAGradientLayer layer];
            gLayer.startPoint = CGPointMake(0, 0);
            gLayer.endPoint = CGPointMake(1, 1);
            gLayer.colors = @[(id)JPRGBColor(255, 0, 138).CGColor, (id)JPRGBColor(255, 0, 29).CGColor];
            [self.layer insertSublayer:gLayer below:self.logoView.layer];
            self.gLayer = gLayer;
            
            CALayer *bgLayer = [CALayer layer];
            bgLayer.backgroundColor = UIColor.clearColor.CGColor;
            gLayer.mask = bgLayer;
            self.bgLayer = bgLayer;
            
            CAShapeLayer *liveLayer = [CAShapeLayer layer];
            [bgLayer addSublayer:liveLayer];
            self.liveLayer = liveLayer;
            
            CAShapeLayer *livingLayer = [CAShapeLayer layer];
            [bgLayer addSublayer:livingLayer];
            self.livingLayer = livingLayer;
            
            liveLayer.fillColor = livingLayer.fillColor = UIColor.clearColor.CGColor;
            liveLayer.strokeColor = livingLayer.strokeColor = UIColor.blackColor.CGColor;
            liveLayer.lineWidth = livingLayer.lineWidth = 2;
        } else if (!self.gLayer.hidden) {
            return;
        }
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self updateLiveLayerLayout];
        self.gLayer.hidden = NO;
        self.gLayer.opacity = isAnimated ? 0 : 1;
        [CATransaction commit];
        
        if (self.logoView.image) [self hideLogo:isAnimated];
        
        if (isAnimated) {
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
            anim.fillMode = kCAFillModeBackwards;
            anim.fromValue = @0;
            anim.toValue = @1;
            anim.duration = 0.2;
            [self.gLayer addAnimation:anim forKey:@"opacity"];
            self.gLayer.opacity = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addScaleAnim];
                [self addShapeAnim];
            });
            
        } else {
            [self addScaleAnim];
            [self addShapeAnim];
        }
        
    } else {
        if (self.logoView.image) [self showLogo:isAnimated];
        
        if (!self.gLayer || self.gLayer.hidden) {
            return;
        }
        
        if (isAnimated) {
            POPSpringAnimation *anim4 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            anim4.toValue = @(CGPointMake(1, 1));
            anim4.springSpeed = 5;
            anim4.springBounciness = 5;
            [self.imageView.layer pop_addAnimation:anim4 forKey:kPOPLayerScaleXY];
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
            anim.fillMode = kCAFillModeBackwards;
            anim.fromValue = @1;
            anim.toValue = @0;
            anim.duration = 0.2;
            [self.gLayer addAnimation:anim forKey:@"opacity"];
            self.gLayer.opacity = 0;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.imageView.layer pop_removeAllAnimations];
                self.imageView.layer.transform = CATransform3DIdentity;
                [self.liveLayer removeAllAnimations];
                self.gLayer.hidden = YES;
            });
            
        } else {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [self.imageView.layer pop_removeAllAnimations];
            self.imageView.layer.transform = CATransform3DIdentity;
            [self.liveLayer removeAllAnimations];
            self.gLayer.hidden = YES;
            [CATransaction commit];
        }
    }
}

- (void)addScaleAnim {
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.toValue = @(CGPointMake(0.96, 0.96));
    anim.autoreverses = YES;
    anim.repeatForever = YES;
    anim.duration = 0.5;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.imageView.layer pop_addAnimation:anim forKey:kPOPLayerScaleXY];
}

- (void)addShapeAnim {
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"path"];
    anim1.toValue = (id)[UIBezierPath bezierPathWithOvalInRect:self.gLayer.bounds].CGPath;
    anim1.duration = 1;
    anim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    anim2.toValue = @0.333;
    anim2.duration = 1;
    anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *anim3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim3.toValue = @0;
    anim3.duration = 0.3;
    anim3.beginTime = CACurrentMediaTime() + 0.7;
    
    anim1.delegate = self;
    
    [self.liveLayer addAnimation:anim1 forKey:@"path"];
    [self.liveLayer addAnimation:anim2 forKey:@"lineWidth"];
    [self.liveLayer addAnimation:anim3 forKey:@"opacity"];
}

#pragma mark - <CAAnimationDelegate>

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self addShapeAnim];
    }
}

@end
