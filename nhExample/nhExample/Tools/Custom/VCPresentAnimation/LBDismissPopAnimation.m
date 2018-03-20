//
//  LBDismissPopAnimation.m
//  nhExample
//
//  Created by liubin on 17/5/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBDismissPopAnimation.h"

static NSTimeInterval kDurationTime = 0.8;

@implementation LBDismissPopAnimation

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return kDurationTime;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //1.获取所需要的controllers  fromVC 主动要dismiss的controller  就是即将不要显示的
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //  就是要dismiss显示的controller
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //2.初始化fromVC刚开始显示的位置
    CGRect initFrame = [transitionContext finalFrameForViewController:fromVC];
    //计算不要显示的位置
//    CGRect finalFrame =CGRectOffset(initFrame, kScreenWidth, 0);
    
    //3.把他们加入到contrainerView容器中
    UIView *contrainerView = [transitionContext containerView];
    [contrainerView addSubview:toVC.view];
    [contrainerView sendSubviewToBack:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        fromVC.view.frame = finalFrame;
        fromVC.view.frame = CGRectMake(kScreenWidth, kScreenHeight, 0, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}

@end
