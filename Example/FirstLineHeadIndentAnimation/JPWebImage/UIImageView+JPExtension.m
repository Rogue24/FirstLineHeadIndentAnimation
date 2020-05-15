//
//  UIImageView+JPExtension.m
//  Infinitee2.0
//
//  Created by zhoujianping on 16/11/24.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "UIImageView+JPExtension.h"
#import "JPRoundImageManager.h"

@implementation UIImageView (JPExtension)

#pragma mark - YYWebImage封装

/** 所有参数自定义 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
                     options:(JPWebImageOptions)options
                   isRounded:(BOOL)isRounded
            placeholderImage:(UIImage *)placeholder
                    progress:(JPSetImageProgress)progress
                   transform:(JPSetImageTransform)transform
                   completed:(JPSetImageCompleted)completed {
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:[YYWebImageHelper jp2yyOptions:options]
                     manager:(isRounded ? [JPRoundImageManager sharedManager] : nil)
                    progress:[YYWebImageHelper jp2yyProgress:progress]
                   transform:[YYWebImageHelper jp2yyTransform:transform]
                  completion:[YYWebImageHelper jp2yyCompletion:completed]];
}

/** 自定义带动画、是否缓存、带进度、图片设置、完成block */
- (void)jp_setPictureWithFakeAnimate:(BOOL)isAnimate
                   isCacheMemoryOnly:(BOOL)isCacheMemoryOnly
                            imageURL:(NSURL *)imageURL
                    placeholderImage:(UIImage *)placeholder
                            progress:(JPSetImageProgress)progress
                           transform:(JPSetImageTransform)transform
                           completed:(JPSetImageCompleted)completed {
    
    YYWebImageOptions options = kNilOptions;
    if (isAnimate) {
        options |= YYWebImageOptionSetImageWithFadeAnimation;
    }
    if (isCacheMemoryOnly) {
        options |= YYWebImageOptionIgnoreDiskCache;
    }
    
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                    progress:[YYWebImageHelper jp2yyProgress:progress]
                   transform:[YYWebImageHelper jp2yyTransform:transform]
                  completion:[YYWebImageHelper jp2yyCompletion:completed]];
}

/** 淡入淡出带进度、图片切圆带边框、完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                        progress:(JPSetImageProgress)progress
                      targetSize:(CGSize)targetSize
                    circleRadius:(CGFloat)radius
                     borderWidth:(CGFloat)borderWidth
                     borderColor:(UIColor *)borderColor
                       completed:(JPSetImageCompleted)completed {
    [self jp_setPictureWithFakeAnimate:YES
                     isCacheMemoryOnly:NO
                              imageURL:imageURL
                      placeholderImage:placeholder
                              progress:progress
                             transform:^UIImage *(UIImage *image, NSURL *imageURL) {
        image = [image yy_imageByResizeToSize:targetSize contentMode:UIViewContentModeScaleAspectFill];
        return [image yy_imageByRoundCornerRadius:radius borderWidth:borderWidth borderColor:borderColor];
    }
                             completed:completed];
}

/** 淡入淡出、图片切圆、完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                      targetSize:(CGSize)targetSize
                    circleRadius:(CGFloat)radius
                       completed:(JPSetImageCompleted)completed {
    [self jp_fakeSetPictureWithURL:imageURL
                  placeholderImage:placeholder
                          progress:nil
                        targetSize:targetSize
                      circleRadius:radius
                       borderWidth:0
                       borderColor:nil
                         completed:completed];
}

/** 淡入淡出带进度、图片设置、完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                        progress:(JPSetImageProgress)progress
                       transform:(JPSetImageTransform)transform
                       completed:(JPSetImageCompleted)completed {
    [self jp_setPictureWithFakeAnimate:YES
                     isCacheMemoryOnly:NO
                              imageURL:imageURL
                      placeholderImage:placeholder
                              progress:progress
                             transform:transform
                             completed:completed];
}

/** 淡入淡出带完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                       completed:(JPSetImageCompleted)completed {
    [self jp_setPictureWithFakeAnimate:YES
                     isCacheMemoryOnly:NO
                              imageURL:imageURL
                      placeholderImage:placeholder
                              progress:nil
                             transform:nil
                             completed:completed];
}

/** 淡入淡出 */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder {
    [self jp_setPictureWithFakeAnimate:YES
                     isCacheMemoryOnly:NO
                              imageURL:imageURL
                      placeholderImage:placeholder
                              progress:nil
                             transform:nil
                             completed:nil];
}

/** 淡入淡出只缓存到内存 */
- (void)jp_fakeSetPictureCacheMemoryOnlyWithURL:(NSURL *)imageURL
                               placeholderImage:(UIImage *)placeholder {
    [self jp_setPictureWithFakeAnimate:YES
                     isCacheMemoryOnly:YES
                              imageURL:imageURL
                      placeholderImage:placeholder
                              progress:nil
                             transform:nil
                             completed:nil];
}

/** 设置头像 */
- (void)jp_setUserIconWithURL:(NSURL *)imageURL
             placeholderImage:(UIImage *)placeholder {
    [self jp_fakeSetPictureWithURL:imageURL
                  placeholderImage:placeholder];
}

/** 不带动画设置图片 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
            placeholderImage:(UIImage *)placeholder {
    [self jp_setPictureWithURL:imageURL
              placeholderImage:placeholder
                     completed:nil];
}

/** 不带动画带完成block设置图片 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
            placeholderImage:(UIImage *)placeholder
                   completed:(JPSetImageCompleted)completed {
    [self jp_setPictureWithFakeAnimate:NO
                     isCacheMemoryOnly:NO
                              imageURL:imageURL
                      placeholderImage:placeholder
                              progress:nil
                             transform:nil
                             completed:completed];
}

/** 自己手动设置图片 */
- (void)jp_avoidSetImageWithURL:(NSURL *)picURL
                    placeholder:(UIImage *)placeholder
                       progress:(JPSetImageProgress)progress
                      transform:(JPSetImageTransform)transform
                     completion:(JPSetImageCompleted)completion {
    [self yy_setImageWithURL:picURL
                 placeholder:placeholder
                     options:YYWebImageOptionAvoidSetImage
                    progress:[YYWebImageHelper jp2yyProgress:progress]
                   transform:[YYWebImageHelper jp2yyTransform:transform]
                  completion:[YYWebImageHelper jp2yyCompletion:completion]];
}

/** 取消请求图片 */
- (void)jp_cancelCurrentImageRequest {
    [self yy_cancelCurrentImageRequest];
}

@end
