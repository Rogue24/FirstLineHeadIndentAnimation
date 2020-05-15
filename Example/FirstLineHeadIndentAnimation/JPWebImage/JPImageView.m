//
//  JPImageView.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/11.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "JPImageView.h"
#import "YYWebImageHelper.h"

@implementation JPImageView
{
    UIImage *_image;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.layer.contents = (id)image.CGImage;
}

- (UIImage *)image {
    id content = self.layer.contents;
    if (content != (id)_image.CGImage) {
        CGImageRef ref = (__bridge CGImageRef)(content);
        if (ref && CFGetTypeID(ref) == CGImageGetTypeID()) {
            _image = [UIImage imageWithCGImage:ref scale:self.layer.contentsScale orientation:UIImageOrientationUp];
        } else {
            _image = nil;
        }
    }
    return _image;
}

- (void)setImageWithURL:(NSURL *)picURL placeholder:(UIImage *)placeholder {
    [self setImageWithURL:picURL
              fakeAnimate:YES
              placeholder:placeholder
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)setImageWithURL:(NSURL *)picURL
            placeholder:(UIImage *)placeholder
             completion:(JPSetImageCompleted)completion {
    [self setImageWithURL:picURL
              fakeAnimate:YES
              placeholder:placeholder
                 progress:nil
                transform:nil
               completion:completion];
}

- (void)setImageWithURL:(NSURL *)picURL
            placeholder:(UIImage *)placeholder
             targetSize:(CGSize)targetSize
           circleRadius:(CGFloat)radius
             completion:(JPSetImageCompleted)completion {
    [self setImageWithURL:picURL
              placeholder:placeholder
                 progress:nil
               targetSize:targetSize
             circleRadius:radius
              borderWidth:0
              borderColor:nil
               completion:completion];
}

- (void)setImageWithURL:(NSURL *)picURL
            placeholder:(UIImage *)placeholder
               progress:(void(^)(float percent))progress
             targetSize:(CGSize)targetSize
           circleRadius:(CGFloat)radius
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor
             completion:(JPSetImageCompleted)completion {
    [self setImageWithURL:picURL
              fakeAnimate:YES
              placeholder:placeholder
                 progress:nil
                transform:^UIImage *(UIImage *image, NSURL *imageURL) {
                    image = [image yy_imageByResizeToSize:targetSize contentMode:UIViewContentModeScaleAspectFill];
                    return [image yy_imageByRoundCornerRadius:radius borderWidth:borderWidth borderColor:borderColor];
                }
               completion:completion];
}

- (void)setImageWithURL:(NSURL *)picURL
            fakeAnimate:(BOOL)isAnimate
            placeholder:(UIImage *)placeholder
               progress:(JPSetImageProgress)progress
              transform:(JPSetImageTransform)transform
             completion:(JPSetImageCompleted)completion {
    
    YYWebImageOptions options = kNilOptions;
    if (isAnimate) options = YYWebImageOptionSetImageWithFadeAnimation;
    
    [self.layer yy_setImageWithURL:picURL
                       placeholder:placeholder
                           options:options
                          progress:[YYWebImageHelper jp2yyProgress:progress]
                         transform:[YYWebImageHelper jp2yyTransform:transform]
                        completion:[YYWebImageHelper jp2yyCompletion:completion]];
}

- (void)avoidSetImageWithURL:(NSURL *)picURL
                 placeholder:(UIImage *)placeholder
                    progress:(JPSetImageProgress)progress
                   transform:(JPSetImageTransform)transform
                  completion:(JPSetImageCompleted)completion {
    [self.layer yy_setImageWithURL:picURL
                       placeholder:placeholder
                           options:YYWebImageOptionAvoidSetImage
                          progress:[YYWebImageHelper jp2yyProgress:progress]
                         transform:[YYWebImageHelper jp2yyTransform:transform]
                        completion:[YYWebImageHelper jp2yyCompletion:completion]];
}

- (void)jp_cancelCurrentImageRequest {
    [self.layer yy_cancelCurrentImageRequest];
}

@end
