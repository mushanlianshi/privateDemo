//
//  LBViewControllerTransitionDelegate.h
//  nhExample
//
//  Created by baletu on 2017/8/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 自定义转场动画代理的方法
 */
@interface LBViewControllerTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate>

/** 添加pan手势  不需要交互的可以不用 */
@property (nonatomic,strong) UIPanGestureRecognizer *transitionGesture;

@end
