//
//  JPUnderlineButton.m
//  WoLive
//
//  Created by 周健平 on 2018/11/15.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import "JPUnderlineButton.h"
#import "UIView+JPExtension.h"
#import "JPConstant.h"

@interface JPUnderlineButton ()
@property (nonatomic, strong) CALayer *underline;
@end

@implementation JPUnderlineButton

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.underline) {
        self.underline.backgroundColor = self.titleLabel.textColor.CGColor;
        self.underline.frame = CGRectMake(self.underlinePadding, self.titleLabel.jp_height - JPBasePadding + self.underlineSpace, self.titleLabel.jp_width - self.underlinePadding * 2, 1);
    }
}

- (void)addUnderline {
    [self removeUnderline];
    self.underline = [CALayer layer];
    self.underline.cornerRadius = 0.5;
    [self.titleLabel.layer addSublayer:self.underline];
    [self setNeedsLayout];
}

- (void)removeUnderline {
    if (self.underline) {
        [self.underline removeFromSuperlayer];
        self.underline = nil;
    }
}

- (void)setIsShowUnderline:(BOOL)isShowUnderline {
    if (_isShowUnderline == isShowUnderline) return;
    _isShowUnderline = isShowUnderline;
    if (isShowUnderline) {
        [self addUnderline];
    } else {
        [self removeUnderline];
    }
}

- (void)setUnderlinePadding:(CGFloat)underlinePadding {
    _underlinePadding = underlinePadding;
    [self setNeedsLayout];
}

- (void)setUnderlineSpace:(CGFloat)underlineSpace {
    _underlineSpace = underlineSpace;
    [self setNeedsLayout];
}

@end
