//
//  MBProgressHUD+LBAddtion.h
//  nhExample
//
//  Created by liubin on 17/3/23.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LBAddtion)

/** 显示加载框 */
+(void)showLoading;
+(void)showLoading:(UIView *)superView;
+(void)showLoading:(NSString *)message superView:(UIView *)superView;


/** 隐藏加载框 */
+(void)hidAllHudsInSuperView:(UIView *)superView;

/** 显示一个提示的内容 */
+(void)showHintText:(NSString *)text superView:(UIView *)superView;

/** 显示一个带图片的提示内容 */
+(void)showHintText:(NSString *)text icon:(UIImage *)image superView:(UIView *)superView;
@end
