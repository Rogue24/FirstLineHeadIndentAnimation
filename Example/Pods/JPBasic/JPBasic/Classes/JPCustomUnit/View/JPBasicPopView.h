//
//  JPBasicPopView.h
//  WoLive
//
//  Created by 周健平 on 2018/9/30.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPBasicPopView : UIView
@property (nonatomic, weak) UIView *contentView;
- (UIWindow *)jp_window;
- (void)addToWindow;
- (void)removeFromWindow;

- (void)didClickBgView;

- (void)scalePopAnimation:(BOOL)forShow complete:(nullable void(^)(BOOL isShowed))complete;
- (void)rotationAnimation:(BOOL)forShow complete:(nullable void(^)(BOOL isShowed))complete;
@end

NS_ASSUME_NONNULL_END
