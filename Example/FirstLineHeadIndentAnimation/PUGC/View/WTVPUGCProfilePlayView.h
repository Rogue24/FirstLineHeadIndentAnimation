//
//  WTVPUGCProfilePlayView.h
//  WoTV
//
//  Created by 周健平 on 2020/5/12.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "JPBounceView.h"
#import "YYText.h"
@class WTVPUGCOptionButton;

@interface WTVPUGCProfilePlayView : JPBounceView

+ (CGFloat)topSubviewHeight;
+ (CGFloat)topSubviewSpace;
+ (UIFont *)videoTitleFont;
+ (UIColor *)videoTitleColor;
+ (CGFloat)videoTitleMaxWidth;
+ (NSUInteger)videoTitleMaxRows;
+ (UIFont *)bottomLabelFont;
+ (CGFloat)bottomLabelMinWidth;
+ (CGSize)viewSizeWithIsVerVideo:(BOOL)isVerVideo isRelate:(BOOL)isRelate;

+ (instancetype)playView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *coverView;
@property (nonatomic, weak) UIImageView *shadowView;
@property (nonatomic, weak) UIView *playBtn;

@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) YYLabel *titleLabel;
- (void)setTitleLayout:(YYTextLayout *)titleLayout;
@property (nonatomic, weak) UIView *followedView;
@property (nonatomic, weak) UIView *livingView;
- (void)setIsFollowed:(BOOL)isFollowed isLiving:(BOOL)isLiving;
- (void)setIsFollowed:(BOOL)isFollowed animated:(BOOL)isAnimated;
- (void)setIsLiving:(BOOL)isLiving animated:(BOOL)isAnimated;
- (BOOL)isFollowed;
- (BOOL)isLiving;

@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UILabel *cetegoryLabel;
@property (nonatomic, weak) UILabel *durationLabel;

- (void)setIsVerVideo:(BOOL)isVerVideo isRelate:(BOOL)isRelate;
@property (nonatomic, assign, readonly) BOOL isVerVideo;
@property (nonatomic, assign, readonly) BOOL isRelate;
@property (nonatomic, weak) UIView *relateView;
@property (nonatomic, weak) UIImageView *relateCoverView;
@property (nonatomic, weak) UILabel *relateTitleLabel;
@property (nonatomic, weak) UILabel *relateInfoLabel;
@property (nonatomic, weak) JPBounceView *relatePlayBtn;
@property (nonatomic, copy) void (^relatePlayBlock)(void);
@property (nonatomic, weak) WTVPUGCOptionButton *relatCollectBtn;
@property (nonatomic, copy) void (^relateCollectBlock)(void);
@end
