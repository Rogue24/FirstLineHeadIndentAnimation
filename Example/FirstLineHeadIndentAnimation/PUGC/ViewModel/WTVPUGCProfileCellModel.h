//
//  WTVPUGCProfileCellModel.h
//  WoTV
//
//  Created by 周健平 on 2020/4/14.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTVPUGCProfileModel.h"
#import "WTVPUGCProfileCell.h"

UIKIT_EXTERN NSString * const WTVPUGCFollowNotifiCation;
UIKIT_EXTERN NSString * const WTVPUGCGiveUpNotifiCation;
UIKIT_EXTERN NSString * const WTVVideoCollectNotifiCation;

@interface WTVPUGCTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font;
@end

@interface WTVPUGCProfileCellModel : NSObject

+ (instancetype)cellModelForCellStyle_1withModel:(WTVPUGCProfileModel *)model index:(NSInteger)index contrastUid:(NSString *)contrastUid isNoProfileStyle:(BOOL)isNoProfileStyle;
+ (instancetype)cellModelForCellStyle_2withModel:(WTVPUGCProfileModel *)model index:(NSInteger)index contrastUid:(NSString *)contrastUid;
@property (nonatomic, strong) WTVPUGCProfileModel *model;

#pragma mark - 存储属性
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) BOOL isMe;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) WTVPUGCProfileCellStyle cellStyle;
@property (nonatomic, assign) BOOL isVerVideo;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, strong) NSURL *iconURL;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *logoName; // 💃
// 播放框的
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSURL *coverURL;
@property (nonatomic, strong) YYTextLayout *videoTitleLayout;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *cetegory;
@property (nonatomic, assign) CGRect durationFrame;
@property (nonatomic, assign) CGRect cetegoryFrame;
@property (nonatomic, assign) CGRect bottomViewFrame;
// 长短互推
@property (nonatomic, assign) BOOL isRelate;
@property (nonatomic, strong) NSURL *relateCoverURL;
@property (nonatomic, copy) NSString *relateVideoTitle;
@property (nonatomic, copy) NSString *relateVideoInfo;
// CellStyle_1
@property (nonatomic, copy) NSString *bottomStr;
@property (nonatomic, assign) BOOL isNoProfileStyle; // YES -> 头像下面显示个人简介；NO -> 头像下面显示发布时间
// CellStyle_2
@property (nonatomic, assign) BOOL isNoPugcStyle; // YES -> 推荐的长视频，没有头像；NO -> pugc的视频，有头像

#pragma mark - 交互属性：直播、关注、点赞、收藏、转发、评论
@property (nonatomic, assign) BOOL isLiving; // 💃
@property (nonatomic, assign) BOOL isFollowed; // 💃

@property (nonatomic, assign) BOOL isZaned; // 💃
@property (nonatomic, assign) BOOL isCollected; // 💃
@property (nonatomic, assign) BOOL isRelateCollected; // 💃

- (void)setIsLiving:(BOOL)isLiving animated:(BOOL)isAnimated;
- (void)setIsFollowed:(BOOL)isFollowed byUserInteraction:(BOOL)byUserInteraction;
- (void)setIsZaned:(BOOL)isZaned byUserInteraction:(BOOL)byUserInteraction;
- (void)setIsCollected:(BOOL)isCollected byUserInteraction:(BOOL)byUserInteraction;
- (void)setIsRelateCollected:(BOOL)isRelateCollected byUserInteraction:(BOOL)byUserInteraction;

@property (nonatomic, copy) NSString *zanCountStr;
@property (nonatomic, copy) NSString *collectCountStr;
@property (nonatomic, copy) NSString *shareCountStr;
@property (nonatomic, copy) NSString *commentCountStr;

#pragma mark - 配置cell
@property (nonatomic, weak) WTVPUGCProfileCell *cell;
- (void)setupCell:(WTVPUGCProfileCell *)cell;

@end

