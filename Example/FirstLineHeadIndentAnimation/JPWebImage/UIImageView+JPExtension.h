//
//  UIImageView+JPExtension.h
//  Infinitee2.0
//
//  Created by zhoujianping on 16/11/24.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPWebImageHeader.h"

@interface UIImageView (JPExtension)

#pragma mark - YYWebImage封装

/** 所有参数自定义 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
                     options:(JPWebImageOptions)options
                   isRounded:(BOOL)isRounded
            placeholderImage:(UIImage *)placeholder
                    progress:(JPSetImageProgress)progress
                   transform:(JPSetImageTransform)transform
                   completed:(JPSetImageCompleted)completed;

/** 自定义带动画、是否缓存、带进度、图片设置、完成block */
- (void)jp_setPictureWithFakeAnimate:(BOOL)isAnimate
                   isCacheMemoryOnly:(BOOL)isCacheMemoryOnly
                            imageURL:(NSURL *)imageURL
                    placeholderImage:(UIImage *)placeholder
                            progress:(JPSetImageProgress)progress
                           transform:(JPSetImageTransform)transform
                           completed:(JPSetImageCompleted)completed;

/** 淡入淡出带进度、图片切圆带边框、完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                        progress:(JPSetImageProgress)progress
                      targetSize:(CGSize)targetSize
                    circleRadius:(CGFloat)radius
                     borderWidth:(CGFloat)borderWidth
                     borderColor:(UIColor *)borderColor
                       completed:(JPSetImageCompleted)completed;

/** 淡入淡出、图片切圆、完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                      targetSize:(CGSize)targetSize
                    circleRadius:(CGFloat)radius
                       completed:(JPSetImageCompleted)completed;

/** 淡入淡出带进度、图片设置、完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                        progress:(JPSetImageProgress)progress
                       transform:(JPSetImageTransform)transform
                       completed:(JPSetImageCompleted)completed;

/** 淡入淡出带完成block */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder
                       completed:(JPSetImageCompleted)completed;

/** 淡入淡出 */
- (void)jp_fakeSetPictureWithURL:(NSURL *)imageURL
                placeholderImage:(UIImage *)placeholder;

/** 淡入淡出只缓存到内存 */
- (void)jp_fakeSetPictureCacheMemoryOnlyWithURL:(NSURL *)imageURL
                               placeholderImage:(UIImage *)placeholder;

/** 不带动画设置图片 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
            placeholderImage:(UIImage *)placeholder;

/** 不带动画带完成block设置图片 */
- (void)jp_setPictureWithURL:(NSURL *)imageURL
            placeholderImage:(UIImage *)placeholder
                   completed:(JPSetImageCompleted)completed;

/** 自己手动设置图片 */
- (void)jp_avoidSetImageWithURL:(NSURL *)picURL
                    placeholder:(UIImage *)placeholder
                       progress:(JPSetImageProgress)progress
                      transform:(JPSetImageTransform)transform
                     completion:(JPSetImageCompleted)completion;

/** 取消请求图片 */
- (void)jp_cancelCurrentImageRequest;

@end
