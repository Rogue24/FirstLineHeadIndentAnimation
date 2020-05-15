//
//  JPMaskView.m
//  WoTV
//
//  Created by 周健平 on 2018/12/6.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import "JPMaskView.h"

@implementation JPMaskView

- (void)setMaskImage:(UIImage *)maskImage {
    _maskImage = maskImage;
    if (maskImage) {
        CALayer *maskLayer = self.layer.mask;
        if (!maskLayer) {
            maskLayer = [CALayer layer];
            maskLayer.contentsGravity = kCAGravityCenter;
            maskLayer.contentsScale = [UIScreen mainScreen].scale;
            self.layer.mask = maskLayer;
        }
        maskLayer.contents = (id)maskImage.CGImage;
    } else {
        self.layer.mask = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.mask.frame = self.bounds;
}

@end
