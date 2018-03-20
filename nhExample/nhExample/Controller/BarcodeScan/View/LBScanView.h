//
//  LBScanView.h
//  nhExample
//
//  Created by liubin on 17/5/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBScanViewStyle;

/**
 * 扫描二维码的view的试图
 */
@interface LBScanView : UIView

/**
 * 初始化方法
 @param frame 位置frame
 @param scanStyle 扫描的类型
 @param readyString 准备时还没开始扫描时 的提示文字
 */
-(instancetype)initWithFrame:(CGRect)frame scanStyle:(LBScanViewStyle *)scanStyle readyString:(NSString *)readyString;




/**
 * 停止准备
 */
-(void)stopReadyDevice;


/**
 * 开始扫描
 */
-(void)startScaning;


/**
 * 结束扫描
 */
-(void)stopScaning;


/**
 闪光灯是否可用
 */
-(BOOL)isFlashAvailbe;


/**
 设置闪光灯

 @param isOn 上光灯的状态
 */
-(void)setFlashState:(BOOL)isOn;

@end
