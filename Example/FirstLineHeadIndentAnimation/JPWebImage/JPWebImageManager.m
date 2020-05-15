//
//  JPWebImageManager.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/3.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "JPWebImageManager.h"
#import "YYWebImageHelper.h"

@implementation JPWebImageManager

+ (void)cachedImageExistsForURL:(NSURL *)url completed:(void(^)(BOOL isInCache))completed {
    BOOL result = [self imageFromDiskCacheForURL:url] != nil;
    !completed ? : completed(result);
}

+ (UIImage *)imageFromDiskCacheForURL:(NSURL *)url {
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.cache getImageForKey:key];
}

+ (void)clearMemory {
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

+ (void)clearDisk {
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
}

+ (void)clearAll {
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
}

+ (void)downloadImageWithURL:(NSURL *)imageURL
                     options:(JPWebImageOptions)options
                    progress:(JPSetImageProgress)progress
                   transform:(JPSetImageTransform)transform
                   completed:(JPSetImageCompleted)completed {
    [[YYWebImageManager sharedManager] requestImageWithURL:imageURL
                                                   options:[YYWebImageHelper jp2yyOptions:options]
                                                  progress:[YYWebImageHelper jp2yyProgress:progress]
                                                 transform:[YYWebImageHelper jp2yyTransform:transform]
                                                completion:[YYWebImageHelper jp2yyCompletion:completed]];
}

@end
