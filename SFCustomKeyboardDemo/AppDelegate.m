//
//  AppDelegate.m
//  SFCustomKeyboardDemo
//
//  Created by Smallfan on 2017/2/15.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController *rootVC = [[ViewController alloc] init];
    self.window.rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
