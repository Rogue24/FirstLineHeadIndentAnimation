//
//  JPTextField.h
//  Infinitee2.0
//
//  Created by guanning on 2017/1/18.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPTextField : UITextField
@property (nonatomic, copy) void (^firstResponderHandle)(JPTextField *textField, BOOL isFirstResponder);

@property (nonatomic, assign) NSUInteger maxLimitNums;
@property (nonatomic, copy) void (^reachMaxLimitNums)(NSInteger maxLimitNums); // 已达最多字数的block

@property (nonatomic, assign) BOOL isNoSetText;

@property (nonatomic, copy) void (^textDidBeginEditing)(JPTextField *textField);
@property (nonatomic, copy) void (^textDidChange)(JPTextField *textField, BOOL isLenovo);
@property (nonatomic, copy) void (^textDidEndEditing)(JPTextField *textField);

@property (nonatomic, copy) void (^deleteBlock)(JPTextField *textField);

@property (nonatomic, copy) BOOL (^returnKeyDidClick)(JPTextField *textField, NSString *finalText);

- (void)setAndCheckText:(NSString *)text;
@end
