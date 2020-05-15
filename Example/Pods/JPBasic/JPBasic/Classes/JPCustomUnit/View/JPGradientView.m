//
//  JPGradientView.m
//  WoLive
//
//  Created by 周健平 on 2018/11/27.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import "JPGradientView.h"

@implementation JPGradientView

+ (Class)layerClass {
    return CAGradientLayer.class;
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

@end
