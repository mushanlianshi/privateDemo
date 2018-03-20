//
//  UIButton+LBInit.h
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 快速创建button的方法
 */
@interface UIButton (LBInit)

-(instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target selector:(SEL)selector;

-(instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)font backGroundColor:(UIColor *)backGroundColor target:(id)target selector:(SEL)selector;

/** 默认设置normal状态 */
-(void)setTitle:(NSString *)title;

/** 默认设置normal状态 */
-(void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor;

-(void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor state:(UIControlState)state;
@end
