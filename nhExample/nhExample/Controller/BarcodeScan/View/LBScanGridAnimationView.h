//
//  LBScanGridAnimationView.h
//  nhExample
//
//  Created by liubin on 17/5/4.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 网格动画的view 多加一层view是为了imageview不显示出这个view边界的
 */
@interface LBScanGridAnimationView : UIView

-(instancetype)initScanAnimationFrame:(CGRect)frame superView:(UIView *)superView image:(UIImage *)image;

/**
 * 开始扫描动画的方法
 @param frame 扫描的区域
 @param superView 父控件
 @param image 扫描的图片
 */
-(void)startScanAnimationFrame:(CGRect)frame superView:(UIView *)superView image:(UIImage *)image;


/** 开始扫描动画 */
-(void)startScanAnimating;

/**
 * 停止扫描的方法
 */
-(void)stopScanAnimating;

@end
