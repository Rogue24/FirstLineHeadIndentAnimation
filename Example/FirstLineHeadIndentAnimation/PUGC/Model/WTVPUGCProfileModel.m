//
//  WTVPUGCProfileModel.m
//  FirstLineHeadIndentAnimation-Example_Example
//
//  Created by 周健平 on 2020/5/14.
//  Copyright © 2020 zhoujianping24@hotmail.com. All rights reserved.
//

#import "WTVPUGCProfileModel.h"

@implementation WTVPUGCProfileModel

#pragma mark - MJExtension method

// 自定义【属性名】
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    /*
     @key：自定义的属性名
     @value：服务器返回的属性名
     */
    return @{@"relateModel": @"relateVideo"};
}

@end
