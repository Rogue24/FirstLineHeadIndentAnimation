//
//  UIButton+JPExtension.m
//  WoTV
//
//  Created by 周健平 on 2018/8/27.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import "UIButton+JPExtension.h"
#import "JPRoundImageManager.h"

@implementation UIButton (JPExtension)

#pragma mark - YYWebImage封装

/** 所有参数自定义 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
                     options:(JPWebImageOptions)options
                   isRounded:(BOOL)isRounded
            placeholderImage:(UIImage *)placeholder
                       state:(UIControlState)state
                   isBgImage:(BOOL)isBgImage
                    progress:(JPSetImageProgress)progress
                   transform:(JPSetImageTransform)transform
                   completed:(JPSetImageCompleted)completed {
    if (isBgImage) {
        [self yy_setBackgroundImageWithURL:imageURL
                                  forState:state
                               placeholder:placeholder
                                   options:[YYWebImageHelper jp2yyOptions:options]
                                   manager:(isRounded ? [JPRoundImageManager sharedManager] : nil)
                                  progress:[YYWebImageHelper jp2yyProgress:progress]
                                 transform:[YYWebImageHelper jp2yyTransform:transform]
                                completion:[YYWebImageHelper jp2yyCompletion:completed]];
    } else {
        [self yy_setImageWithURL:imageURL
                        forState:state
                     placeholder:placeholder
                         options:[YYWebImageHelper jp2yyOptions:options]
                         manager:(isRounded ? [JPRoundImageManager sharedManager] : nil)
                        progress:[YYWebImageHelper jp2yyProgress:progress]
                       transform:[YYWebImageHelper jp2yyTransform:transform]
                      completion:[YYWebImageHelper jp2yyCompletion:completed]];
    }
}

/** 自定义带动画、是否缓存、带进度、图片设置、完成block */
- (void)jp_setPictureWithFakeAnimate:(BOOL)isAnimate
                   isCacheMemoryOnly:(BOOL)isCacheMemoryOnly
                            imageURL:(NSURL *)imageURL
                    placeholderImage:(UIImage *)placeholder
                               state:(UIControlState)state
                           isBgImage:(BOOL)isBgImage
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
    
    if (isBgImage) {
        [self yy_setBackgroundImageWithURL:imageURL
                                  forState:state
                               placeholder:placeholder
                                   options:options
                                  progress:[YYWebImageHelper jp2yyProgress:progress]
                                 transform:[YYWebImageHelper jp2yyTransform:transform]
                                completion:[YYWebImageHelper jp2yyCompletion:completed]];
    } else {
        [self yy_setImageWithURL:imageURL
                        forState:state
                     placeholder:placeholder
                         options:options
                        progress:[YYWebImageHelper jp2yyProgress:progress]
                       transform:[YYWebImageHelper jp2yyTransform:transform]
                      completion:[YYWebImageHelper jp2yyCompletion:completed]];
    }
}

/** 淡入淡出带进度、图片切圆带边框、完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                           state:(UIControlState)state
                       isBgImage:(BOOL)isBgImage
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
                                 state:state
                             isBgImage:isBgImage
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
                           state:(UIControlState)state
                       isBgImage:(BOOL)isBgImage
                      targetSize:(CGSize)targetSize
                    circleRadius:(CGFloat)radius
                       completed:(JPSetImageCompleted)completed {
    [self jp_fakeSetPictureWithURL:imageURL
                  placeholderImage:placeholder
                             state:state
                         isBgImage:isBgImage
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
                           state:(UIControlState)state
                       isBgImage:(BOOL)isBgImage
                        progress:(void(^)(float percent))progress
                       transform:(JPSetImageTransform)transform
                       completed:(JPSetImageCompleted)completed {
    [self jp_setPictureWithFakeAnimate:YES
                     isCacheMemoryOnly:NO
                              imageURL:imageURL
                      placeholderImage:placeholder
                                 state:state
                             isBgImage:isBgImage
                              progress:progress
                             transform:transform
                             completed:completed];
}

/** 淡入淡出带完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                           state:(UIControlState)state
                       isBgImage:(BOOL)isBgImage
                       completed:(JPSetImageCompleted)completed {
    [self jp_setPictureWithFakeAnimate:YES
                     isCacheMemoryOnly:NO
                              imageURL:imageURL
                      placeholderImage:placeholder
                                 state:state
                             isBgImage:isBgImage
                              progress:nil
                             transform:nil
                             completed:completed];
}

/** 淡入淡出 */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                           state:(UIControlState)state
                       isBgImage:(BOOL)isBgImage {
    [self jp_setPictureWithFakeAnimate:YES
                     isCacheMemoryOnly:NO
                              imageURL:imageURL
                      placeholderImage:placeholder
                                 state:state
                             isBgImage:isBgImage
                              progress:nil
                             transform:nil
                             completed:nil];
}

