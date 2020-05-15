//
//  JPMaskButton.m
//  WoTV
//
//  Created by 周健平 on 2018/12/6.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import "JPMaskButton.h"
#import "JPMacro.h"

@implementation JPMaskButton

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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.imageView addObserver:self forKeyPath:JPKeyPath(self.imageView, layer.opacity) options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.layer.mask) {
        CGFloat opacity = [change[NSKeyValueChangeNewKey] doubleValue];
        self.layer.mask.opacity = opacity;
    }
}

- (void)dealloc {
    [self.imageView removeObserver:self forKeyPath:JPKeyPath(self.imageView, layer.opacity)];
}

@end
