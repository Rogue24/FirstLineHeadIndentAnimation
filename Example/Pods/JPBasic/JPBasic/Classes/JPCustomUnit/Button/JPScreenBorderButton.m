//
//  JPScreenBorderButton.m
//  DesignSpaceRestructure
//
//  Created by 周健平 on 2017/12/16.
//  Copyright © 2017年 周健平. All rights reserved.
//

/**
 * 参考：http://www.jianshu.com/p/e4503b13baba
 * 原因，是系统先识别成通知中心的滑出事件，导致按钮的高亮状态显示有延迟，需要长按一段事件才能够正常出现。
 * 这样设置确实能够在屏幕底部正常使用按钮的高亮状态，但是当确实要唤出系统的通知中心的时候，按钮不能够取消它的高亮状态，结果就是底部按钮会停留在高亮状态下，重新点击一次才能够取消。解决方法是给按钮添加通知的监听，当检测到系统进入通知中心的时候进行取消按钮高亮状态。
 */

#import "JPScreenBorderButton.h"
#import "JPMacro.h"

@interface JPScreenBorderButton ()
@property (nonatomic, assign) BOOL jp_isHighlighted;
@end

@implementation JPScreenBorderButton
{
    CFRunLoopObserverRef _observer;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    if (_observer) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unHighlight) name:UIApplicationWillResignActiveNotification object:nil];
    
    @jp_weakify(self);
    _observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopExit, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        @jp_strongify(self);
        if (!self) return;
        self.jp_isHighlighted = NO;
    });
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopDefaultMode);
}

- (void)dealloc {  // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_observer) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopDefaultMode);
        CFRelease(_observer);
        _observer = NULL;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL inside = [super pointInside:point withEvent:event];
    if (inside) {
        self.jp_isHighlighted = YES;
    }
    return inside;
}

- (void)unHighlight {
    self.jp_isHighlighted = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.jp_isHighlighted = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.jp_isHighlighted = NO;
}

- (void)setJp_isHighlighted:(BOOL)jp_isHighlighted {
    if (_jp_isHighlighted == jp_isHighlighted) return;
    _jp_isHighlighted = jp_isHighlighted;
    self.highlighted = jp_isHighlighted;
    !self.highlightedDidChangedBlock ? : self.highlightedDidChangedBlock(jp_isHighlighted);
}

@end
