//
//  LBPushControllerAnimation.m
//  nhExample
//
//  Created by liubin on 17/5/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBPresentPushAnimation.h"

static NSTimeInterval kPushTime = 0.8f;

@implementation LBPresentPushAnimation

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return kPushTime;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //1.获取要present展现的controller
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //2.初始化toVC的frame  toVC是要present显示的controller
    //获取要展现的vc的最终的frame
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    //设置要展示的vc的位置
    toVC.view.frame = CGRectOffset(finalFrame, kScreenWidth, 0);
    
    //3.把toVC的view添加到动画容器containerView中
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    
    
    //4.设置动画 获取代理设置的时间
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0.f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        //最终的位置
        toVC.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        //5. 一定要告诉context 我们动画completed
        [transitionContext completeTransition:YES];
    }];
    
}

@end
