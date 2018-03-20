//
//  LBAnimatingUtils.h
//  testPush
//
//  Created by baletu on 2017/7/19.
//  Copyright © 2017年 baletu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIViewControllerAnimationType){
    UIViewControllerAnimationFade,
};

/**
 * 动画的工具类
 */
@interface LBAnimatingUtils : NSObject


/**
 * 仿京东加入购物车的动画

 @param animatingImage 商品的图片  动画的image
 @param startPoint 开始动画的起点
 @param endPoint 结束的点
 @param superView 动画加载的父view
 */
+(void)JDShopCarAnimatingImage:(UIImage *)animatingImage startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint superView:(UIView *)superView;



/**
 * 帧动画做的大小变化的动画

 @param view 做动画的view
 */
+(void)scaleViewAnimating:(UIView *)view;



/**
 * 帧动画做的左右晃动的动画

 @param view 做动画的view
 */
+(void)transformXViewAnimating:(UIView *)view;




/**
 * 跳转界面和返回的fade动画  不用系统自带的

 @param controller 要展示的controller
 @param currentController 当前正在显示的controller
 @param isPush 是不是PUSH方式
 @param duration 动画的总时长
 @param animationType 动画的效果  目前只支持fade
 @param isBack 是展现一个新的controller还是返回到上一级   dismiss返回上一级时注意controller参数 可以定义一个weak属性的用来保存传参数
 */
+(void)showNextController:(UIViewController *)controller currentController:(UIViewController *)currentController isPush:(BOOL)isPush duration:(CGFloat)duration animationType:(UIViewControllerAnimationType)animationType isBack:(BOOL)isBack;


/**
 
 * 一个遮罩动画  遮罩的圈逐渐变大的动画
 @param imageView 要做动画的imageView 或则view
 */
+(void)animationShowImageView:(UIView *)imageView;
@end
