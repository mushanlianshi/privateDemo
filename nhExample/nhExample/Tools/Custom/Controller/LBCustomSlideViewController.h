//
//  LBCustomSlideViewController.h
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBCustomSlideViewController;


/**
 * 处理事件回调的协议
 */
@protocol LBCustomSlideViewControllerDelegate <NSObject>


/**
 * scrollView滚动到index的代理
 */
-(void)slideViewController:(LBCustomSlideViewController *)slideController slideIndex:(NSInteger) slideIndex;

@end

/**
 * 数据源协议
 */
@protocol LBCustomSlideViewControllerDataSource <NSObject>


/** 索引对应的Controller */
-(UIViewController *)slideViewController:(LBCustomSlideViewController *)slideController viewControllerAtIndex:(NSInteger)index;

/** 总的子controller的个数 */
-(NSInteger)numbersOfChildViewControllerInSlideController:(LBCustomSlideViewController *)slideController;

@end

/**
 * 自定义的scrollView里放viewController 的控制器
 */
@interface LBCustomSlideViewController : UIViewController


@property (nonatomic, weak) id<LBCustomSlideViewControllerDataSource> dataSource;

@property (nonatomic, weak) id<LBCustomSlideViewControllerDelegate> delegate;
/**
 * 设置选中显示的Controller
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 * 重新加载数据
 */
-(void)reloadSlideVC;

@end
