//
//  YYWebImageHelper.h
//  WoTV
//
//  Created by 周健平 on 2020/4/13.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPWebImageHeader.h"
#import <YYWebImage/YYWebImage.h>

@interface YYWebImageHelper : NSObject

+ (YYWebImageOptions)jp2yyOptions:(JPWebImageOptions)options;

+ (YYWebImageProgressBlock)jp2yyProgress:(JPSetImageProgress)progress;
+ (YYWebImageTransformBlock)jp2yyTransform:(JPSetImageTransform)transform;
+ (YYWebImageCompletionBlock)jp2yyCompletion:(JPSetImageCompleted)completed;

+ (JPWebImageFromType)yy2jpFromType:(YYWebImageFromType)from;
+ (JPWebImageStage)yy2jpStage:(YYWebImageStage)stage;

@end

