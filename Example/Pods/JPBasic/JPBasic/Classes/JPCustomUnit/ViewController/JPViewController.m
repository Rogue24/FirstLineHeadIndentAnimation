//
//  JPViewController.m
//  WoLive
//
//  Created by 周健平 on 2019/1/25.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import "JPViewController.h"

@implementation JPViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.currentInterfaceOrientation) {
        return self.currentInterfaceOrientation();
    }
    return UIInterfaceOrientationMaskAll;
}

@end
