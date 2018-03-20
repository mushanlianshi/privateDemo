//
//  UIView+LBController.m
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "UIView+LBController.h"

@implementation UIView (LBController)

-(UIViewController *)viewController{
    UIViewController *viewController = nil;
    //1.获取下一个响应者
    UIResponder *nextResponder = [self nextResponder];
    //2.如果存在  继续寻找 直到找到Controller
    while (nextResponder) {
        //3.判断响应者是不是controller
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)nextResponder;
            //4.跳出循环
            break;
        }
        //5.响应者不是controller  继续下一个响应者
        nextResponder = [nextResponder nextResponder];
    }
    return viewController;
}

@end
