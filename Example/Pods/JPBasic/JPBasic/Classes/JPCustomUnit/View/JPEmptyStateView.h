//
//  JPEmptyStateView.h
//  WoLive
//
//  Created by 周健平 on 2019/2/23.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPEmptyStateView : UIView
+ (instancetype)emptyStateViewWithImageName:(NSString *)imageName title:(NSString *)title;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIActivityIndicatorView *jvhua;
@property (nonatomic, weak) UILabel *titleLabel;
- (void)updateImage:(NSString *)imageName title:(NSString *)title animated:(BOOL)animated;
@end
