//
//  LBCustomNaviBar.h
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 自定义naviBar的view
 */
@interface LBCustomNaviBar : UIView

-(instancetype)initNaviBarLeftImage:(UIImage *)leftImage leftBlock:(dispatch_block_t)leftBlock title:(NSString *)title rightImage:(UIImage *)rightImage rightBlock:(dispatch_block_t)rightBlock;

/**
 * 初始化一个自己定义的navibar
 @param tintColor tintColor 字体的颜色
 @param backgroundColor 背景色
 @param leftImage 左边的图片
 @param leftBlock 左边的block
 @param title 标题
 @param rightImage 右边的图片
 @param rightBlock 右边的block
 */
-(instancetype)initNaviBarTintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor leftImage:(UIImage *)leftImage leftBlock:(dispatch_block_t)leftBlock title:(NSString *)title rightImage:(UIImage *)rightImage rightBlock:(dispatch_block_t)rightBlock;

-(instancetype)initNaviBarLeftString:(NSString *)LeftString leftBlock:(dispatch_block_t)leftBlock title:(NSString *)title rightString:(NSString *)rightString rightBlock:(dispatch_block_t)rightBlock;
-(instancetype)initNaviBarTintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor LeftString:(NSString *)LeftString leftBlock:(dispatch_block_t)leftBlock title:(NSString *)title rightString:(NSString *)rightString rightBlock:(dispatch_block_t)rightBlock;


@property (nonatomic, strong) UIFont *titleFont;

@end
