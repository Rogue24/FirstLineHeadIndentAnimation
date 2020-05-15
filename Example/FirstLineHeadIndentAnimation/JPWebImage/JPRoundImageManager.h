//
//  JPRoundImageManager.h
//  WoTV
//
//  Created by 周健平 on 2020/4/13.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYWebImage/YYWebImage.h>
#import "YYWebImageHelper.h"

@interface JPRoundImageManager : NSObject
+ (YYWebImageManager *)sharedManager;

/** 沙盒是否含有图片 */
+ (void)cachedImageExistsForURL:(NSURL *)url completed:(void(^)(BOOL isInCache))completed;

/** 从沙盒获取图片 */
+ (UIImage *)imageFromDiskCacheForURL:(NSURL *)url;

/** 清除内存 */
+ (void)clearMemory;
/** 清除磁盘 */
+ (void)clearDisk;
/** 清除全部 */
+ (void)clearAll;

/**
 * 下载图片 其中progress、transform、completed均在子线程中，除了transform其余需要刷新UI记得回到主线程
 */
+ (void)downloadImageWithURL:(NSURL *)imageURL
                     options:(JPWebImageOptions)options
                    progress:(JPSetImageProgress)progress
                   transform:(JPSetImageTransform)transform
                   completed:(JPSetImageCompleted)completed;
@end

