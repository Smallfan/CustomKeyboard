//
//  UINumTextField.m
//  Smallfan
//
//  Created by Smallfan on 17-2-15.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "UINumTextField.h"

#define KkeyboardHeight     [UIScreen mainScreen].bounds.size.width > 320 ? 266 : 232
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width


@implementation UINumTextField {
    NSUInteger     num;
    BOOL    isAddSpaceString;
    NSString    *textString;
}



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initKeyboard];

    }
    return self;
}

-(void)initKeyboard {
    _numKey = [[SFNumericKeyboard alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KkeyboardHeight)];
    num = 0;
}

- (void)setDefinekeyBoardType:(KeyBoardType)KeyBoardType isCertificate:(BOOL)isCertificate {
    
    if (KeyBoardType == KeyBoardNumberType) {
        _numKey = [[SFNumericKeyboard alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KkeyboardHeight) isCertificate:isCertificate];
        self.inputView = _numKey;
        if (!self.numKey.delegate) {
            self.numKey.delegate = self;
        }
        isNumKeyBoard = YES;
        [_numKey layoutSubviews];
    } else {
        self.inputView = _englishKey;
        if (!self.englishKey.delegate) {
            self.englishKey.delegate = self;
        }
        isNumKeyBoard = NO;
    }
    
}

- (void)setDefinekeyBoardType:(KeyBoardType)KeyBoardType isDecimal:(BOOL)isDecimal {
    
    if (KeyBoardType == KeyBoardNumberType) {
        _numKey = [[SFNumericKeyboard alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KkeyboardHeight) isDecimal:isDecimal];
        self.inputView = _numKey;
        if (!self.numKey.delegate) {
            self.numKey.delegate = self;
        }
        isNumKeyBoard = YES;
        [_numKey layoutSubviews];
    } else {
        self.inputView = _englishKey;
        if (!self.englishKey.delegate) {
            self.englishKey.delegate = self;
        }
        isNumKeyBoard = NO;
    }
    
}

//英文键盘delegate  ----------------------------------------------
-(void)returnString:(NSString *)str {
    num = self.text.length;
    textString = self.text;
    UITextPosition* beginning = self.beginningOfDocument;
    NSInteger location = [self offsetFromPosition:beginning toPosition:self.selectedTextRange.start];
    NSInteger length = [self offsetFromPosition:self.selectedTextRange.start toPosition:self.selectedTextRange.end];
    if (str.length > 0) {

        if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            if (![self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(location, length) replacementString:str]) {
                return;
            }
        }            //            self.text = [self.text stringByAppendingString:str];
        NSMutableString *String1 = [[NSMutableString alloc] initWithString:self.text];
        if (length > 0) {
            //用于选择多个字符时 被替换
            [String1 replaceCharactersInRange:NSMakeRange(location, length) withString:str];
        }else {
            [String1 insertString:str atIndex:location];
        }
        if (  isUppercaseString==YES) {

            self.text = [String1 uppercaseString];

        }else{
            self.text = String1;
        }
        int count = 0;
        BOOL isSpace = NO;
        if (isAddSpaceString) {
            self.text = [self addSpacePartitionOffString:self.text];
            for (int i = 0; i < self.text.length; i++) {
                NSString *hh = [self.text substringWithRange:NSMakeRange(i, 1)];
                if ([hh isEqualToString:@" "]) {
                    count++;
                }
            }
        }

        //6.0版本需要重新初始化beginning，不然会为nil
        UITextPosition* beginn = self.beginningOfDocument;
        UITextPosition *newPosition;
        NSUInteger currenPosition = location+self.text.length-num;

        if (length > 0) {
            //批量插入时，光标移动的位置
            newPosition = [self positionFromPosition:beginn offset:location+str.length];
        }else {

            if (num > location && count > 0 ) {
                isSpace = [[textString substringWithRange:NSMakeRange(location, 1)] isEqualToString:@" "];
                if (location == 4 || location == 9 || location == 14) {
                    if (isSpace) {
                        newPosition = [self positionFromPosition:beginn offset:currenPosition+1];
                    }else
                        newPosition = [self positionFromPosition:beginn offset:currenPosition];
                }else {
                    if (self.text.length-num > 1) {
                        newPosition = [self positionFromPosition:beginn offset:currenPosition-1];
                    }else
                        newPosition = [self positionFromPosition:beginn offset:currenPosition];
                }
            }else
                newPosition = [self positionFromPosition:beginn offset:currenPosition];
        }
        UITextRange *textRange=[self textRangeFromPosition:newPosition toPosition:newPosition];
        self.selectedTextRange=textRange;
    }
}

