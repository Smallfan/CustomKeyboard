//
//  SFEnglishKeyboard.h
//  Smallfan
//
//  Created by Smallfan on 17-2-15.
//  Copyright © 2017年 Tencent. All rights reserved.
//
#import <UIKit/UIKit.h>



@protocol SFEnglishKeyboardDelegate <NSObject>

-(void)returnString:(NSString*)str;
//-(void)shouldChangeString:(NSString*)changeStr frame:(CGRect)frame;
-(void)changeKeyboard;
-(void)englishKeyboardBackspace;
-(void)returnKeyBoard;
@end

@interface SFEnglishKeyboard : UIView

+ (SFEnglishKeyboard *)shareEnglishKeyboard;
@property (nonatomic,weak) id<SFEnglishKeyboardDelegate> delegate;
@end
