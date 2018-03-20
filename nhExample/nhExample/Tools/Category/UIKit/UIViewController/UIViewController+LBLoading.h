//
//  UIViewController+LBLoading.h
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 封装了显示loading加载框的分类
 */
@interface UIViewController (LBLoading)

/** 获取loadingview */
-(UIView *)loadingView;

/** 显示loadingView */
-(void)showLoadingViewWithFrame:(CGRect)frame;

/**
 显示loadingView
 */
-(void)showLoadingView;

/**
 隐藏显示的loadingView
 */
-(void)hiddenLoadingView;
@end
