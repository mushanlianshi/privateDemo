//
//  LBViewUtils.h
//  nhExample
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBViewUtils : NSObject

/**
 * 给scrollView添加下拉刷新功能
 */
+(void)addPullRefreshToScrollView:(UIScrollView *)scrollView pullRefreshHandler:(dispatch_block_t)pullRefreshHnadler;

/**
 * 给scrollView添加上啦加载功能
 */
+(void)addPushLoadMoreToScrollView:(UIScrollView *)scrollView loadMoreHandler:(dispatch_block_t)loadMoreHandler;


/**
 * 停止下拉刷新
 */
+(void)endPullRefreshScrollView:(UIScrollView *)scrollView;

/**
 * 停止上啦加载
 */
+(void)endPushLoadMoreScrollView:(UIScrollView *)scrollView;


/*
 隐藏下拉刷新控件
 */
+(void)hiddenRefreshHeaderScrollView:(UIScrollView *)scrollView;


/**
 隐藏上啦加载控件
 */
+(void)hiddenLoadMoreFooterScrollView:(UIScrollView *)scrollView;


/**
 提示没有更多数据加载
 */
+(void)noticeNoMoreDataForScrollView:(UIScrollView *)scrollView;


/**
 判断头部是否正在刷新
 */
+(BOOL)isHeaderRefreshScrollView:(UIScrollView *)scrollView;

/**
 判断底部是否正在加载更多
 */
+(BOOL)isFooterLoadMoreScrollView:(UIScrollView *)scrollView;

/**
 封装了类似 微博刷新的状态  显示刷新状态的动画
 @param info 要显示的信息
 @param superView 显示的父控件
 @param belowView 显示在哪个控件下  要确保别被遮盖了
 */
+(void)showRefreshInfo:(NSString *)info superView:(UIView *)superView belowView:(UIView *)belowView;

/** 获取当前正在显示的控制器 */
+ (UIViewController *)getCurrentVC;
@end
