//
//  JPIconButton.m
//  Infinitee2.0
//
//  Created by guanning on 2016/12/19.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "JPIconButton.h"
#import "UIView+JPExtension.h"
#import "JPSolveTool.h"

@implementation JPIconButton
{
    CGRect _iconFrame;
    CGRect _titleFrame;
}

+ (JPIconButton *)iconButtonWithIcon:(NSString *)icon
                            iconSize:(CGSize)iconSize
                               title:(NSString *)title
                           titleFont:(UIFont *)titleFont
                          titleColor:(UIColor *)titleColor
                   contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                               space:(CGFloat)space
                          isVertical:(BOOL)isVertical {
    JPIconButton *btn = [JPIconButton buttonWithType:UIButtonTypeSystem];
    btn.contentEdgeInsets = UIEdgeInsetsZero;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setImage:[[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [btn updateIconSize:iconSize titleFont:titleFont contentEdgeInsets:contentEdgeInsets space:space isVertical:isVertical];
    return btn;
}

- (void)updateIconSize:(CGSize)iconSize
             titleFont:(UIFont *)titleFont
     contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                 space:(CGFloat)space
            isVertical:(BOOL)isVertical {
    
    self.isVertical = isVertical;
    self.space = space;
    self.jp_contentEdgeInsets = contentEdgeInsets;
    self.titleLabel.font = titleFont;
    
    CGRect titleFrame = [JPSolveTool oneLineTextFrameWithText:[self titleForState:UIControlStateNormal] font:titleFont];
    
    UIImage *iconImage = [self imageForState:UIControlStateNormal];
    CGFloat w = iconImage.size.width;
    CGFloat h = iconImage.size.height;
    CGRect iconFrame = CGRectMake(0, 0, w, h);
    if (!CGSizeEqualToSize(iconSize, CGSizeZero)) {
        iconFrame = CGRectMake(0, 0, iconSize.width, iconSize.height);
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
    if (self.isVertical) {
        w = MAX(iconFrame.size.width, titleFrame.size.width);
        iconFrame.origin.x = contentEdgeInsets.left + JPHalfOfDiff(w, iconFrame.size.width);
        iconFrame.origin.y = contentEdgeInsets.top;
        titleFrame.origin.x = contentEdgeInsets.left + JPHalfOfDiff(w, titleFrame.size.width);
        titleFrame.origin.y = CGRectGetMaxY(iconFrame) + self.space;
        w += contentEdgeInsets.left + contentEdgeInsets.right;
        h = contentEdgeInsets.top + iconFrame.size.height + self.space + titleFrame.size.height + contentEdgeInsets.bottom;
    } else {
        h = MAX(iconFrame.size.height, titleFrame.size.height);
        iconFrame.origin.x = contentEdgeInsets.left;
        iconFrame.origin.y = contentEdgeInsets.top + JPHalfOfDiff(h, iconFrame.size.height);
        titleFrame.origin.x = CGRectGetMaxX(iconFrame) + self.space;
        titleFrame.origin.y = contentEdgeInsets.top + JPHalfOfDiff(h, titleFrame.size.height);
        h += contentEdgeInsets.top + contentEdgeInsets.bottom;
        w = contentEdgeInsets.left + iconFrame.size.width + self.space + titleFrame.size.width + contentEdgeInsets.right;
    }
    
    _iconFrame = iconFrame;
    _titleFrame = titleFrame;
    self.jp_size = CGSizeMake(w, h);
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (_iconFrame.size.width) self.imageView.frame = _iconFrame;
    if (_titleFrame.size.width) self.titleLabel.frame = _titleFrame;
}


@end