-(void)changeKeyboard {
    [self changeKeyboardType];
}

-(void)englishKeyboardBackspace {
    num = self.text.length;
    UITextPosition* beginning = self.beginningOfDocument;
    NSInteger location = [self offsetFromPosition:beginning toPosition:self.selectedTextRange.start];
    NSInteger length = [self offsetFromPosition:self.selectedTextRange.start toPosition:self.selectedTextRange.end];

    if (location > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            if (![self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(location, length) replacementString:@""]) {
                return;
            }
        }
        if (self.text.length != 0)
        {
            //截取到光标包含的字符串string1  然后从self.text中删去
            NSMutableString *String1 = [[NSMutableString alloc] initWithString:self.text];
            if (length == 0) {
                //一个一个字符删除时，光标要向左移动1格，长度length由0+1
                [String1 replaceCharactersInRange:NSMakeRange(location-1, length+1) withString:@""];
            }else{
                //批量删除
                [String1 replaceCharactersInRange:NSMakeRange(location, length) withString:@""];
            }
            //        self.text = [self.text substringToIndex:self.text.length -1];
            self.text = String1;

            //6.0版本需要重新初始化beginning，不然会为nil
            UITextPosition* beginn = self.beginningOfDocument;
            UITextPosition *newPosition;
            if (length > 0) {
                newPosition = [self positionFromPosition:beginn offset:location];
            }else {
                newPosition = [self positionFromPosition:beginn offset:location+self.text.length-num];
            }
            UITextRange *textRange=[self textRangeFromPosition:newPosition toPosition:newPosition];
            self.selectedTextRange=textRange;
        }

    }

}
-(void)returnKeyBoard {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [self.delegate textFieldShouldReturn:self];
        return;
    }
    [self resignFirstResponder];
}
//--------------------------------------------------------------------------------------------

-(void)changeKeyboardType {
    if ([self isFirstResponder]) {

        [self resignFirstResponder];
        if (isNumKeyBoard) {
            self.inputView = _englishKey;
            _englishKey.delegate = self;
            isNumKeyBoard = NO;
        } else {
            self.inputView = _numKey;
            _numKey.delegate = self;
            isNumKeyBoard = YES;
        }
        [self becomeFirstResponder];

    }

}

//数字键盘delegate
#pragma mark -- numberKeyBoardDelegate
-(void)numberKeyboardBackspace {
    num = self.text.length;
    UITextPosition* beginning = self.beginningOfDocument;
    NSInteger location = [self offsetFromPosition:beginning toPosition:self.selectedTextRange.start];
    NSInteger length = [self offsetFromPosition:self.selectedTextRange.start toPosition:self.selectedTextRange.end];

    if (location > 0) {
        if (self.text.length != 0)
        {
            //截取到光标包含的字符串string1  然后从self.text中删去
            NSMutableString *String1 = [[NSMutableString alloc] initWithString:self.text];
            if (length == 0) {
                //一个一个字符删除时，光标要向左移动1格，长度length由0+1
                [String1 replaceCharactersInRange:NSMakeRange(location-1, length+1) withString:@""];
            }else{
                //批量删除
                [String1 replaceCharactersInRange:NSMakeRange(location, length) withString:@""];
            }
            //        self.text = [self.text substringToIndex:self.text.length -1];
            self.text = String1;

            //6.0版本需要重新初始化beginning，不然会为nil
            UITextPosition* beginn = self.beginningOfDocument;
            UITextPosition *newPosition;
            if (length > 0) {
                newPosition = [self positionFromPosition:beginn offset:location];
            }else {
                newPosition = [self positionFromPosition:beginn offset:location+self.text.length-num];
            }
            UITextRange *textRange=[self textRangeFromPosition:newPosition toPosition:newPosition];
            self.selectedTextRange=textRange;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            if (![self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(location, length) replacementString:@""]) {
                return;
            }
        }
    }
}

