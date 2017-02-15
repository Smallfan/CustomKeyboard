//
//  SFNumericKeyboard.h
//  Smallfan
//
//  Created by Smallfan on 17-2-15.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SFNumericKeyboardDelegate <NSObject>

- (void) numberKeyboardInput:(NSString*) number;
- (void) numberKeyboardBackspace;
- (void) changeKeyboardType;
- (void) numberReturnKeyBoard;

@end
@interface SFNumericKeyboard : UIView
{
//    NSArray *arrLetter;
}
+ (SFNumericKeyboard *)shareNumKeyboard;
@property (nonatomic,weak) id<SFNumericKeyboardDelegate> delegate;
- (id)initWithFrame:(CGRect)frame isCertificate:(BOOL) isCertificate;
- (id)initWithFrame:(CGRect)frame isDecimal:(BOOL)isDecimal;
@end
