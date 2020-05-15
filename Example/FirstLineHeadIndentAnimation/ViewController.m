//
//  ViewController.m
//  FirstLineHeadIndentAnimation
//
//  Created by zhoujianping24@hotmail.com on 05/15/2020.
//  Copyright (c) 2020 zhoujianping24@hotmail.com. All rights reserved.
//

#import "ViewController.h"
#import "JPBounceView.h"
#import "PUGCViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Hello";
    self.view.backgroundColor = JPRandomColor;
    
    CGFloat w = JPScaleValue(200);
    CGFloat h = JPScaleValue(150);
    CGFloat x = JPHalfOfDiff(JPPortraitScreenWidth, w);
    CGFloat y = JPNavTopMargin + JPHalfOfDiff((JPPortraitScreenHeight - JPNavTopMargin), h);
    JPBounceView *btn = [[JPBounceView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    btn.scale = 0.88;
    btn.scaleDuration = 0.2;
    btn.recoverSpeed = 20;
    btn.recoverBounciness = 15;
    btn.layer.cornerRadius = JP10Margin;
    @jp_weakify(self);
    btn.viewTouchUpInside = ^(JPBounceView *bounceView) {
        @jp_strongify(self);
        if (!self) return;
        PUGCViewController *vc = [[PUGCViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:btn];
    
    btn.backgroundColor = JPRandomColor;
    UILabel *textLabel = ({
        UILabel *aLabel = [[UILabel alloc] initWithFrame:btn.bounds];
        aLabel.font = JPScaleBoldFont(20);
        aLabel.textAlignment = NSTextAlignmentCenter;
        aLabel.textColor = JPRandomColor;
        aLabel.text = @"Tap me";
        aLabel;
    });
    [btn addSubview:textLabel];
}

@end
