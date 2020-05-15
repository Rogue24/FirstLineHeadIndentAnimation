//
//  JPBadgeLabel.m
//  WoLive
//
//  Created by 周健平 on 2018/10/19.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import "JPBadgeLabel.h"
#import "JPSolveTool.h"
#import "UIColor+JPExtension.h"
#import "UIView+JPPOP.h"

@implementation JPBadgeLabel
{
    CGFloat _hideScale;
}

+ (JPBadgeLabel *)baseBadgeLabel {
    JPBadgeLabel *badgeLabel = ({
        CGFloat w = JPScaleValue(20);
        CGFloat h = w;
        JPBadgeLabel *aLabel = [[JPBadgeLabel alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        aLabel.textAlignment = NSTextAlignmentCenter;
        aLabel.font = JPScaleFont(12);
        aLabel.textColor = [UIColor whiteColor];
        aLabel.layer.masksToBounds = YES;
        aLabel.layer.backgroundColor = JPRGBColor(239, 61, 97).CGColor;
        aLabel.layer.cornerRadius = w * 0.5;
        aLabel.layer.borderWidth = 1;
        aLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        aLabel.layer.transform = CATransform3DMakeScale(aLabel->_hideScale, aLabel->_hideScale, 1);
        aLabel.layer.opacity = 0;
        aLabel;
    });
    return badgeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _state = JPBadgeLabelHidingState;
        _hideScale = 0.3;
    }
    return self;
}

- (void)setBadgeCount:(NSInteger)badgeCount {
    _badgeCount = badgeCount;
    
    BOOL isHide = badgeCount <= 0;
    
    if (self.state == JPBadgeLabelHidingState) {
        self.text = [NSString stringWithFormat:@"%zd", badgeCount];
        if (isHide) return;
        
        POPSpringAnimation *opacityAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        opacityAnim.springSpeed = 20;
        opacityAnim.springBounciness = 15;
        opacityAnim.toValue = @1;
        
        POPSpringAnimation *scaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnim.springSpeed = 20;
        scaleAnim.springBounciness = 15;
        scaleAnim.toValue = @(CGPointMake(1, 1));
        
        [self.layer pop_addAnimation:opacityAnim forKey:@"LayerOpacity"];
        [self.layer pop_addAnimation:scaleAnim forKey:@"LayerScaleXY"];
        self.state = JPBadgeLabelShowingState;
        
    } else if (self.state == JPBadgeLabelShowingState) {
        if (isHide) {
            POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
            opacityAnim.duration = 0.15;
            opacityAnim.toValue = @0;
            opacityAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                self.text = [NSString stringWithFormat:@"%zd", badgeCount];
            };
            
            POPBasicAnimation *scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnim.duration = 0.15;
            scaleAnim.toValue = @(CGPointMake(_hideScale, _hideScale));
            
            [self.layer pop_addAnimation:opacityAnim forKey:@"LayerOpacity"];
            [self.layer pop_addAnimation:scaleAnim forKey:@"LayerScaleXY"];
            self.state = JPBadgeLabelHidingState;
        } else {
            POPBasicAnimation *basicAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            basicAnim.duration = 0.025;
            basicAnim.toValue = @(CGPointMake(0.75, 0.75));
            basicAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                self.text = [NSString stringWithFormat:@"%zd", badgeCount];
                POPSpringAnimation *scaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnim.springSpeed = 20;
                scaleAnim.springBounciness = 15;
                scaleAnim.toValue = @(CGPointMake(1, 1));
                [self.layer pop_addAnimation:scaleAnim forKey:@"LayerScaleXY"];
            };
            [self.layer pop_addAnimation:basicAnim forKey:@"LayerScaleXY"];
        }
    }
}

@end
