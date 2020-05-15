//
//  WTVPUGCProfileIcon.h
//  WoTV
//
//  Created by 周健平 on 2020/4/17.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTVPUGCProfileIcon : UIView
- (instancetype)initWithFrame:(CGRect)frame logoWH:(CGFloat)logoWH;
- (instancetype)initWithLogoWH:(CGFloat)logoWH;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *logoView;

- (void)showLogo:(BOOL)isAnimated;
- (void)hideLogo:(BOOL)isAnimated;

@property (nonatomic, assign) BOOL isLiving;
- (void)setIsLiving:(BOOL)isLiving animated:(BOOL)isAnimated;
@end

