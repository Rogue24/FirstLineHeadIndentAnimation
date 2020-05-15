//
//  JPCustomLayoutButton.h
//  WoTV
//
//  Created by 周健平 on 2019/9/9.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPCustomLayoutButton : UIButton
@property (nonatomic, copy) void (^layoutSubviewsBlock)(UIButton *btn);
@end
