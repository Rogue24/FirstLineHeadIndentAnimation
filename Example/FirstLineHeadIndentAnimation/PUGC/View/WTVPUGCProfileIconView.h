//
//  WTVPUGCProfileIconView.h
//  WoTV
//
//  Created by 周健平 on 2020/5/12.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTVPUGCProfileIcon.h"

@interface WTVPUGCProfileIconView : UIView
+ (CGFloat)iconWH;
+ (instancetype)iconView;
@property (nonatomic, strong) WTVPUGCProfileIcon *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIView *followBtnLine;
@property (nonatomic, assign) BOOL isNotNeedFollow;
- (void)setIsFollowed:(BOOL)isFollowed animated:(BOOL)isAnimated;
@end
