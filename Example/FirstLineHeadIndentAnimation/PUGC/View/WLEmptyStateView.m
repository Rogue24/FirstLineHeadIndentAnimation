//
//  WLEmptyStateView.m
//  WoLive
//
//  Created by 周健平 on 2019/8/19.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import "WLEmptyStateView.h"

@implementation WLEmptyStateView
{
    CGFloat _imageHeight;
    CGFloat _titleMinH;
}

+ (instancetype)emptyStateViewWithState:(WLEmptyState)state
                                  title:(NSString *)title
                              imageName:(NSString *)imageName
                    noDataDidClickBlock:(void (^)(WLEmptyStateView *esView))noDataDidClickBlock
                            onSuperView:(UIView *)onSuperView
                        makeConstraints:(void (^)(MASConstraintMaker *make))makeConstraints {
    
    WLEmptyStateView *esView = [[self alloc] initWithState:state title:title imageName:imageName];
    esView.noDataDidClickBlock = noDataDidClickBlock;
    
    esView.layer.zPosition = -1;
    [onSuperView insertSubview:esView atIndex:0];
    [esView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (makeConstraints) {
            makeConstraints(make);
        } else {
            make.center.equalTo(onSuperView);
        }
    }];
    [esView layoutIfNeeded];
    
    if (state == WLEmptyState_HadData) {
        esView.alpha = 0;
    }
    
    return esView;
}

- (instancetype)initWithState:(WLEmptyState)state title:(NSString *)title imageName:(NSString *)imageName {
    if (self = [super init]) {
        _state = state;
        _imageHeight = JPHScaleValue(110);
        
        UIImageView *imageView = ({
            UIImageView *aImgView = [[UIImageView alloc] init];
            aImgView.image = [UIImage imageNamed:imageName];
            aImgView;
        });
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *titleLabel = ({
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.numberOfLines = 0;
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.font = JPScaleFont(13);
            aLabel.textColor = JPRGBColor(155, 155, 155);
            aLabel.text = title;
            aLabel;
        });
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIActivityIndicatorView *jvhua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        jvhua.hidesWhenStopped = NO;
        jvhua.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [self addSubview:jvhua];
        self.jvhua = jvhua;
        
        CGFloat h = _imageHeight;
        CGFloat w = imageView.image ? (h * imageView.image.size.width / imageView.image.size.height) : h;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(CGSizeMake(w, h)));
            make.left.right.top.centerX.equalTo(self);
        }];
        
        _titleMinH = JPScaleValue(17);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(CGSizeMake(JPPortraitScreenWidth, self->_titleMinH)));
            make.top.equalTo(imageView.mas_bottom).offset(JP15Margin);
            make.bottom.centerX.equalTo(self);
        }];
        
        CGFloat titleW = [JPSolveTool oneLineTextFrameWithText:title font:titleLabel.font].size.width;
        [jvhua mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.centerX.equalTo(titleLabel).offset(-(titleW * 0.5 + 18));
        }];
        
        if (state == WLEmptyState_Loading) {
            [jvhua startAnimating];
        } else {
            jvhua.alpha = 0;
            [jvhua stopAnimating];
        }
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGR];
        self.tapGR = tapGR;
    }
    return self;
}

- (void)setNoDataDidClickBlock:(void (^)(WLEmptyStateView *))noDataDidClickBlock {
    _noDataDidClickBlock = [noDataDidClickBlock copy];
    self.tapGR.enabled = (noDataDidClickBlock != nil && _state == WLEmptyState_NoData);
}

