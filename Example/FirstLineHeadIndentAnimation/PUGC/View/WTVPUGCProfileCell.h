//
//  WTVPUGCProfileCell.h
//  WoTV
//
//  Created by 周健平 on 2020/4/13.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTVPUGCProfileIconView.h"
#import "WTVPUGCProfilePlayView.h"
#import "WTVPUGCOptionButton.h"
@class WTVPUGCProfileCellModel;
@class WTVPUGCProfileCell;

static NSString *const WTVPUGCProfileCellID = @"WTVPUGCProfileCell";

typedef NS_ENUM(NSUInteger, WTVPUGCProfileCellStyle) {
    WTVPUGCProfileCellStyle_1, // 头像在上面的 isNoProfileStyle YES -> 头像下面显示个人简介；NO -> 头像下面显示发布时间
    WTVPUGCProfileCellStyle_2, // 头像在下面的 isNoPugcStyle YES -> 推荐的长视频，没有头像；NO -> pugc的视频，有头像
};

@protocol WTVPUGCProfileCellDelegate <NSObject>
- (void)tapCellEmptyPlace:(WTVPUGCProfileCell *)cell;
- (void)tapCellIcon:(WTVPUGCProfileCell *)cell;
- (void)playAction:(WTVPUGCProfileCell *)cell;
- (void)zanAction:(WTVPUGCProfileCell *)cell;
- (void)collectAction:(WTVPUGCProfileCell *)cell;
- (void)forwardAction:(WTVPUGCProfileCell *)cell;
- (void)commentAction:(WTVPUGCProfileCell *)cell;
- (void)moreAction:(WTVPUGCProfileCell *)cell;
- (void)relatePlayAction:(WTVPUGCProfileCell *)cell;
- (void)relateCollectAction:(WTVPUGCProfileCell *)cell;
- (void)cellFollowAction:(WTVPUGCProfileCell *)cell;
- (void)cetegoryAction:(WTVPUGCProfileCell *)cell;
@end

@interface WTVPUGCProfileBottomView : UIView
@property (nonatomic, strong) WTVPUGCOptionButton *zanBtn;
@property (nonatomic, strong) WTVPUGCOptionButton *collectBtn;
@property (nonatomic, strong) WTVPUGCOptionButton *forwardBtn;
@property (nonatomic, strong) WTVPUGCOptionButton *commentBtn;
@property (nonatomic, strong) WTVPUGCOptionButton *moreBtn;
- (void)createZanBtn:(void (^)(JPBounceView *bounceView))viewTouchUpInside;
- (void)createCollectBtn:(void (^)(JPBounceView *bounceView))viewTouchUpInside;
- (void)createForwardBtn:(void (^)(JPBounceView *bounceView))viewTouchUpInside;
@end

@interface WTVPUGCProfileCell : UICollectionViewCell
+ (CGFloat)cellHeight:(WTVPUGCProfileCellStyle)cellStyle isVerVideo:(BOOL)isVerVideo isRelate:(BOOL)isRelate isNoPugcStyle:(BOOL)isNoPugcStyle;
+ (CGSize)moreBtnSize;

- (void)setCellStyle:(WTVPUGCProfileCellStyle)cellStyle isVerVideo:(BOOL)isVerVideo isRelate:(BOOL)isRelate isNoPugcStyle:(BOOL)isNoPugcStyle;
@property (nonatomic, assign, readonly) WTVPUGCProfileCellStyle cellStyle;

@property (nonatomic, strong) WTVPUGCProfileIconView *iconView;
@property (nonatomic, strong) WTVPUGCProfilePlayView *playView;
@property (nonatomic, strong) WTVPUGCProfileBottomView *bottomView;

@property (nonatomic, weak) WTVPUGCProfileCellModel *cm;
@property (nonatomic, weak) id<WTVPUGCProfileCellDelegate> delegate;
@end