/** 淡入淡出只缓存到内存 */
- (void)jp_fakeSetPictureCacheMemoryOnlyWithURL:(NSURL *)imageURL
                               placeholderImage:(UIImage *)placeholder
                                          state:(UIControlState)state
                                      isBgImage:(BOOL)isBgImage {
    [self jp_setPictureWithFakeAnimate:YES
                     isCacheMemoryOnly:YES
                              imageURL:imageURL
                      placeholderImage:placeholder
                                 state:state
                             isBgImage:isBgImage
                              progress:nil
                             transform:nil
                             completed:nil];
}

/** 设置头像 */
- (void)jp_setUserIconWithURL:(NSURL *)imageURL
             placeholderImage:(UIImage *)placeholder
                        state:(UIControlState)state
                    isBgImage:(BOOL)isBgImage {
    [self jp_fakeSetPictureWithURL:imageURL
                  placeholderImage:placeholder
                             state:state
                         isBgImage:isBgImage];
}

/** 不带动画设置图片 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
            placeholderImage:(UIImage *)placeholder
                       state:(UIControlState)state
                   isBgImage:(BOOL)isBgImage {
    [self jp_setPictureWithURL:imageURL
              placeholderImage:placeholder
                         state:state
                     isBgImage:isBgImage
                     completed:nil];
}

/** 不带动画带完成block设置图片 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
            placeholderImage:(UIImage *)placeholder
                       state:(UIControlState)state
                   isBgImage:(BOOL)isBgImage
                   completed:(JPSetImageCompleted)completed {
    [self jp_setPictureWithFakeAnimate:NO
                     isCacheMemoryOnly:NO
                              imageURL:imageURL
                      placeholderImage:placeholder
                                 state:state
                             isBgImage:isBgImage
                              progress:nil
                             transform:nil
                             completed:completed];
}

/** 自己手动设置图片 */
- (void)jp_avoidSetImageWithURL:(NSURL *)picURL
                    placeholder:(UIImage *)placeholder
                          state:(UIControlState)state
                      isBgImage:(BOOL)isBgImage
                       progress:(JPSetImageProgress)progress
                      transform:(JPSetImageTransform)transform
                     completion:(JPSetImageCompleted)completion {
    if (isBgImage) {
        [self yy_setBackgroundImageWithURL:picURL
                                  forState:state
                               placeholder:placeholder
                                   options:YYWebImageOptionAvoidSetImage
                                  progress:[YYWebImageHelper jp2yyProgress:progress]
                                 transform:[YYWebImageHelper jp2yyTransform:transform]
                                completion:[YYWebImageHelper jp2yyCompletion:completion]];
    } else {
        [self yy_setImageWithURL:picURL
                        forState:state
                     placeholder:placeholder
                         options:YYWebImageOptionAvoidSetImage
                        progress:[YYWebImageHelper jp2yyProgress:progress]
                       transform:[YYWebImageHelper jp2yyTransform:transform]
                      completion:[YYWebImageHelper jp2yyCompletion:completion]];
    }
}

/** 取消请求图片 */
- (void)jp_cancelCurrentImageRequestForState:(UIControlState)state isBgImage:(BOOL)isBgImage {
    if (isBgImage) {
        [self yy_cancelBackgroundImageRequestForState:state];
    } else {
        [self yy_cancelImageRequestForState:state];
    }
}

@end
