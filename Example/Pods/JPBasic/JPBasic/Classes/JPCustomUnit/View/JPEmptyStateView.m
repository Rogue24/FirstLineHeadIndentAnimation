//
//  JPEmptyStateView.m
//  WoLive
//
//  Created by 周健平 on 2019/2/23.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import "JPEmptyStateView.h"
#import <Masonry/Masonry.h>
#import "JPSolveTool.h"
#import "UIColor+JPExtension.h"

@interface JPEmptyStateView ()
@property (nonatomic, weak) UIView *bottomView;
@end

@implementation JPEmptyStateView

+ (instancetype)emptyStateViewWithImageName:(NSString *)imageName title:(NSString *)title {
    JPEmptyStateView *esView = [[self alloc] init];
    
    UIImageView *imageView = ({
        UIImageView *aImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        aImgView;
    });
    [esView addSubview:imageView];
    esView.imageView = imageView;
    
//    UIView *bottomView = [[UIView alloc] init];
//    [esView addSubview:bottomView];
//    esView.bottomView = bottomView;
    
    //    UIActivityIndicatorView *jvhua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    jvhua.hidesWhenStopped = YES;
    //    [bottomView addSubview:jvhua];
    //    esView.jvhua = jvhua;
    
    UILabel *titleLabel = ({
        UILabel *aLabel = [[UILabel alloc] init];
        aLabel.textAlignment = NSTextAlignmentCenter;
        aLabel.font = JPScaleFont(12);
        aLabel.textColor = JPRGBColor(155, 155, 155);
        aLabel.text = title;
        aLabel;
    });
    [esView addSubview:titleLabel];
    esView.titleLabel = titleLabel;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(esView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(JP15Margin);
        make.centerX.bottom.equalTo(esView);
    }];
    
    return esView;
}

- (void)updateImage:(NSString *)imageName title:(NSString *)title animated:(BOOL)animated {
    if (!imageName && !title) {
        return;
    }
    if (animated) {
        if (imageName) {
            [UIView transitionWithView:self.imageView duration:0.25 options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionOverrideInheritedDuration) animations:^{
                self.imageView.image = [UIImage imageNamed:imageName];
            } completion:nil];
        }
        if (title) {
            [UIView transitionWithView:self.titleLabel duration:0.25 options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionOverrideInheritedDuration) animations:^{
                self.titleLabel.text = title;
            } completion:nil];
        }
    } else {
        if (imageName) {
            self.imageView.image = [UIImage imageNamed:imageName];
        }
        if (title) {
            self.titleLabel.text = title;
        }
    }
}


@end
