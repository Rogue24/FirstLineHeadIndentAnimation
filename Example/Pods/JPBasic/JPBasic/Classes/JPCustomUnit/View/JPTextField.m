//
//  JPTextField.m
//  Infinitee2.0
//
//  Created by guanning on 2017/1/18.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "JPTextField.h"

@interface JPTextField () <UITextFieldDelegate>

@end

@implementation JPTextField

#pragma mark - init

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
    self.delegate = self;
    [self addTarget:self action:@selector(eventEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - override method

// iPhone5 不知道为何切换类型相同的类（例如textfield之间切换）不能触发键盘通知方法，设置个block来主动触发
- (BOOL)becomeFirstResponder {
    BOOL currResponder = self.isFirstResponder;
    BOOL isFirstResponder = [super becomeFirstResponder];
    if (!currResponder) {
        !self.firstResponderHandle ? : self.firstResponderHandle(self, YES);
    }
    return isFirstResponder;
}

- (BOOL)resignFirstResponder {
    BOOL currResponder = self.isFirstResponder;
    BOOL isNotFirstResponder = [super resignFirstResponder];
    if (currResponder) {
        !self.firstResponderHandle ? : self.firstResponderHandle(self, NO);
    }
    return isNotFirstResponder;
}

- (void)setText:(NSString *)text {
    if (self.isNoSetText) text = nil;
    [super setText:text];
}

- (void)deleteBackward {
    [super deleteBackward];
    !self.deleteBlock ? : self.deleteBlock(self);
}

#pragma mark - setter

- (void)setIsNoSetText:(BOOL)isNoSetText {
    _isNoSetText = isNoSetText;
    if (isNoSetText) [self setAndCheckText:nil];
}

#pragma mark - public method

- (void)setAndCheckText:(NSString *)text {
    if (self.maxLimitNums > 0 && text.length > self.maxLimitNums) {
        // 截取到最大位置的字符(由于超出截部分在should时被处理了在这里提高效率不再判断)
        text = [text substringToIndex:self.maxLimitNums];
        !self.reachMaxLimitNums ? : self.reachMaxLimitNums(self.maxLimitNums);
    }
    [self setText:text];
    !self.textDidChange ? : self.textDidChange(self, NO);
}

#pragma mark - private method

- (BOOL)returnKeyDidClickWithNewlineRang:(NSRange)newlineRange {
    if (!self.returnKeyDidClick) return YES;
    NSString *content = [self.text stringByReplacingCharactersInRange:newlineRange withString:@""];
    return self.returnKeyDidClick(self, content);
}

#pragma mark - control method

- (void)eventEditingChanged:(UITextField *)textField {
    UITextRange *selectedRange = [textField markedTextRange];
    // 获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        !self.textDidChange ? : self.textDidChange(self, YES);
        return;
    }
    
    if (self.maxLimitNums <= 0) {
        !self.textDidChange ? : self.textDidChange(self, NO);
        return;
    }
    
    NSString *nsTextContent = textField.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > self.maxLimitNums) {
        // 截取到最大位置的字符(由于超出截部分在should时被处理了在这里提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:self.maxLimitNums];
        [textField setText:s];
        !self.reachMaxLimitNums ? : self.reachMaxLimitNums(self.maxLimitNums);
    }
    
    !self.textDidChange ? : self.textDidChange(self, NO);
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!self.returnKeyDidClick) return YES;
    return self.returnKeyDidClick(self, textField.text);
}
 
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    !self.textDidBeginEditing ? : self.textDidBeginEditing(self);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    !self.textDidEndEditing ? : self.textDidEndEditing(self);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 监听键盘点击右下角按钮是不是换行符
    if ([string isEqualToString:@"\n"]) {
        return [self returnKeyDidClickWithNewlineRang:range];
    }
    
    if (self.maxLimitNums <= 0) return YES;
    
    UITextRange *selectedRange = [textField markedTextRange];
    // 获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        // 起始位置有没有超过限制字数
        if (offsetRange.location < self.maxLimitNums) {
            return YES;
        } else {
            !self.reachMaxLimitNums ? : self.reachMaxLimitNums(self.maxLimitNums);
            !self.textDidChange ? : self.textDidChange(self, NO);
            return NO;
        }
    }
    
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // 当前字数与限制字数的差值
    NSInteger caninputlen = self.maxLimitNums - comcatstr.length;
    
    if (caninputlen >= 0) {
        return YES;
    } else {
        // 当联想的字数加上当前字数超过限制时，进行处理
        NSInteger len = string.length + caninputlen;
        // 防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0, MAX(len, 0)};
        if (rg.length > 0) {
            NSString *s = @"";
            // 判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [string canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [string substringWithRange:rg]; // 因为是ascii码直接取就可以了不会错
            } else {
                __block NSInteger idx = 0;
                __block NSString *trimString = @""; // 截取出的字串
                // 使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                    if (idx >= rg.length) {
                        *stop = YES; // 取出所需要就break，提高效率
                        return ;
                    }
                    trimString = [trimString stringByAppendingString:substring];
                    idx++;
                }];
                s = trimString;
            }
            // rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        !self.reachMaxLimitNums ? : self.reachMaxLimitNums(self.maxLimitNums);
        !self.textDidChange ? : self.textDidChange(self, NO);
        return NO;
    }
}

@end
