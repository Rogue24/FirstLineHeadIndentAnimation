//
//  JPImageView.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/11.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPWebImageHeader.h"

@interface JPImageView : UIView

@property (nonatomic, strong) UIImage *image;

- (void)setImageWithURL:(NSURL *)picURL
            placeholder:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)picURL
            placeholder:(UIImage *)placeholder
             completion:(JPSetImageCompleted)completion;

- (void)setImageWithURL:(NSURL *)picURL
            placeholder:(UIImage *)placeholder
             targetSize:(CGSize)targetSize
           circleRadius:(CGFloat)radius
             completion:(JPSetImageCompleted)completion;

- (void)setImageWithURL:(NSURL *)picURL
            placeholder:(UIImage *)placeholder
              progress:(void(^)(float percent))progress
            targetSize:(CGSize)targetSize
          circleRadius:(CGFloat)radius
           borderWidth:(CGFloat)borderWidth
           borderColor:(UIColor *)borderColor
            completion:(JPSetImageCompleted)completion;

- (void)setImageWithURL:(NSURL *)picURL
            fakeAnimate:(BOOL)isAnimate
            placeholder:(UIImage *)placeholder
               progress:(JPSetImageProgress)progress
              transform:(JPSetImageTransform)transform
             completion:(JPSetImageCompleted)completion;

- (void)avoidSetImageWithURL:(NSURL *)picURL
                 placeholder:(UIImage *)placeholder
                    progress:(JPSetImageProgress)progress
                   transform:(JPSetImageTransform)transform
                  completion:(JPSetImageCompleted)completion;

- (void)jp_cancelCurrentImageRequest;
@end
