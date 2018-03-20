//
//  LBAnimationController.h
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBaseViewController.h"


/**
 * 一些动画的Controller
 */
@interface LBAnimationController : LBBaseViewController

@end


//[UIView beginAnimations:nil context:nil];
////设置图片旋转的角度  根据自己 如果open为yes旋转90度 NO的话不变 在相对于自己旋转0度
////CGAffineTransformMakeRotation 旋转到 角度是相对于自己的原来的位子
//self.imageView.transform = CGAffineTransformMakeRotation(_open?M_PI_2:0);
////提交动画
//[UIView commitAnimations];

// //一个线
//+ (instancetype)bezierPath;
//// 根据一个Rect 画一个矩形曲线
//+ (instancetype)bezierPathWithRect:(CGRect)rect;
///**
// *  根据一个Rect 画一个椭圆曲线  Rect为正方形时 画的是一个圆
// *  @param rect CGRect一个矩形
// */
//+ (instancetype)bezierPathWithOvalInRect:(CGRect)rect;
///**
// *  根据一个Rect 画一个圆角矩形曲线 (Radius:圆角半径)    当Rect为正方形时且Radius等于边长一半时 画的是一个圆
// *  @param rect CGRect一个矩形
// */
//+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius; // rounds all corners wit
///**
// *  根据一个Rect 针对四角中的某个或多个角设置圆角
// *
// *  @param rect        CGRect一个矩形
// *  @param corners     允许指定矩形的部分角为圆角，而其余的角为直角，取值来自枚举
// *  @param cornerRadii  指定了圆角的半径，这个参数的取值是 CGSize 类型，也就意味着这里需要给出的是椭圆的半径。
// */
//+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
///**
// *  以某个中心点画弧线
// *  @param center     指定了圆弧所在正圆的圆心点坐标
// *  @param radius     指定了圆弧所在正圆的半径
// *  @param startAngle 指定了起始弧度位置  注意: 起始与结束这里是弧度
// *  @param endAngle   指定了结束弧度位置
// *  @param clockwise  指定了绘制方向，以时钟方向为判断基准   看下图
// */
//+ (instancetype)bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;
///**
// *  根据CGPath创建并返回一个新的UIBezierPath对象
// *  @param CGPath CGPathRef
// */
//+ (instancetype)bezierPathWithCGPath:(CGPathRef)CGPath;



//常见的转换类型（type）：
//
//kCATransitionFade               //淡出
//
//kCATransitionMoveIn          //覆盖原图
//
//kCATransitionPush               //推出
//
//kCATransitionReveal          //底部显出来
//
//SubType:
//
//kCATransitionFromRight
//
//kCATransitionFromLeft    // 默认值
//
//kCATransitionFromTop
//
//kCATransitionFromBottom
//设置其他动画类型的方法(type):
//
//pageCurl   向上翻一页
//
//pageUnCurl 向下翻一页
//
//rippleEffect 滴水效果
//
//suckEffect 收缩效果，如一块布被抽走
//
//cube 立方体效果
//
//oglFlip 上下翻转效果


///*
// 颜色数组，设置我们需要过的的颜色，必须是CGColor对象
// */
//@property(nullable, copy) NSArray *colors;
///*
// 颜色开始进行过渡的位置
// 这个数组中的元素是NSNumber类型，单调递增的，并且在0——1之间
// 例如，如果我们设置两个颜色进行过渡，这个数组中写入0.5，则第一个颜色会在达到layer一半的时候开始向第二个颜色过渡
// */
//@property(nullable, copy) NSArray<NSNumber *> *locations;
///*
// 下面两个参数用于设置渲染颜色的起点和终点 取值范围均为0——1
// 默认起点为（0.5 ，0） 终点为（0.5 ，1）,颜色的过渡范围就是沿y轴从上向下
// */
//@property CGPoint startPoint;
//@property CGPoint endPoint;
///*
// 渲染风格 iOS中只支持一种默认的kCAGradientLayerAxial，我们无需手动设置
// */
//@property(copy) NSString *type;
////拷贝的次数
//@property NSInteger instanceCount;
////是否开启景深效果
//@property BOOL preservesDepth;
////当CAReplicatorLayer的子Layer层进行动画的时候，拷贝的副本执行动画的延时
//@property CFTimeInterval instanceDelay;
////拷贝副本的3D变换
//@property CATransform3D instanceTransform;
////拷贝副本的颜色变换
//@property(nullable) CGColorRef instanceColor;
////每个拷贝副本的颜色偏移参数
//@property float instanceRedOffset;
//@property float instanceGreenOffset;
//@property float instanceBlueOffset;
////每个拷贝副本的透明度偏移参数
//@property float instanceAlphaOffset;
////设置图形的填充颜色
//@property(nullable) CGColorRef fillColor;
///*
// 设置图形的填充规则 选项如下：
// 非零填充
// NSString *const kCAFillRuleNonZero;
// 奇偶填充
// NSString *const kCAFillRuleEvenOdd;
// */
//@property(copy) NSString *fillRule;
////设置线条颜色
//@property(nullable) CGColorRef strokeColor;
////设置线条的起点与终点 0-1之间
//@property CGFloat strokeStart;
//@property CGFloat strokeEnd;
////设置线条宽度
//@property CGFloat lineWidth;
////设置两条线段相交时锐角斜面长度
//@property CGFloat miterLimit;
///*
// 设置线条首尾的外观
// 可选参数如下
// 无形状
// NSString *const kCALineCapButt;
// 圆形
// NSString *const kCALineCapRound;
// 方形
// NSString *const kCALineCapSquare;
// */
//@property(copy) NSString *lineCap;
///*
// 设置线段的链接方式
// 棱角
// NSString *const kCALineJoinMiter;
// 平滑
// NSString *const kCALineJoinRound;
// 折线
// NSString *const kCALineJoinBevel;
// */
//@property(copy) NSString *lineJoin;
