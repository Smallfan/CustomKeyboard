//
//  SFNumericKeyboard.m
//  Smallfan
//
//  Created by Smallfan on 17-2-15.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "SFNumericKeyboard.h"

#define kLineWidth 0.5
#define kNumFont [UIFont systemFontOfSize:27]
#define KsizeX  kScreenWidth/3
#define Kheight 216

#define kScreenWidth                [UIScreen mainScreen].bounds.size.width
#define Ksystemverion_floatvlue     [[[UIDevice currentDevice] systemVersion] floatValue]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SFNumericKeyboard () {
 
    BOOL _isCertificate;
    BOOL _isDecimal;
    
}
@end

@implementation SFNumericKeyboard



+ (SFNumericKeyboard *)shareNumKeyboard
{
    static SFNumericKeyboard * numKeyboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(numKeyboard == nil)
            numKeyboard = [[SFNumericKeyboard alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, Kheight)];
        
    });
    return numKeyboard;
}
- (id)initWithFrame:(CGRect)frame isCertificate:(BOOL)isCertificate {
    _isCertificate = isCertificate;
    
    self = [self initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, kScreenWidth, Kheight);
        if (Ksystemverion_floatvlue < 7.f) {
            self.backgroundColor = [UIColor whiteColor];
        }
        //初始化12个btn按钮
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                button.backgroundColor  = [UIColor clearColor];
                [self addSubview:button];
            }
        }
        
        UIColor *color = UIColorFromRGB(0xC3C3C3);
        
        //3条竖线
        for (int i=0; i<2; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(KsizeX*(i+1), 0, kLineWidth, Kheight)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
        //4条横线
        for (int i=0; i<4; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (Kheight/4)*i, kScreenWidth, kLineWidth)];
            if (i == 3) {
                line.frame = CGRectMake(line.frame.origin.x, line.frame.origin.y, 3*KsizeX, kLineWidth);
            }
            line.backgroundColor = color;
            [self addSubview:line];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame isDecimal:(BOOL)isDecimal {
    _isDecimal = isDecimal;
    
    self = [self initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, kScreenWidth, Kheight);
        if (Ksystemverion_floatvlue < 7.f) {
            self.backgroundColor = [UIColor whiteColor];
        }
        //初始化12个btn按钮
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                button.backgroundColor  = [UIColor clearColor];
                [self addSubview:button];
            }
        }
        
        UIColor *color = UIColorFromRGB(0xC3C3C3);
        
        //3条竖线
        for (int i=0; i<2; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(KsizeX*(i+1), 0, kLineWidth, Kheight)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
        //4条横线
        for (int i=0; i<4; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (Kheight/4)*i, kScreenWidth, kLineWidth)];
            if (i == 3) {
                line.frame = CGRectMake(line.frame.origin.x, line.frame.origin.y, 3*KsizeX, kLineWidth);
            }
            line.backgroundColor = color;
            [self addSubview:line];
        }
    }
    return self;
}

//初始化各个按键
-(UIButton *)creatButtonWithX:(NSInteger)x Y:(NSInteger)y
{
    CGFloat frameY = (Kheight/4)*x;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(y*KsizeX, frameY, KsizeX, Kheight/4)];
    
    NSInteger num = y+3*x+1;
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIColor *colorNormal;
    if (num < 10 || num == 11 || (num == 10 && (_isCertificate || _isDecimal))) {
        colorNormal = [UIColor whiteColor];
    } else {
        colorNormal = UIColorFromRGB(0xE3E3E3);
    }
    [button setBackgroundColor:colorNormal];
    CGSize imageSize = CGSizeMake(KsizeX, Kheight/4);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorNormal set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *normalColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setBackgroundImage:normalColorImg forState:UIControlStateNormal];
    
    
    UIColor *colorHightlighted;
    if (num != 10) {
        colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];
    } else {
        colorHightlighted = UIColorFromRGB(0xE3E3E3);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
    
    
    
    if (num < 10) {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, (Kheight/4-28)/2, KsizeX, 28)];
        labelNum.text = [NSString stringWithFormat:@"%ld",(long)num];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = kNumFont;
        labelNum.backgroundColor = [UIColor clearColor];
        [button addSubview:labelNum];
    } else if (num == 10) {
        if (_isCertificate) {
            UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, (Kheight/4-28)/2, KsizeX, 28)];
            labelNum.text = @"X";
            labelNum.textColor = [UIColor blackColor];
            labelNum.textAlignment = NSTextAlignmentCenter;
            labelNum.font = kNumFont;
            labelNum.backgroundColor = [UIColor clearColor];
            [button addSubview:labelNum];
        } else if (_isDecimal){
            UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, (Kheight/4-28)/2, KsizeX, 28)];
            labelNum.text = @".";
            labelNum.textColor = [UIColor blackColor];
            labelNum.textAlignment = NSTextAlignmentCenter;
            labelNum.font = kNumFont;
            labelNum.backgroundColor = [UIColor clearColor];
            [button addSubview:labelNum];
        } else {
            button.userInteractionEnabled = NO;
        }
        
    } else if (num == 11) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, KsizeX, 28)];
        label.text = @"0";
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
        
    } else if (num == 12) {
//        [button setImage:[FSPayImageUtil imageNamedFromVenders:@"customKeyboard_delete" subFolderPath:@"CustomKeyboard"] forState:UIControlStateNormal];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, KsizeX, 28)];
        label.text = @"Delete";
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        [button addSubview:label];
    } else {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(42, 19, 22, 17)];
        arrow.userInteractionEnabled = YES;
        [button addSubview:arrow];
    }
    return button;
}

-(void)clickButton:(UIButton *)sender
{
    
    if(sender.tag == 12) {
        [self.delegate numberKeyboardBackspace];
    } else {
        NSInteger num = sender.tag;
        if (sender.tag == 11) {
            num = 0;
        }
        if (sender.tag == 10) {
            if (_isCertificate) {
                [self.delegate numberKeyboardInput:@"X"];
            } else if (_isDecimal) {
                [self.delegate numberKeyboardInput:@"."];
            }
            return;
        }
        [self.delegate numberKeyboardInput:[NSString stringWithFormat:@"%ld",(long)num]];
    }
}


@end
