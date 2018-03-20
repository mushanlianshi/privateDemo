//
//  AppDelegate.h
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, copy) NSMutableArray *testArray;


/** 设置进入主界面的方法 */
-(void)setRootHomeViewController;

@end