- (void)updateState:(WLEmptyState)state imageName:(NSString *)imageName title:(NSString *)title otherBtn:otherBtn isRemove:(BOOL)isRemove animated:(BOOL)animated complete:(void(^)(void))complete {
    
    BOOL isChangeImage = imageName != nil;
    BOOL isChangeTitle = title != nil && ![title isEqualToString:self.titleLabel.text];
    CGSize titleSize = self.titleLabel.jp_size;
    if (isChangeTitle) {
        titleSize = [JPSolveTool textFrameWithText:title maxSize:CGSizeMake(JPPortraitScreenWidth, 999) font:self.titleLabel.font lineSpace:0].size;
    }
    
    if (_state == state && !isChangeImage && !isChangeTitle) {
        !complete ? : complete();
        return;
    }
    
    void (^changeStateComplete)(void);
    
    if (state == WLEmptyState_HadData) {
        _state = state;
        changeStateComplete = ^{
            if (isRemove) {
                [self removeFromSuperview];
            } else {
                self.tapGR.enabled = NO;
                self.otherBtn.alpha = 0;
                self.jvhua.alpha = 0;
                [self.jvhua stopAnimating];
                if (isChangeImage) {
                    UIImage *image = [UIImage imageNamed:imageName];
                    CGFloat h = self->_imageHeight;
                    CGFloat w = image ? (h * image.size.width / image.size.height) : h;
                    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.equalTo(@(CGSizeMake(w, h)));
                    }];
                    self.imageView.image = image;
                }
                if (isChangeTitle) {
                    [self.jvhua mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.titleLabel).offset(-(titleSize.width * 0.5 + 18));
                    }];
                    self.titleLabel.text = title;
                }
                [self layoutIfNeeded];
            }
        };
        if (animated && self.alpha > 0) {
            [UIView animateWithDuration:0.16 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                changeStateComplete();
                !complete ? : complete();
            }];
        } else {
            self.alpha = 0;
            changeStateComplete();
            !complete ? : complete();
        }
        return;
    }
    
    BOOL isLoading = state == WLEmptyState_Loading;
    BOOL isSameState = _state == state;
    _state = state;
    
    if (isChangeTitle && isLoading) {
        [self.jvhua mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.titleLabel).offset(-(titleSize.width * 0.5 + 18));
        }];
        if (!isSameState) [self layoutIfNeeded];
    }
    
    if (isLoading) {
        [self.jvhua startAnimating];
    } else {
        [self addOtherBtn:otherBtn];
    }
    
    self.tapGR.enabled = (!isLoading && self.noDataDidClickBlock != nil);
    
    void (^changeStateHandle)(void) = ^{
        self.alpha = 1;
        if (isChangeImage) {
            UIImage *image = [UIImage imageNamed:imageName];
            CGFloat h = self->_imageHeight;
            CGFloat w = image ? (h * image.size.width / image.size.height) : h;
            [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(@(CGSizeMake(w, h)));
            }];
            self.imageView.image = image;
        }
        if (isChangeTitle) {
            CGFloat titleH = titleSize.height;
            if (titleH < self->_titleMinH) titleH = self->_titleMinH;
            if (titleH != self.titleLabel.jp_height) {
                [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.equalTo(@(CGSizeMake(JPPortraitScreenWidth, titleH)));
                }];
            }
            self.titleLabel.text = title;
        }
        self.otherBtn.alpha = isLoading ? 0 : 1;
        self.jvhua.alpha = isLoading ? 1 : 0;
        [self layoutIfNeeded];
    };

    changeStateComplete = ^{
        if (!isLoading) {
            if (isChangeTitle && !isSameState) {
                CGFloat titleW = [JPSolveTool oneLineTextFrameWithText:title font:self.titleLabel.font].size.width;
                [self.jvhua mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.titleLabel).offset(-(titleW * 0.5 + 18));
                }];
                [self layoutIfNeeded];
            }
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            changeStateHandle();
        } completion:^(BOOL finished) {
            changeStateComplete();
            !complete ? : complete();
        }];
    } else {
        changeStateHandle();
        changeStateComplete();
        !complete ? : complete();
    }
}

- (void)loadingWithTitle:(NSString *)title imageName:(NSString *)imageName animated:(BOOL)animated {
    [self loadingWithTitle:title imageName:imageName animated:animated complete:nil];
}
- (void)loadingWithTitle:(NSString *)title imageName:(NSString *)imageName animated:(BOOL)animated complete:(void (^)(void))complete {
    [self updateState:WLEmptyState_Loading imageName:imageName title:title otherBtn:self.otherBtn isRemove:NO animated:animated complete:complete];
}

- (void)noDataWithTitle:(NSString *)title imageName:(NSString *)imageName otherBtn:(UIView *)otherBtn animated:(BOOL)animated {
    [self noDataWithTitle:title imageName:imageName otherBtn:otherBtn animated:animated complete:nil];
}
- (void)noDataWithTitle:(NSString *)title imageName:(NSString *)imageName otherBtn:(UIView *)otherBtn animated:(BOOL)animated complete:(void (^)(void))complete {
    [self updateState:WLEmptyState_NoData imageName:imageName title:title otherBtn:otherBtn isRemove:NO animated:animated complete:complete];
}

- (void)hadDataWithIsRemove:(BOOL)isRemove animated:(BOOL)animated {
    [self hadDataWithIsRemove:isRemove animated:animated complete:nil];
}
- (void)hadDataWithIsRemove:(BOOL)isRemove animated:(BOOL)animated complete:(void (^)(void))complete {
    [self updateState:WLEmptyState_HadData imageName:nil title:nil otherBtn:self.otherBtn isRemove:isRemove animated:animated complete:complete];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGR {
    !self.noDataDidClickBlock ? : self.noDataDidClickBlock(self);
}

- (void)addOtherBtn:(UIView *)otherBtn {
    if (self.otherBtn == otherBtn) return;
    
    if (self.otherBtn) [self.otherBtn removeFromSuperview];
    if (!otherBtn) {
        self.otherBtn = nil;
        return;
    }
    
    [self addSubview:otherBtn];
    [otherBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(JP12Margin);
        !self.otherBtnConstraintsConfirmBlock ? : self.otherBtnConstraintsConfirmBlock(make);
    }];
    self.otherBtn = otherBtn;
    
    otherBtn.alpha = 0;
    [self layoutIfNeeded];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL pointInside = [super pointInside:point withEvent:event];
    if (!pointInside && self.otherBtn && self.otherBtn.alpha) {
        if (CGRectContainsPoint(self.otherBtn.frame, point)) {
            pointInside = YES;
        }
    }
    return pointInside;
}


@end
