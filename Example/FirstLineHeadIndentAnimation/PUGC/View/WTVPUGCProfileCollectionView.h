//
//  WTVPUGCProfileCollectionView.h
//  WoTV
//
//  Created by 周健平 on 2020/4/23.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPFadeFlowLayout.h"
#import "WTVPUGCProfileCellModel.h"
#import "WLEmptyStateView.h"

@interface WTVPUGCProfileCollectionView : UICollectionView
+ (instancetype)profileCollectionViewWithCellStyle:(WTVPUGCProfileCellStyle)cellStyle
                                      cellDelegate:(id<WTVPUGCProfileCellDelegate>)cellDelegate
                                 sectionHeaderSize:(CGSize)sectionHeaderSize
                                sectionHeaderClass:(Class)sectionHeaderClass
                                   sectionHeaderID:(NSString *)sectionHeaderID;

@property (nonatomic, weak, readonly) JPFadeFlowLayout *flowLayout;
@property (nonatomic, weak, readonly) WLEmptyStateView *esView;

@property (nonatomic, copy) void (^scrollingBlock)(WTVPUGCProfileCollectionView *kCollectionView);
@property (nonatomic, copy) void (^scrollDidEndBlock)(WTVPUGCProfileCollectionView *kCollectionView);
@property (nonatomic, copy) void (^didEndDisplayingCellBlock)(WTVPUGCProfileCollectionView *kCollectionView, NSIndexPath *indexPath);

@property (nonatomic, assign, readonly) WTVPUGCProfileCellStyle cellStyle;
@property (nonatomic, weak) id<WTVPUGCProfileCellDelegate> cellDelegate;

- (NSUInteger)cellModelsCount;
- (WTVPUGCProfileCellModel *)cellModelWithIndex:(NSUInteger)index;
- (void)reloadCellModels:(NSMutableArray<WTVPUGCProfileCellModel *> *)cellModels complete:(void(^)(void))complete;
- (void)addCellModels:(NSMutableArray<WTVPUGCProfileCellModel *> *)cellModels complete:(void(^)(void))complete;
- (void)scrollToCellModel:(WTVPUGCProfileCellModel *)cellModel complete:(void(^)(void))complete;
@end
