//
//  JPTextView.h
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>

// 光标初始x值
UIKIT_EXTERN CGFloat const JPCursorMargin; // 5.0

@interface JPTextView : UITextView
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, copy) void (^firstResponderHandle)(JPTextView *textView, BOOL isFirstResponder);

@property (nonatomic, assign) NSUInteger maxLimitNums;
@property (nonatomic, copy) void (^reachMaxLimitNums)(NSInteger maxLimitNums); // 已达最多字数的block

@property (nonatomic, assign) BOOL textKeepTheTop;

@property (nonatomic, copy) void (^textDidBeginEditing)(JPTextView *textView);
@property (nonatomic, copy) void (^textDidChange)(JPTextView *textView, BOOL isLenovo);
@property (nonatomic, copy) void (^textDidEndEditing)(JPTextView *textView);

@property (nonatomic, copy) BOOL (^returnKeyDidClick)(JPTextView *textView, NSString *finalText);

- (void)setAndCheckText:(NSString *)text;
@end
