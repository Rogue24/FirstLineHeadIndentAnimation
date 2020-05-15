//
//  JPSubTableViewController.h
//  WoTVEducation
//
//  Created by 周健平 on 2018/1/4.
//  Copyright © 2018年 沃视频. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPSubTableViewController : UITableViewController
@property (nonatomic, copy) void (^willBeginDraggingHandle)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^didScrollHandle)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^didEndScrollHandle)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^panEndedHandle)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^requestStartHandle)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^requestDoneHandle)(UIScrollView *scrollView);
@end
