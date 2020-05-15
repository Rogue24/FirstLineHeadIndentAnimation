//
//  JPUnderlineButton.h
//  WoLive
//
//  Created by 周健平 on 2018/11/15.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPUnderlineButton : UIButton
@property (nonatomic, assign) BOOL isShowUnderline;
@property (nonatomic, assign) CGFloat underlinePadding;
@property (nonatomic, assign) CGFloat underlineSpace;
@end

NS_ASSUME_NONNULL_END
