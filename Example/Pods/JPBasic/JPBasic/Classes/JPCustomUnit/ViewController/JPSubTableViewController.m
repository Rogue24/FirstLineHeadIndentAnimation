//
//  JPSubTableViewController.m
//  WoTVEducation
//
//  Created by 周健平 on 2018/1/4.
//  Copyright © 2018年 沃视频. All rights reserved.
//

#import "JPSubTableViewController.h"
#import "JPMacro.h"
#import "UIViewController+JPExtension.h"

@implementation JPSubTableViewController
{
    BOOL _isAddedKVO;
    BOOL _isFirstDecelerate;
    BOOL _isDecelerate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstDecelerate = YES;
    [self jp_contentInsetAdjustmentNever:self.tableView];
}

- (void)dealloc {
    if (_isAddedKVO && self.tableView.panGestureRecognizer.observationInfo) {
        [self.tableView.panGestureRecognizer removeObserver:self forKeyPath:JPKeyPath(self.tableView.panGestureRecognizer, state)];
    }
}

- (void)setPanEndedHandle:(void (^)(UIScrollView *))panEndedHandle {
    _panEndedHandle = [panEndedHandle copy];
    if (panEndedHandle != nil) {
        if (!_isAddedKVO) {
            _isAddedKVO = YES;
            [self.tableView.panGestureRecognizer addObserver:self forKeyPath:JPKeyPath(self.tableView.panGestureRecognizer, state) options:NSKeyValueObservingOptionNew context:nil];
        }
    } else {
        if (_isAddedKVO) {
            _isAddedKVO = NO;
            [self.tableView.panGestureRecognizer removeObserver:self forKeyPath:JPKeyPath(self.tableView.panGestureRecognizer, state)];
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
    if (state == UIGestureRecognizerStateEnded) !self.panEndedHandle ? : self.panEndedHandle(self.tableView);
}

@end
