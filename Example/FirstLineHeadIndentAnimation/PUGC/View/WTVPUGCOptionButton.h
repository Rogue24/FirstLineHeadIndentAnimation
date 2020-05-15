//
//  WTVPUGCOptionButton.h
//  WoTV
//
//  Created by 周健平 on 2020/4/22.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "JPBounceView.h"

@interface WTVPUGCOptionButton : JPBounceView
+ (CGSize)buttonSize;
+ (instancetype)zanButton;
+ (instancetype)collectButton;
+ (instancetype)forwardButton;
+ (instancetype)commentButton;
+ (instancetype)moreButton;

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *countLabel;

@property (nonatomic, strong) NSString *normalIcon;
@property (nonatomic, strong) NSString *selectIcon;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;

- (void)setCountStr:(NSString *)countStr;
- (NSString *)countStr;

@property (nonatomic, assign) BOOL isSelected;
- (void)setIsSelected:(BOOL)isSelected animated:(BOOL)isAnamated;
@end
