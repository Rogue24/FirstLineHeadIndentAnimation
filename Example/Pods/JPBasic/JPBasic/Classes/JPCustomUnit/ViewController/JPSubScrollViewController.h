//
//  JPSubScrollViewController.h
//  WoLive
//
//  Created by 周健平 on 2019/8/9.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPSubScrollViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void (^willBeginDraggingHandle)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^didScrollHandle)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^didEndScrollHandle)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^panEndedHandle)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^requestStartHandle)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^requestDoneHandle)(UIScrollView *scrollView);
@end
