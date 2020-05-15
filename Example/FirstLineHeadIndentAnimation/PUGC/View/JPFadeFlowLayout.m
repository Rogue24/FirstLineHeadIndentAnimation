//
//  JPFadeFlowLayout.m
//  WoTV
//
//  Created by 周健平 on 2019/9/14.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import "JPFadeFlowLayout.h"

@interface JPFadeFlowLayout ()
@property (nonatomic, strong) NSMutableDictionary *insertSectionDics;
@property (nonatomic, strong) NSMutableDictionary *deleteSectionDics;
@property (nonatomic, strong) NSMutableDictionary *reloadSectionDics;
@property (nonatomic, assign) BOOL isUpdateSections;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *allNumberOfItemsInSection;
@end

@implementation JPFadeFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scale = CGPointMake(1, 1);
    }
    return self;
}

- (NSMutableDictionary *)insertSectionDics {
    if (!_insertSectionDics) _insertSectionDics = [NSMutableDictionary dictionary];
    return _insertSectionDics;
}

- (NSMutableDictionary *)deleteSectionDics {
    if (!_deleteSectionDics) _deleteSectionDics = [NSMutableDictionary dictionary];
    return _deleteSectionDics;
}

- (NSMutableDictionary *)reloadSectionDics {
    if (!_reloadSectionDics) _reloadSectionDics = [NSMutableDictionary dictionary];
    return _reloadSectionDics;
}

- (NSMutableArray<NSNumber *> *)allNumberOfItemsInSection {
    if (!_allNumberOfItemsInSection) _allNumberOfItemsInSection = [NSMutableArray array];
    return _allNumberOfItemsInSection;
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
            {
                NSInteger section = updateItem.indexPathAfterUpdate.section;
                if (updateItem.indexPathAfterUpdate.item >= NSIntegerMax && _insertSectionDics[@(section)] == nil) {
                    self.insertSectionDics[@(section)] = @([self.collectionView numberOfItemsInSection:section]);
                }
                break;
            }
            case UICollectionUpdateActionDelete:
            {
                NSInteger section = updateItem.indexPathBeforeUpdate.section;
                if (updateItem.indexPathBeforeUpdate.item >= NSIntegerMax && _deleteSectionDics[@(section)] == nil) {
                    if (self.allNumberOfItemsInSection.count && section < self.allNumberOfItemsInSection.count) {
                        self.deleteSectionDics[@(section)] = self.allNumberOfItemsInSection[section];
                    }
                }
                break;
            }
            case UICollectionUpdateActionReload:
            {
                // indexPathBeforeUpdate indexPathAfterUpdate 都一样
                NSInteger section = updateItem.indexPathBeforeUpdate.section;
                if (updateItem.indexPathBeforeUpdate.item >= NSIntegerMax && _reloadSectionDics[@(section)] == nil) {
                    NSNumber *originNumberOfItems = section < self.allNumberOfItemsInSection.count ? self.allNumberOfItemsInSection[section] : @0;
                    NSNumber *currentNumberOfItems = @([self.collectionView numberOfItemsInSection:section]);
                    self.reloadSectionDics[@(section)] = @[originNumberOfItems, currentNumberOfItems];
                }
                break;
            }
            default:
                break;
        }
    }
    
    self.isUpdateSections = _insertSectionDics.count || _deleteSectionDics.count || _reloadSectionDics.count;
}

- (void)finalizeCollectionViewUpdates {
    self.isUpdateSections = NO;
    
    [_insertSectionDics removeAllObjects];
    [_deleteSectionDics removeAllObjects];
    [_reloadSectionDics removeAllObjects];
    
    [self.allNumberOfItemsInSection removeAllObjects];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger i = 0; i < numberOfSections; i++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:i];
        [self.allNumberOfItemsInSection addObject:@(numberOfItems)];
    }
}

// 从 刚创建出来时的样式设置 -- 到 --> 正常状态
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [[super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath] copy];
    return [self attributes:attributes initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
}
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attributes = [[super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath] copy];
    return [self attributes:attributes initialLayoutAttributesForAppearingItemAtIndexPath:elementIndexPath];
}
- (UICollectionViewLayoutAttributes *)attributes:(UICollectionViewLayoutAttributes *)attributes initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isUpdateSections) {
        attributes.alpha = 0;
        return attributes;
    }
    
    if (_insertSectionDics[@(indexPath.section)] != nil) {
        attributes.alpha = 0;
        attributes.transform = CGAffineTransformMakeScale(self.scale.x, self.scale.y);
    }
    
    if (_reloadSectionDics[@(indexPath.section)] != nil) {
        NSInteger origNumberOfItems = [[self.reloadSectionDics[@(indexPath.section)] firstObject] integerValue];
        if (indexPath.item >= origNumberOfItems) {
            attributes.transform = CGAffineTransformMakeScale(self.scale.x, self.scale.y);
            attributes.alpha = 0;
        } else {
            attributes.alpha = 1;
        }
    }
    
    return attributes;
}

// 从 正常状态 -- 到 --> 最后消失时的样式设置
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [[super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath] copy];
    return [self attributes:attributes finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
}
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attributes = [[super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath] copy];
    return [self attributes:attributes finalLayoutAttributesForDisappearingItemAtIndexPath:elementIndexPath];
}
- (UICollectionViewLayoutAttributes *)attributes:(UICollectionViewLayoutAttributes *)attributes finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isUpdateSections) {
        attributes.alpha = 0;
        return attributes;
    }
    
    if (_deleteSectionDics[@(indexPath.section)] != nil) {
        attributes.alpha = 0;
    }
    
    // 刷新：旧的是覆盖在新的上面，现在对旧的进行渐变消失
    if (_reloadSectionDics[@(indexPath.section)] != nil) {
        attributes.alpha = 0;
        NSInteger currentNumberOfItems = [[self.reloadSectionDics[@(indexPath.section)] lastObject] integerValue];
        if (indexPath.item >= currentNumberOfItems) {
            attributes.transform = CGAffineTransformMakeScale(self.scale.x, self.scale.y);
        }
    }
    
    return attributes;
}

@end

