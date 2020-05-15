//
//  UIButton+JPExtension.h
//  WoTV
//
//  Created by 周健平 on 2018/8/27.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPWebImageHeader.h"

@interface UIButton (JPExtension)

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
                   completed:(JPSetImageCompleted)completed;

/** 自定义带动画、是否缓存、带进度、图片设置、完成block */
- (void)jp_setPictureWithFakeAnimate:(BOOL)isAnimate
                   isCacheMemoryOnly:(BOOL)isCacheMemoryOnly
                            imageURL:(NSURL *)imageURL
                    placeholderImage:(UIImage *)placeholder
                               state:(UIControlState)state
                           isBgImage:(BOOL)isBgImage
                            progress:(JPSetImageProgress)progress
                           transform:(JPSetImageTransform)transform
                           completed:(JPSetImageCompleted)completed;

/** 淡入淡出带进度、图片切圆带边框、完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                           state:(UIControlState)state
                       isBgImage:(BOOL)isBgImage
                        progress:(void(^)(float percent))progress
                      targetSize:(CGSize)targetSize
                    circleRadius:(CGFloat)radius
                     borderWidth:(CGFloat)borderWidth
                     borderColor:(UIColor *)borderColor
                       completed:(JPSetImageCompleted)completed;

/** 淡入淡出、图片切圆、完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                           state:(UIControlState)state
                       isBgImage:(BOOL)isBgImage
                      targetSize:(CGSize)targetSize
                    circleRadius:(CGFloat)radius
                       completed:(JPSetImageCompleted)completed;

/** 淡入淡出带进度、图片设置、完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                           state:(UIControlState)state
                       isBgImage:(BOOL)isBgImage
                        progress:(void(^)(float percent))progress
                       transform:(JPSetImageTransform)transform
                       completed:(JPSetImageCompleted)completed;

/** 淡入淡出带完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                           state:(UIControlState)state
                       isBgImage:(BOOL)isBgImage
                       completed:(JPSetImageCompleted)completed;

/** 淡入淡出 */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL 
                placeholderImage:(UIImage *)placeholder
                           state:(UIControlState)state
                       isBgImage:(BOOL)isBgImage;

/** 淡入淡出只缓存到内存 */
- (void)jp_fakeSetPictureCacheMemoryOnlyWithURL:(NSURL *)imageURL
                               placeholderImage:(UIImage *)placeholder
                                          state:(UIControlState)state
                                      isBgImage:(BOOL)isBgImage;

/** 不带动画设置图片 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
            placeholderImage:(UIImage *)placeholder
                       state:(UIControlState)state
                   isBgImage:(BOOL)isBgImage;

/** 不带动画带完成block设置图片 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
            placeholderImage:(UIImage *)placeholder
                       state:(UIControlState)state
                   isBgImage:(BOOL)isBgImage
                   completed:(JPSetImageCompleted)completed;

/** 自己手动设置图片 */
- (void)jp_avoidSetImageWithURL:(NSURL *)picURL
                    placeholder:(UIImage *)placeholder
                          state:(UIControlState)state
                      isBgImage:(BOOL)isBgImage
                       progress:(JPSetImageProgress)progress
                      transform:(JPSetImageTransform)transform
                     completion:(JPSetImageCompleted)completion;

/** 取消请求图片 */
- (void)jp_cancelCurrentImageRequestForState:(UIControlState)state isBgImage:(BOOL)isBgImage;

@end
