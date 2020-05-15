//
//  JPCustomLayoutButton.m
//  WoTV
//
//  Created by 周健平 on 2019/9/9.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import "JPCustomLayoutButton.h"

@implementation JPCustomLayoutButton

/**
 * 例：图标置右，文字置左
    button.layoutSubviewsBlock = ^(UIButton *btn) {
        CGFloat space = JPScaleValue(4);
        CGFloat totalW = btn.imageView.jp_width + space + btn.titleLabel.jp_width;
        CGFloat totalMaxX = JPHalfOfDiff(btn.jp_width, totalW) + totalW;
        btn.imageView.jp_x = totalMaxX - btn.imageView.jp_width;
        btn.titleLabel.jp_x = btn.imageView.jp_x - btn.titleLabel.jp_width - space;
    };
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    !self.layoutSubviewsBlock ? : self.layoutSubviewsBlock(self);
}

@end
