//
//  LBBaseViewController.h
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LBLoading.h"

/**
 跟viewController  提供一些常用的方法
 */
@interface LBBaseViewController : UIViewController

/**
 pop到上一层
 */
-(void)pop;

/**
 pop到跟VC
 */
-(void)popToRootVc;

- (void)popToVc:(UIViewController *)vc;

- (void)pushToVc:(UIViewController *)vc;

-(void)dismiss;

-(void)dismissWithCompletion:(dispatch_block_t)completion;



- (void)removeChildVc:(UIViewController *)childVc;

- (void)addChildVc:(UIViewController *)childVc;

/** 加载中*/
- (void)showLoadingAnimation;

/** 停止加载*/
- (void)hideLoadingAnimation;


/** 显示没网络提示 */
- (void)showNoNetworkEmptyView;


/** 停止显示没网络提示*/
- (void)hideNoNetworkEmptyView;

/** 请求数据，交给子类去实现*/
- (void)loadData;

@property (nonatomic, assign) BOOL isNetworkReachable;

@end
