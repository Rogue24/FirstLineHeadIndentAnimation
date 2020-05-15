//
//  JPScreenEdgeLeftScrollView.m
//  WoLive
//
//  Created by 周健平 on 2019/8/30.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import "JPScreenEdgeLeftScrollView.h"

@implementation JPScreenEdgeLeftScrollView

#pragma mark - 让左边边缘区域无法响应，让事件传递到父控制器（缺陷：左边宽15的区域无法滚动）

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isNotFull) {
        return [super hitTest:point withEvent:event];
    }
    CGRect frame = CGRectMake(0, 0, 15, self.frame.size.height);
    if (!CGRectContainsPoint(frame, point)) {
        return [super hitTest:point withEvent:event];
    } else {
        return nil;
    }
}
@end
