//
//  JPIconButton.h
//  Infinitee2.0
//
//  Created by guanning on 2016/12/19.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPIconButton : UIButton

+ (JPIconButton *)iconButtonWithIcon:(NSString *)icon
                            iconSize:(CGSize)iconSize
                               title:(NSString *)title
                           titleFont:(UIFont *)titleFont
                          titleColor:(UIColor *)titleColor
                   contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                               space:(CGFloat)space
                          isVertical:(BOOL)isVertical;

@property (nonatomic, assign) UIEdgeInsets jp_contentEdgeInsets;
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, assign) BOOL isVertical;

- (void)updateIconSize:(CGSize)iconSize
             titleFont:(UIFont *)titleFont
     contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                 space:(CGFloat)space
            isVertical:(BOOL)isVertical;

@end
