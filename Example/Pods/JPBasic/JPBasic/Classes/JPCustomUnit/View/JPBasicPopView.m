//
//  JPBasicPopView.m
//  WoLive
//
//  Created by 周健平 on 2018/9/30.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import "JPBasicPopView.h"
#import "UIColor+JPExtension.h"
#import "UIView+JPExtension.h"
#import "UIView+JPPOP.h"

@interface JPBasicPopView ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation JPBasicPopView

#pragma mark - setter

- (void)setIsAnimating:(BOOL)isAnimating {
    _isAnimating = isAnimating;
    self.userInteractionEnabled = !isAnimating;
}

#pragma mark - getter

- (UIView *)bgView {
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = JPRGBAColor(0, 0, 0, 0);
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBgView)]];
        [self insertSubview:bgView atIndex:0];
        _bgView = bgView;
    }
    return _bgView;
}

#pragma mark - control action

- (void)didClickBgView {
    [self removeFromWindow];
}

#pragma mark - window

static UIWindow *jpWindow_;

- (UIWindow *)jp_window {
    return jpWindow_;
}

- (void)addToWindow {
    jpWindow_.hidden = YES;
    jpWindow_ = [[UIWindow alloc] init];
    jpWindow_.frame = [UIScreen mainScreen].bounds;
    jpWindow_.backgroundColor = [UIColor clearColor];
    jpWindow_.windowLevel = UIWindowLevelNormal;
    jpWindow_.rootViewController = [UIViewController new];
    jpWindow_.hidden = NO;
    [jpWindow_ makeKeyWindow];
    [jpWindow_ addSubview:self];
}

- (void)removeFromWindow {
    [self removeFromSuperview];
    jpWindow_.hidden = YES;
    jpWindow_ = nil;
}

#pragma mark - 动画

- (void)bgViewAnimatedForShow:(BOOL)forShow {
    UIColor *bgColor = forShow ? JPRGBAColor(0, 0, 0, 0.5) : JPRGBAColor(0, 0, 0, 0.0);
    [self.bgView jp_addPOPBasicAnimationWithPropertyNamed:kPOPViewBackgroundColor toValue:bgColor duration:0.3];
}

- (void)rotationAnimation:(BOOL)forShow complete:(nullable void(^)(BOOL isShowed))complete {
    if (self.isAnimating /*&& forShow*/) return;
    self.isAnimating = YES;
    
    if (forShow) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.contentView.layer.position = CGPointMake(self.jp_width * 0.5, -self.contentView.jp_height * 0.65);
        self.contentView.layer.transform = CATransform3DMakeRotation(M_PI_4 / 8.0, 0, 0, 1);
        [CATransaction commit];
    }
    
    CGFloat posY = forShow ? (self.jp_height * 0.5) : (self.jp_height + self.contentView.jp_height * 0.65);
    CGFloat angle = forShow ? 0 : -(M_PI_4 / 8.0);
    
    __block BOOL posYFinish = NO;
    __block BOOL rotationFinish = NO;
    void (^allAnimtedFinish)(BOOL posYisFinish, BOOL rotationIsFinish) = ^(BOOL posYisFinish, BOOL rotationIsFinish) {
        if (posYisFinish && rotationIsFinish) {
            self.isAnimating = NO;
            !complete ? : complete(forShow);
        }
    };
    
    POPSpringAnimation *posYAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    posYAnim.springBounciness = 8;
    posYAnim.springSpeed = 6;
    posYAnim.toValue = @(posY);
    posYAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        posYFinish = YES;
        allAnimtedFinish(posYFinish, rotationFinish);
    };
    
    POPBasicAnimation *rotationAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnim.beginTime = CACurrentMediaTime() + (forShow ? 0.1 : 0);
    rotationAnim.duration = 0.35;
    rotationAnim.toValue = @(angle);
    rotationAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        rotationFinish = YES;
        allAnimtedFinish(posYFinish, rotationFinish);
    };
    
    [self bgViewAnimatedForShow:forShow];
    [self.contentView.layer pop_addAnimation:posYAnim forKey:@"AnimationScale"];
    [self.contentView.layer pop_addAnimation:rotationAnim forKey:@"AnimateRotation"];
}

- (void)scalePopAnimation:(BOOL)forShow complete:(nullable void(^)(BOOL isShowed))complete {
    if (self.isAnimating /*&& forShow*/) return;
    self.isAnimating = YES;
    
    if (forShow) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.contentView.layer.opacity = 0;
        self.contentView.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
        [CATransaction commit];
    }
    
    CGFloat opacity = forShow ? 1 : 0;
    CGPoint scale = forShow ? CGPointMake(1, 1) : CGPointMake(0.25, 0.25);
    
    __block BOOL opacityFinish = NO;
    __block BOOL scaleFinish = NO;
    void (^allAnimtedFinish)(BOOL opacityIsFinish, BOOL scaleIsFinish) = ^(BOOL opacityIsFinish, BOOL scaleIsFinish) {
        if (opacityIsFinish && scaleIsFinish) {
            self.isAnimating = NO;
            !complete ? : complete(forShow);
        }
    };
    
    POPBasicAnimation *anim2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    anim2.duration = 0.25;
    anim2.toValue = @(opacity);
    anim2.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        opacityFinish = YES;
        allAnimtedFinish(opacityFinish, scaleFinish);
    };
    
    POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim1.springSpeed = 8;
    anim1.springBounciness = 8;
    anim1.toValue = @(scale);
    anim1.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        scaleFinish = YES;
        allAnimtedFinish(opacityFinish, scaleFinish);
    };
    
    [self bgViewAnimatedForShow:forShow];
    [self.contentView.layer pop_addAnimation:anim2 forKey:@"LayerOpacity"];
    [self.contentView.layer pop_addAnimation:anim1 forKey:@"LayerScaleXY"];
}


@end
