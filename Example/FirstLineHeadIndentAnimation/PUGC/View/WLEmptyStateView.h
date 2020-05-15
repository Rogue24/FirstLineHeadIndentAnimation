//
//  WLEmptyStateView.h
//  WoLive
//
//  Created by 周健平 on 2019/8/19.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WLEmptyState) {
    WLEmptyState_Loading,
    WLEmptyState_NoData,
    WLEmptyState_HadData
};

@interface WLEmptyStateView : UIView

+ (instancetype)emptyStateViewWithState:(WLEmptyState)state
                                  title:(NSString *)title
                              imageName:(NSString *)imageName
                    noDataDidClickBlock:(void (^)(WLEmptyStateView *esView))noDataDidClickBlock
                            onSuperView:(UIView *)onSuperView
                        makeConstraints:(void (^)(MASConstraintMaker *make))makeConstraints;

- (void)loadingWithTitle:(NSString *)title imageName:(NSString *)imageName animated:(BOOL)animated;
- (void)loadingWithTitle:(NSString *)title imageName:(NSString *)imageName animated:(BOOL)animated complete:(void(^)(void))complete;

- (void)noDataWithTitle:(NSString *)title imageName:(NSString *)imageName otherBtn:(UIView *)otherBtn animated:(BOOL)animated;
- (void)noDataWithTitle:(NSString *)title imageName:(NSString *)imageName otherBtn:(UIView *)otherBtn animated:(BOOL)animated complete:(void(^)(void))complete;

- (void)hadDataWithIsRemove:(BOOL)isRemove animated:(BOOL)animated;
- (void)hadDataWithIsRemove:(BOOL)isRemove animated:(BOOL)animated complete:(void(^)(void))complete;

@property (nonatomic, assign) WLEmptyState state;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) void (^noDataDidClickBlock)(WLEmptyStateView *esView);
@property (nonatomic, copy) void (^otherBtnConstraintsConfirmBlock)(MASConstraintMaker *make);


@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIActivityIndicatorView *jvhua;
@property (nonatomic, weak) UIView *otherBtn;
@property (nonatomic, weak) UITapGestureRecognizer *tapGR;
@end

