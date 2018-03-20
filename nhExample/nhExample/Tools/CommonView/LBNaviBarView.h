//
//  LBNaviBarView.h
//  LBSamples
//
//  Created by liubin on 17/2/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

//typedef void(^rightBlock)();
#import <UIKit/UIKit.h>

/**
    分装了左右各有按钮的naviBar  中间是label  一般frame 0 0 Screenwidth 64
 */
@interface LBNaviBarView : UIView

/**
  获取一个自定义导航栏
 @param leftImage 左面的图片
 @param title 标题
 @param leftBlock 左边的点击事件
 @return naviBar
 */
-(instancetype)initWithLeftImage:(NSString *)leftImage title:(NSString *)title  leftBlock:(dispatch_block_t)leftBlock backGroundColor:(UIColor *)backColor;

/**
 工厂类初始化方法

 @param leftImage 左边显示的图片的名字  按钮的宽高一致
 @param title     中间显示的标题
 @param rightImage 右边显示的图片的名字
 @return
 */
-(instancetype)initWithLeftImage:(NSString *)leftImage title:(NSString *)title rightImage:(NSString *)rightImage leftBlock:(dispatch_block_t)leftBlock rightBlock:(void(^)())rightBlock;

/** 封装了方法 */
-(instancetype)initWithLeftImage:(NSString *)leftImage title:(NSString *)title rightImage:(NSString *)rightImage leftBlock:(dispatch_block_t)leftBlock rightBlock:(void(^)())rightBlock backgroundColor:(UIColor *)backgroundColor;
@end

@interface LBScaleImageButton : UIButton

@end
