//
//  WTVPUGCOptionButton.m
//  WoTV
//
//  Created by 周健平 on 2020/4/22.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "WTVPUGCOptionButton.h"

@interface WTVPUGCOptionButton ()
@property (nonatomic, weak) UIView *countView;
@end

@implementation WTVPUGCOptionButton

+ (CGSize)buttonSize {
    return CGSizeMake(JPScaleValue(60), JPScaleValue(40));
}

+ (instancetype)zanButton {
    return [[self alloc] initWithFrame:(CGRect){CGPointZero, self.buttonSize}
                            normalIcon:@"hotspot_icon_like_normat"
                            selectIcon:@"hotspot_icon_like_selected"
                           normalColor:JPRGBColor(43, 43, 43)
                           selectColor:JPRGBColor(255, 151, 0)];
}
+ (instancetype)collectButton {
    return [[self alloc] initWithFrame:(CGRect){CGPointZero, self.buttonSize}
                            normalIcon:@"player_pugc_collection"
                            selectIcon:@"collection_selected"
                           normalColor:JPRGBColor(43, 43, 43)
                           selectColor:JPRGBColor(255, 39, 38)];
}
+ (instancetype)forwardButton {
    return [[self alloc] initWithFrame:(CGRect){CGPointZero, self.buttonSize}
                            normalIcon:@"hotspot_icon_share"
                            selectIcon:nil
                           normalColor:JPRGBColor(43, 43, 43)
                           selectColor:nil];
}
+ (instancetype)commentButton {
    return [[self alloc] initWithFrame:(CGRect){CGPointZero, self.buttonSize}
                            normalIcon:@"hotspot_icon_information"
                            selectIcon:nil
                           normalColor:JPRGBColor(43, 43, 43)
                           selectColor:nil];
}
+ (instancetype)moreButton {
    WTVPUGCOptionButton *moreBtn = [[WTVPUGCOptionButton alloc] initWithFrame:CGRectMake(0, 0, JPScaleValue(20 + 3 + 16), JPScaleValue(40))];
    moreBtn.normalIcon = @"hotspot_icon_more";
    UIImage *image = [UIImage imageNamed:moreBtn.normalIcon];
    CGFloat iconW = JPScaleValue(3);
    CGFloat iconH = iconW * (image.size.height / image.size.width);
    CGFloat iconX = moreBtn.jp_width - iconW - JPScaleValue(16);
    CGFloat iconY = JPHalfOfDiff(moreBtn.jp_height, iconH);
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconW, iconH)];
    iconView.image = image;
    iconView.userInteractionEnabled = NO;
    [moreBtn addSubview:iconView];
    moreBtn.iconView = iconView;
    return moreBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
                   normalIcon:(NSString *)normalIcon
                   selectIcon:(NSString *)selectIcon
                  normalColor:(UIColor *)normalColor
                  selectColor:(UIColor *)selectColor {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        self.scale = 0.88;
        
        _normalIcon = normalIcon;
        _selectIcon = selectIcon;
        _normalColor = normalColor;
        _selectColor = selectColor;
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:normalIcon]];
        iconView.userInteractionEnabled = NO;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(JPScaleValue(20)));
            make.center.equalTo(self);
        }];
        self.iconView = iconView;
        
        UILabel *countLabel = ({
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.textColor = normalColor;
            aLabel.font = JPScaleBoldFont(10);
            aLabel;
        });
        [self addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconView.mas_right).offset(-JP5Margin);
            make.bottom.equalTo(iconView.mas_top).offset(JP5Margin);
        }];
        self.countLabel = countLabel;
    }
    return self;
}

#pragma mark - set & get

- (void)setNormalIcon:(NSString *)normalIcon {
    _normalIcon = normalIcon;
    if (!self.isSelected) self.iconView.image = [UIImage imageNamed:normalIcon];
}

- (void)setSelectIcon:(NSString *)selectIcon {
    _selectIcon = selectIcon;
    if (self.isSelected) self.iconView.image = [UIImage imageNamed:(selectIcon ? selectIcon : self.normalIcon)];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    if (!self.isSelected) self.countLabel.textColor = normalColor;
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    if (self.isSelected) self.countLabel.textColor = selectColor ? selectColor : self.normalColor;
}

- (void)setCountStr:(NSString *)countStr {
    self.countLabel.text = countStr;
    self.countLabel.hidden = countStr == nil;
    self.countView.hidden = self.countLabel.hidden;
}

- (NSString *)countStr {
    return self.countLabel.text;
}

- (void)setIsSelected:(BOOL)isSelected {
    [self setIsSelected:isSelected animated:NO];
}

- (void)setIsSelected:(BOOL)isSelected animated:(BOOL)isAnamated {
    if (!self.selectColor && !self.selectIcon) isSelected = NO;
    if (_isSelected == isSelected) {
        return;
    }
    _isSelected = isSelected;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.layer pop_removeAllAnimations];
    self.layer.transform = CATransform3DIdentity;
    self.iconView.image = [UIImage imageNamed:(isSelected && self.selectIcon ? self.selectIcon : self.normalIcon)];
    self.countLabel.textColor = isSelected && self.selectColor ? self.selectColor : self.normalColor;
    [CATransaction commit];
    
    if (isAnamated) {
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        anim.fromValue = @(CGPointMake(0.8, 0.8));
        anim.toValue = @(CGPointMake(1.0, 1.0));
        anim.springSpeed = self.recoverSpeed;
        anim.springBounciness = self.recoverBounciness;
        [self.layer pop_addAnimation:anim forKey:kPOPLayerScaleXY];
    }
}

@end
