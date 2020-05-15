//
//  JPSubScrollViewController.m
//  WoLive
//
//  Created by 周健平 on 2019/8/9.
//  Copyright © 2019 zhanglinan. All rights reserved.
//

#import "JPSubScrollViewController.h"
#import "JPMacro.h"
#import "UIViewController+JPExtension.h"

@implementation JPSubScrollViewController
{
    BOOL _isAddedKVO;
    BOOL _isFirstDecelerate;
    BOOL _isDecelerate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstDecelerate = YES;
}

- (void)dealloc {
    if (_isAddedKVO && self.scrollView.panGestureRecognizer.observationInfo) {
        [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:JPKeyPath(self.scrollView.panGestureRecognizer, state)];
    }
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    [self jp_contentInsetAdjustmentNever:scrollView];
    [self addPanKVO];
}

- (void)setPanEndedHandle:(void (^)(UIScrollView *))panEndedHandle {
    _panEndedHandle = [panEndedHandle copy];
    [self addPanKVO];
}

- (void)addPanKVO {
    if (!_scrollView) return;
    if (_panEndedHandle != nil) {
        if (!_isAddedKVO) {
            _isAddedKVO = YES;
            [self.scrollView.panGestureRecognizer addObserver:self forKeyPath:JPKeyPath(self.scrollView.panGestureRecognizer, state) options:NSKeyValueObservingOptionNew context:nil];
        }
    } else {
        if (_isAddedKVO) {
            _isAddedKVO = NO;
            [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:JPKeyPath(self.scrollView.panGestureRecognizer, state)];
        }
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.willBeginDraggingHandle ? : self.willBeginDraggingHandle(scrollView);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.didScrollHandle ? : self.didScrollHandle(scrollView);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isFirstDecelerate) {
        _isFirstDecelerate = NO;
        _isDecelerate = decelerate;
    }
    if (!_isDecelerate) [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isFirstDecelerate = YES;
    !self.didEndScrollHandle ? : self.didEndScrollHandle(scrollView);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UIGestureRecognizerState state = [change[NSKeyValueChangeNewKey] integerValue];
    if (state == UIGestureRecognizerStateEnded) !self.panEndedHandle ? : self.panEndedHandle(self.scrollView);
}

@end
