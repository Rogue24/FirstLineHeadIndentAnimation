//
//  WTVPUGCProfileIconView.m
//  WoTV
//
//  Created by 周健平 on 2020/5/12.
//  Copyright © 2020 zhanglinan. All rights reserved.
//

#import "WTVPUGCProfileIconView.h"

@implementation WTVPUGCProfileIconView

+ (CGFloat)iconWH {
    return JPScaleValue(36);
}

+ (instancetype)iconView {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = NO;
        
        self.icon = [[WTVPUGCProfileIcon alloc] initWithLogoWH:JPScaleValue(16)];
        [self addSubview:self.icon];
        
        self.nameLabel = ({
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.font = JPScaleBoldFont(14);
            aLabel.textAlignment = NSTextAlignmentLeft;
            aLabel.textColor = UIColor.blackColor;
            aLabel;
        });
        [self addSubview:self.nameLabel];
        
        self.followBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = JPScaleBoldFont(14);
            [btn setTitle:@"关注" forState:UIControlStateNormal];
            [btn setTitle:@"已关注" forState:UIControlStateSelected];
            [btn setTitleColor:JPRGBColor(255, 151, 0) forState:UIControlStateNormal];
            [btn setTitleColor:JPRGBColor(170, 170, 170) forState:UIControlStateSelected];
            [btn setTitle:@"关注" forState:(UIControlStateNormal | UIControlStateHighlighted)];
            [btn setTitle:@"已关注" forState:(UIControlStateSelected | UIControlStateHighlighted)];
            [btn setTitleColor:JPRGBAColor(255, 151, 0, 0.3) forState:(UIControlStateNormal | UIControlStateHighlighted)];
            [btn setTitleColor:JPRGBAColor(170, 170, 170, 0.3) forState:(UIControlStateSelected | UIControlStateHighlighted)];
            btn;
        });
        [self addSubview:self.followBtn];
                
        self.followBtnLine = [[UIView alloc] init];
        self.followBtnLine.backgroundColor = JPRGBColor(239, 239, 239);
        self.followBtnLine.layer.cornerRadius = 0.25;
        [self addSubview:self.followBtnLine];
        
        self.bottomLabel = ({
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.font = JPScaleFont(12);
            aLabel.textAlignment = NSTextAlignmentLeft;
            aLabel.textColor = JPRGBColor(170, 170, 170);
            aLabel.text = @"";
            aLabel;
        });
        [self addSubview:self.bottomLabel];
                
        // setContentCompressionResistancePriority：优先级越高，越不会被压缩
        [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.followBtn setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        // setContentHuggingPriority：优先级越高，越不会被拉伸
        [self.nameLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.followBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.equalTo(self.icon.mas_height);
        }];
        
        [self.followBtnLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel);
            make.right.equalTo(self.followBtn.mas_left).offset(-JPScaleValue(4));
            make.width.equalTo(@(0.5));
            make.height.equalTo(@(JPScaleValue(12)));
        }];
        
        [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel);
            make.right.lessThanOrEqualTo(self); // <=，距离右边可能有间距，但不会超出self的范围
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(JP8Margin);
            make.height.equalTo(@(JPScaleValue(14)));
            
            make.top.equalTo(self).offset(JPScaleValue(4));
            
            make.right.equalTo(self.followBtn.mas_left).offset(-JP8Margin).priority(999);
            make.right.equalTo(self).priority(1);
        }];
    }
    return self;
}

- (void)setIsNotNeedFollow:(BOOL)isNotNeedFollow {
    if (_isNotNeedFollow == isNotNeedFollow) return;
    _isNotNeedFollow = isNotNeedFollow;
    
    if (isNotNeedFollow) {
        self.followBtn.hidden = YES;
        self.followBtnLine.hidden = YES;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.followBtn.mas_left).offset(-JP8Margin).priority(1);
            make.right.equalTo(self).priority(999);
        }];
    } else {
        self.followBtn.hidden = NO;
        self.followBtnLine.hidden = NO;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.followBtn.mas_left).offset(-JP8Margin).priority(999);
            make.right.equalTo(self).priority(1);
        }];
    }
    
    [self layoutIfNeeded];
}

- (void)setIsFollowed:(BOOL)isFollowed animated:(BOOL)isAnimated {
    if (_isNotNeedFollow || !self.followBtn) return;
    if (isAnimated) {
        [UIView transitionWithView:self.followBtn.titleLabel duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.followBtn.selected = isFollowed;
        } completion:nil];
        [UIView animateWithDuration:0.15 animations:^{
            [self layoutIfNeeded];
        }];
    } else {
        self.followBtn.selected = isFollowed;
        [self layoutIfNeeded];
    }
}

@end