-(void)numberKeyboardInput:(NSString*)numberStr {
    num = self.text.length;
    textString = self.text;
    UITextPosition* beginning = self.beginningOfDocument;
    NSInteger location = [self offsetFromPosition:beginning toPosition:self.selectedTextRange.start];
    NSInteger length = [self offsetFromPosition:self.selectedTextRange.start toPosition:self.selectedTextRange.end];
    if (numberStr.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            if (![self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(location, length) replacementString:numberStr]) {
                return;
            }
        }
        NSMutableString *String1 = [[NSMutableString alloc] initWithString:self.text];
        if (length > 0) {
            [String1 replaceCharactersInRange:NSMakeRange(location, length) withString:numberStr];
        }else {
            [String1 insertString:numberStr atIndex:location];
        }
        self.text = String1;


        int count = 0;
        BOOL isSpace = NO;
        if (isAddSpaceString) {
            self.text = [self addSpacePartitionOffString:self.text];
            for (int i = 0; i < self.text.length; i++) {
                NSString *hh = [self.text substringWithRange:NSMakeRange(i, 1)];
                if ([hh isEqualToString:@" "]) {
                    count++;
                }
            }
        }

        //6.0版本需要重新初始化beginning，不然会为nil
        UITextPosition* beginn = self.beginningOfDocument;
        UITextPosition *newPosition;
        NSUInteger currenPosition = location+self.text.length-num;

        if (length > 0) {
            //批量插入时，光标移动的位置
            newPosition = [self positionFromPosition:beginn offset:location+numberStr.length];
        } else {

            if (num > location && count > 0 ) {
                isSpace = [[textString substringWithRange:NSMakeRange(location, 1)] isEqualToString:@" "];
                if (location == 4 || location == 9 || location == 14) {
                    if (isSpace) {
                        newPosition = [self positionFromPosition:beginn offset:currenPosition+1];
                    }else
                        newPosition = [self positionFromPosition:beginn offset:currenPosition];
                }else {
                    if (self.text.length-num > 1) {
                        newPosition = [self positionFromPosition:beginn offset:currenPosition-1];
                    }else
                        newPosition = [self positionFromPosition:beginn offset:currenPosition];
                }
            }else
                newPosition = [self positionFromPosition:beginn offset:currenPosition];
        }
        UITextRange *textRange=[self textRangeFromPosition:newPosition toPosition:newPosition];
        self.selectedTextRange=textRange;
    }
}

-(void)numberReturnKeyBoard {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [self.delegate textFieldShouldReturn:self];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (_delegate &&  [_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_delegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_delegate &&  [_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_delegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (_delegate &&  [_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_delegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_delegate &&  [_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_delegate &&  [_delegate respondsToSelector:@selector(textField: shouldChangeCharactersInRange: replacementString:)]) {
        return [_delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;

}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (_delegate &&  [_delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [_delegate textFieldShouldClear:textField];
    }
    return YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_delegate &&  [_delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [_delegate textFieldShouldReturn:textField];
    }
    return YES;

}


-(void)setCustomerDelegate:(id<UITextFieldDelegate>)delegate {
    _delegate =delegate;

}
//add by tango 2014-06-08
-(void)setUppercaseString:(BOOL) uppercaseString {
    if (uppercaseString==YES) {
        isUppercaseString=YES;
    }else
    {
        isUppercaseString=NO;
    }
}


-(void)setAddSpaceString:(BOOL) isAddSpace {
    isAddSpaceString = isAddSpace;
}

-(NSString*)addSpacePartitionOffString:(NSString*)textStr {
    textStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *str = [[NSMutableString alloc] initWithString:textStr];
    NSUInteger ld = textStr.length;
    if (ld >= 13) {
        [str insertString:@" " atIndex:4];
        [str insertString:@" " atIndex:9];
        [str insertString:@" " atIndex:14];
    }else if (ld > 8) {
        [str insertString:@" " atIndex:4];
        [str insertString:@" " atIndex:9];
    }else if (ld > 3){
        [str insertString:@" " atIndex:4];

    }
    return str;
}

@end
