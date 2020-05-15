//
//  UIApplication+JPExtension.m
//  Infinitee2.0
//
//  Created by 周健平 on 2019/7/11.
//  Copyright © 2019 Infinitee. All rights reserved.
//

#import "UIApplication+JPExtension.h"
#import "NSObject+JPExtension.h"

@implementation UIApplication (JPExtension)

+ (void)load {
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self jp_swizzleInstanceMethodsWithOriginalSelector:@selector(setStatusBarStyle:)
                                               swizzledSelector:@selector(jp_setStatusBarStyle:)];
            [self jp_swizzleInstanceMethodsWithOriginalSelector:@selector(setStatusBarStyle:animated:)
                                               swizzledSelector:@selector(jp_setStatusBarStyle:animated:)];
        });
    }
}

- (void)jp_setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if (@available(iOS 13.0, *)) {
        if (statusBarStyle == UIBarStyleDefault) {
            if ([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleLight) {
                statusBarStyle = UIStatusBarStyleDarkContent;
            } else {
                statusBarStyle = UIStatusBarStyleLightContent;
            }
        }
    }
    [self jp_setStatusBarStyle:statusBarStyle];
}

- (void)jp_setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated {
    if (@available(iOS 13.0, *)) {
        if (statusBarStyle == UIBarStyleDefault) {
            if ([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleLight) {
                statusBarStyle = UIStatusBarStyleDarkContent;
            } else {
                statusBarStyle = UIStatusBarStyleLightContent;
            }
        }
    }
    [self jp_setStatusBarStyle:statusBarStyle animated:animated];
}

@end
