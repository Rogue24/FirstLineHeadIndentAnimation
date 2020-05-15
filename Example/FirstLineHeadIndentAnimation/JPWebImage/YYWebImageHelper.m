//
//  YYWebImageHelper.m
//  WoTV
//
//  Created by 周健平 on 2020/4/13.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "YYWebImageHelper.h"

@implementation YYWebImageHelper

+ (YYWebImageOptions)jp2yyOptions:(JPWebImageOptions)options {
    YYWebImageOptions yyOptions = kNilOptions;
    
    if (options == kNilOptions) {
        return yyOptions;
    }
    
    if (options & JPWebImageOptionShowNetworkActivity) {
        yyOptions |= YYWebImageOptionShowNetworkActivity;
    }
    
    if (options & JPWebImageOptionProgressive) {
        yyOptions |= YYWebImageOptionProgressive;
    }
    
    if (options & JPWebImageOptionProgressiveBlur) {
        yyOptions |= YYWebImageOptionProgressiveBlur;
    }
    
    if (options & JPWebImageOptionUseNSURLCache) {
        yyOptions |= YYWebImageOptionUseNSURLCache;
    }
    
    if (options & JPWebImageOptionAllowInvalidSSLCertificates) {
        yyOptions |= YYWebImageOptionAllowInvalidSSLCertificates;
    }
    
    if (options & JPWebImageOptionAllowBackgroundTask) {
        yyOptions |= YYWebImageOptionAllowBackgroundTask;
    }
    
    if (options & JPWebImageOptionHandleCookies) {
        yyOptions |= YYWebImageOptionHandleCookies;
    }
    
    if (options & JPWebImageOptionRefreshImageCache) {
        yyOptions |= YYWebImageOptionRefreshImageCache;
    }
    
    if (options & JPWebImageOptionIgnoreDiskCache) {
        yyOptions |= YYWebImageOptionIgnoreDiskCache;
    }
    
    if (options & JPWebImageOptionIgnorePlaceHolder) {
        yyOptions |= YYWebImageOptionIgnorePlaceHolder;
    }
    
    if (options & JPWebImageOptionIgnoreImageDecoding) {
        yyOptions |= YYWebImageOptionIgnoreImageDecoding;
    }
    
    if (options & JPWebImageOptionIgnoreAnimatedImage) {
        yyOptions |= YYWebImageOptionIgnoreAnimatedImage;
    }
    
    if (options & JPWebImageOptionSetImageWithFadeAnimation) {
        yyOptions |= YYWebImageOptionSetImageWithFadeAnimation;
    }
    
    if (options & JPWebImageOptionAvoidSetImage) {
        yyOptions |= YYWebImageOptionAvoidSetImage;
    }
    
    if (options & JPWebImageOptionIgnoreFailedURL) {
        yyOptions |= YYWebImageOptionIgnoreFailedURL;
    }
    
    return yyOptions;
}

+ (YYWebImageProgressBlock)jp2yyProgress:(JPSetImageProgress)progress {
    YYWebImageProgressBlock yy_progress = nil;
    if (progress) {
        yy_progress = ^(NSInteger receivedSize, NSInteger expectedSize) {
            float percent = receivedSize * 1.0 / expectedSize;
            progress(percent);
        };
    }
    return yy_progress;
}

+ (YYWebImageTransformBlock)jp2yyTransform:(JPSetImageTransform)transform {
    YYWebImageTransformBlock yy_transform = nil;
    if (transform) {
        yy_transform = transform;
    }
    return yy_transform;
}

+ (YYWebImageCompletionBlock)jp2yyCompletion:(JPSetImageCompleted)completed {
    YYWebImageCompletionBlock yy_completion = nil;
    if (completed) {
        yy_completion = ^(UIImage *image,
                          NSURL *url,
                          YYWebImageFromType from,
                          YYWebImageStage stage,
                          NSError *error) {
            completed(image, error, url, [self yy2jpFromType:from], [self yy2jpStage:stage]);
        };
    }
    return yy_completion;
}

+ (JPWebImageFromType)yy2jpFromType:(YYWebImageFromType)from {
    switch (from) {
        case YYWebImageFromMemoryCacheFast:
            return JPWebImageFromMemoryCacheFast;
        case YYWebImageFromMemoryCache:
            return JPWebImageFromMemoryCache;
        case YYWebImageFromDiskCache:
            return JPWebImageFromDiskCache;
        case YYWebImageFromRemote:
            return JPWebImageFromRemote;
        default:
            return JPWebImageFromNone;
    }
}

+ (JPWebImageStage)yy2jpStage:(YYWebImageStage)stage {
    switch (stage) {
        case YYWebImageStageProgress:
            return JPWebImageStageProgress;
        case YYWebImageStageCancelled:
            return JPWebImageStageCancelled;
        default:
            return JPWebImageStageFinished;
    }
}

@end
