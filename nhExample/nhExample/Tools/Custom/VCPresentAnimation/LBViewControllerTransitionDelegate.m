//
//  LBViewControllerTransitionDelegate.m
//  nhExample
//
//  Created by baletu on 2017/8/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBViewControllerTransitionDelegate.h"

@implementation LBViewControllerTransitionDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return  nil;
}


@end
