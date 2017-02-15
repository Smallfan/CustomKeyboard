//
//  ViewController.m
//  SFCustomKeyboardDemo
//
//  Created by Smallfan on 2017/2/15.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "UINumTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UINumTextField *textField = [[UINumTextField alloc] initWithFrame:CGRectMake(30,100,250,30)];
    textField.backgroundColor = [UIColor whiteColor];
    
    [textField setDefinekeyBoardType:KeyBoardNumberType isDecimal:YES];
    [textField becomeFirstResponder];
    
    [self.view addSubview:textField];
}


@end
