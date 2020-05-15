//
//  WTVPUGCProfileCollectionView.m
//  WoTV
//
//  Created by 周健平 on 2020/4/23.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "WTVPUGCProfileCollectionView.h"

@interface WTVPUGCProfileCollectionView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray<WTVPUGCProfileCellModel *> *cellModels;
@end

@implementation WTVPUGCProfileCollectionView
{
    BOOL _isFirstDecelerate;
    BOOL _isDecelerate;
    BOOL _isAnimating;
    NSString *_sectionHeaderID;
}

- (NSMutableArray<WTVPUGCProfileCellModel *> *)cellModels {
    if (!_cellModels) {
        _cellModels = [NSMutableArray array];
    }
    return _cellModels;
}

- (NSUInteger)cellModelsCount {
    return _cellModels.count;
}

- (WTVPUGCProfileCellModel *)cellModelWithIndex:(NSUInteger)index {
    if (index >= self.cellModels.count) {
        return nil;
    }
    return self.cellModels[index];
}

+ (instancetype)profileCollectionViewWithCellStyle:(WTVPUGCProfileCellStyle)cellStyle
                                      cellDelegate:(id<WTVPUGCProfileCellDelegate>)cellDelegate
                                 sectionHeaderSize:(CGSize)sectionHeaderSize
                                sectionHeaderClass:(Class)sectionHeaderClass
                                   sectionHeaderID:(NSString *)sectionHeaderID {
    return [[WTVPUGCProfileCollectionView alloc] initWithFrame:JPPortraitScreenBounds
                                                     cellStyle:cellStyle
                                                  cellDelegate:cellDelegate
                                             sectionHeaderSize:sectionHeaderSize
                                            sectionHeaderClass:sectionHeaderClass
                                               sectionHeaderID:sectionHeaderID];
}

- (instancetype)initWithFrame:(CGRect)frame
                    cellStyle:(WTVPUGCProfileCellStyle)cellStyle
                 cellDelegate:(id<WTVPUGCProfileCellDelegate>)cellDelegate
            sectionHeaderSize:(CGSize)sectionHeaderSize
           sectionHeaderClass:(Class)sectionHeaderClass
              sectionHeaderID:(NSString *)sectionHeaderID {
    
    JPFadeFlowLayout *flowLayout = [[JPFadeFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(JPNavTopMargin, 0, JPDiffTabBarH, 0);
    if (sectionHeaderSize.height) flowLayout.headerReferenceSize = sectionHeaderSize;
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        _isFirstDecelerate = YES;
        _cellStyle = cellStyle;
        _cellDelegate = cellDelegate;
        _flowLayout = flowLayout;
        
        [self jp_contentInsetAdjustmentNever];
        self.backgroundColor = UIColor.whiteColor;
        self.delaysContentTouches = NO;
        [self registerClass:WTVPUGCProfileCell.class forCellWithReuseIdentifier:WTVPUGCProfileCellID];
        if (sectionHeaderID) {
            [self registerClass:(sectionHeaderClass ? sectionHeaderClass : UICollectionReusableView.class) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
            _sectionHeaderID = sectionHeaderID;
        }
        self.dataSource = self;
        self.delegate = self;
        
        _esView = [WLEmptyStateView emptyStateViewWithState:WLEmptyState_Loading title:@"正在加载..." imageName:@"panda_error" noDataDidClickBlock:nil onSuperView:self makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-JPScaleValue(30));
        }];
        _esView.otherBtnConstraintsConfirmBlock = ^(MASConstraintMaker *make) {
            make.size.equalTo(@(CGSizeMake(JPScaleValue(75), JPScaleValue(28))));
        };
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - 数据刷新

- (void)reloadCellModels:(NSMutableArray<WTVPUGCProfileCellModel *> *)cellModels complete:(void (^)(void))complete {
    _isAnimating = NO;
    if (self.cellModels.count) {
        [self performBatchUpdates:^{
            self.cellModels = cellModels;
            [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:^(BOOL finished) {
            !complete ? : complete();
            !self.scrollDidEndBlock ? : self.scrollDidEndBlock(self);
        }];
    } else if (cellModels.count) {
        [self.esView hadDataWithIsRemove:NO animated:YES];
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSInteger i = 0; i < cellModels.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
        [self performBatchUpdates:^{
            self.cellModels = cellModels;
            [self insertItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL finished) {
            !complete ? : complete();
            !self.scrollDidEndBlock ? : self.scrollDidEndBlock(self);
        }];
    } else {
        !complete ? : complete();
    }
}

- (void)addCellModels:(NSMutableArray<WTVPUGCProfileCellModel *> *)cellModels complete:(void (^)(void))complete {
    _isAnimating = NO;
    if (cellModels.count) {
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSInteger beginIndex = self.cellModels.count;
        for (NSInteger i = 0; i < cellModels.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:(beginIndex + i) inSection:0]];
        }
        [self performBatchUpdates:^{
            [self.cellModels addObjectsFromArray:cellModels];
            [self insertItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL finished) {
            !complete ? : complete();
            !self.scrollDidEndBlock ? : self.scrollDidEndBlock(self);
        }];
    } else {
        !complete ? : complete();
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    WTVPUGCProfileCellModel *cm = self.cellModels[indexPath.item];
    return cm.cellSize;
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WTVPUGCProfileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WTVPUGCProfileCellID forIndexPath:indexPath];
    cell.delegate = self.cellDelegate;
    
    WTVPUGCProfileCellModel *cm = self.cellModels[indexPath.item];
    [cm setupCell:cell];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:_sectionHeaderID forIndexPath:indexPath];
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(WTVPUGCProfileCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    !self.didEndDisplayingCellBlock ? : self.didEndDisplayingCellBlock(self, indexPath);
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isAnimating = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollingBlock ? : self.scrollingBlock(self);
    
//    CGFloat offsetY = scrollView.contentOffset.y;
//    JPLog(@"viewHeight %.2lf", scrollView.jp_height);
//    JPLog(@"contentSize %.2lf", scrollView.contentSize.height);
//    JPLog(@"contentInset %.2lf", scrollView.contentInset.top);
//    JPLog(@"contentOffset %.2lf", offsetY);
//    JPLog(@"---------");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isFirstDecelerate) {
        _isFirstDecelerate = NO;
        _isDecelerate = decelerate;
    }
    if (!_isDecelerate) [self scrollViewDidEndDecelerating:scrollView];
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    [self scrollViewDidEndDecelerating:scrollView];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isFirstDecelerate = YES;
    if (!_isAnimating && self.scrollDidEndBlock) self.scrollDidEndBlock(self);
}

#pragma mark - 滚动到指定位置

- (void)scrollToCellModel:(WTVPUGCProfileCellModel *)cellModel complete:(void (^)(void))complete {
    if (![self.cellModels containsObject:cellModel]) return;
    _isAnimating = YES;
    [UIView animateWithDuration:0.35 animations:^{
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:cellModel.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    } completion:^(BOOL finished) {
        if (finished) {
            if (self->_isAnimating && complete) complete();
            self->_isAnimating = NO;
        }
    }];
}

@end
