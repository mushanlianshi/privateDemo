//
//  LBCustomADView.h
//  nhExample
//
//  Created by liubin on 17/4/18.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 自定义启动加载广告的view
 */
@interface LBCustomADView : UIView

-(void)showADViewImage:(UIImage *)image superView:(UIView *)superView limitTime:(NSTimeInterval)limitTime clickBlock:(void(^)())clickBlock;

@end
