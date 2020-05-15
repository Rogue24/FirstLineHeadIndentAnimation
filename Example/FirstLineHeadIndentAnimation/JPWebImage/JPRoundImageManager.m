//
//  JPRoundImageManager.m
//  WoTV
//
//  Created by 周健平 on 2020/4/13.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "JPRoundImageManager.h"
#import "UIImage+JPExtension.h"
#import "JPFileTool.h"

@implementation JPRoundImageManager

+ (YYWebImageManager *)sharedManager {
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = JPCacheFilePath(@"jp_roundimages");
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            if (!image) return image;
            return [image jp_imageByRoundWithBorderWidth:0 borderColor:nil];
        };
    });
    return manager;
}

+ (void)cachedImageExistsForURL:(NSURL *)url completed:(void(^)(BOOL isInCache))completed {
    BOOL result = [self imageFromDiskCacheForURL:url] != nil;
    !completed ? : completed(result);
}

+ (UIImage *)imageFromDiskCacheForURL:(NSURL *)url {
    YYWebImageManager *manager = [self sharedManager];
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.cache getImageForKey:key];
}

+ (void)clearMemory {
    [[self sharedManager].cache.memoryCache removeAllObjects];
}

+ (void)clearDisk {
    [[self sharedManager].cache.diskCache removeAllObjects];
}

+ (void)clearAll {
    [[self sharedManager].cache.memoryCache removeAllObjects];
    [[self sharedManager].cache.diskCache removeAllObjects];
}

+ (void)downloadImageWithURL:(NSURL *)imageURL
                     options:(JPWebImageOptions)options
                    progress:(JPSetImageProgress)progress
                   transform:(JPSetImageTransform)transform
                   completed:(JPSetImageCompleted)completed {
    [[self sharedManager] requestImageWithURL:imageURL
                                      options:[YYWebImageHelper jp2yyOptions:options]
                                     progress:[YYWebImageHelper jp2yyProgress:progress]
                                    transform:[YYWebImageHelper jp2yyTransform:transform]
                                   completion:[YYWebImageHelper jp2yyCompletion:completed]];
}

@end
