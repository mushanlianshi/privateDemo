//
//  LBNHNoNetworkEmptyView.h
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBNHNoNetworkEmptyView;

typedef void(^LBNHNoNetworkEmptyViewDidClickRetryHandler)(LBNHNoNetworkEmptyView *view);

/**
 显示没网络的view   点击中间马上回来按钮触发loadData
 */
@interface LBNHNoNetworkEmptyView : UIView

@property (nonatomic, copy)LBNHNoNetworkEmptyViewDidClickRetryHandler retryHandle;


-(void)showInSuperview:(UIView *)superView;


-(void)dismiss;

@end
