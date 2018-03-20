//
//  LBCustomCircleAnimationView.h
//  nhExample
//
//  Created by liubin on 17/4/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 自定义转盘动画view  类似典型营业厅的  半径需要大于屏幕宽度的一半
 */
@interface LBCustomCircleAnimationView : UIView


/**
 * 初始化  半径需要大于屏幕宽度的一半
 @param raduis 外圆的半径
 @param centerPoint 园的中心点 有园的半径和园的中心点  就可以算出frame
 @param outImage 外圆显示的图片
 @param innerImage 内园显示的图片
 @param circleMargin 内外圆的margin间距 可以算出内园的位置
 @return 圆盘对象
 */
-(instancetype)initWithCircleRaduis:(CGFloat)raduis centerPoint:(CGPoint)centerPoint outCircleImage:(UIImage *)outImage innerCircleImage:(UIImage *)innerImage circleMargin:(CGFloat)circleMargin;



/**
 * 添加子view并控制显示个数的方法
 @param views 存放子view的数组
 @param showCount 最多显示几个在界面
 */
-(void)addSubViews:(NSArray *)views showViewCount:(NSInteger)showCount;

@end
