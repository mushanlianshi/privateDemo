//
//  MBProgressHUD+LBAddtion.m
//  nhExample
//
//  Created by liubin on 17/3/23.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "MBProgressHUD+LBAddtion.h"

@implementation MBProgressHUD (LBAddtion)

+(void)showLoading:(UIView *)superView{
    [self showLoading:nil superView:superView];
}

+(void)showLoading:(NSString *)message superView:(UIView *)superView{
    //没有父控件就用window
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    if (!message || message.length == 0){
        message = @"Loading";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    //设置hud的信息
    hud.label.text = message;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0.41f green:0.46f blue:0.50f alpha:0.600f];;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:15];
}


/** 显示一个提示的内容 */
+(void)showHintText:(NSString *)text superView:(UIView *)superView{
    [self showHintText:text icon:nil superView:superView];
}

/** 显示一个带图片的提示内容 */
+(void)showHintText:(NSString *)text icon:(UIImage *)image superView:(UIView *)superView{
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    hud.label.text = text;
//    hud.label.textColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0.41f green:0.46f blue:0.50f alpha:0.600f];;
    [hud hideAnimated:YES afterDelay:0.9];
    
}

+(void)hidAllHudsInSuperView:(UIView *)superView{
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    [MBProgressHUD hideHUDForView:superView animated:YES];
}

@end
