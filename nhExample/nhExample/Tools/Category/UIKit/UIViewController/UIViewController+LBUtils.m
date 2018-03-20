//
//  UIViewController+LBUtils.m
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "UIViewController+LBUtils.h"

@implementation UIViewController (LBUtils)

-(BOOL)isBePushed{
    //1.获取navigationController的子viewControllers
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        //如果栈顶那个controller是自己  那就是push的
        if ([viewControllers objectAtIndex:viewControllers.count-1] == self) {
            return YES;
        }
    }
    return NO;
}

@end
