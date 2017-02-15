//
//  UINumTextField.h
//  Smallfan
//
//  Created by Smallfan on 17-2-15.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFEnglishKeyboard.h"
#import "SFNumericKeyboard.h"

enum KeyBoardType {
    KeyBoardNumberType = 0,
    KeyBoardEnglishType = 1,
};
typedef int KeyBoardType;

@interface UINumTextField : UITextField<UITextFieldDelegate,SFEnglishKeyboardDelegate,SFNumericKeyboardDelegate>
{
    __weak NSObject <UITextFieldDelegate>* _delegate;
    BOOL isNumKeyBoard;
    BOOL isUppercaseString;
}

@property (nonatomic, strong) SFEnglishKeyboard *englishKey;
@property (nonatomic, strong) SFNumericKeyboard *numKey;

- (void)setDefinekeyBoardType:(KeyBoardType)KeyBoardType isCertificate:(BOOL)isCertificate;
- (void)setDefinekeyBoardType:(KeyBoardType)KeyBoardType isDecimal:(BOOL)isDecimal;
- (void)setUppercaseString:(BOOL) uppercaseString;
-(void)setAddSpaceString:(BOOL) isAddSpace;
@end
UIKIT_EXTERN NSString *const UITextFieldTextDidChangeNotification;
