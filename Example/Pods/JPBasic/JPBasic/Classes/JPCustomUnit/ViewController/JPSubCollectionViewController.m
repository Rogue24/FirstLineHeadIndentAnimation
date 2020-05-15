//
//  JPSubCollectionViewController.m
//  WoTVEducation
//
//  Created by 周健平 on 2018/1/4.
//  Copyright © 2018年 沃视频. All rights reserved.
//

#import "JPSubCollectionViewController.h"
#import "JPMacro.h"
#import "UIViewController+JPExtension.h"

@implementation JPSubCollectionViewController
{
    BOOL _isAddedKVO;
    BOOL _isFirstDecelerate;
    BOOL _isDecelerate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstDecelerate = YES;
    [self jp_contentInsetAdjustmentNever:self.collectionView];
}

- (void)dealloc {
    if (_isAddedKVO && self.collectionView.panGestureRecognizer.observationInfo) {
        [self.collectionView.panGestureRecognizer removeObserver:self forKeyPath:JPKeyPath(self.collectionView.panGestureRecognizer, state)];
    }
}

- (void)setPanEndedHandle:(void (^)(UIScrollView *))panEndedHandle {
    _panEndedHandle = [panEndedHandle copy];
    if (panEndedHandle != nil) {
        if (!_isAddedKVO) {
            _isAddedKVO = YES;
            [self.collectionView.panGestureRecognizer addObserver:self forKeyPath:JPKeyPath(self.collectionView.panGestureRecognizer, state) options:NSKeyValueObservingOptionNew context:nil];
        }
    } else {
        if (_isAddedKVO) {
            _isAddedKVO = NO;
            [self.collectionView.panGestureRecognizer removeObserver:self forKeyPath:JPKeyPath(self.collectionView.panGestureRecognizer, state)];
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

// scrollViewDidEndScrollingAnimation 会触发scrollViewDidScroll，但最后没有触发scrollViewDidEndDecelerating，如果想要在scrollViewDidEndDecelerating里面做统一处理，请动画后手动调用scrollViewDidEndDecelerating方法。
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    JPLog(@"scrollViewDidEndScrollingAnimation");
//}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UIGestureRecognizerState state = [change[NSKeyValueChangeNewKey] integerValue];
    if (state == UIGestureRecognizerStateEnded) !self.panEndedHandle ? : self.panEndedHandle(self.collectionView);
}

@end
