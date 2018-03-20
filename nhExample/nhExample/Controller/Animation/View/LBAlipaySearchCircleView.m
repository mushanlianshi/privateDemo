//
//  LBAlipaySearchCircleView.m
//  nhExample
//
//  Created by liubin on 17/5/2.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBAlipaySearchCircleView.h"
//static UIColor * const kCircleColor = [UIColor colorWithRed:0 green:191 blue:255 alpha:alpha];

@implementation LBAlipaySearchCircleView

-(void)drawRect:(CGRect)rect{
    NSLog(@"drawRect ============");
    //默认画圆的半径是30
    CGFloat raduis = 30.f;
    NSArray *alphas = @[@(1.f),@(0.8),@(0.4),@(0.2)];
    [self drawCircleWithAlpha:[alphas[3] floatValue] raduis:raduis];
    
}


/**
 * 根据半径和透明度来画圆
 @param alpha 透明度
 @param raduis 半径
 */
-(void)drawCircleWithAlpha:(CGFloat)alpha raduis:(CGFloat)raduis{
//    for (CALayer *layer in self.layer.sublayers) {
//        [layer removeFromSuperlayer];
//    }
//    // 2.描述路径、形状
//    //  最后一个参数是否逆时针
//    UIBezierPath *berierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:raduis startAngle:0 endAngle:M_PI*2 clockwise:NO];
//    CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
//    shapLayer.frame = self.bounds;
//    shapLayer.strokeColor = [UIColor colorWithRed:0 green:191 blue:255 alpha:alpha].CGColor;
//    shapLayer.fillColor = [UIColor colorWithRed:0 green:191 blue:255 alpha:alpha].CGColor;
//    shapLayer.path = berierPath.CGPath;
//    [self.layer addSublayer:shapLayer];
    
    
    //第二种方式
    UIBezierPath *berierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:raduis startAngle:0 endAngle:M_PI*2 clockwise:NO];
    CGContextRef context =  UIGraphicsGetCurrentContext();
    //3.添加路径到上下文
    CGContextAddPath(context, berierPath.CGPath);
    UIColor *color = [UIColor colorWithRed:0 green:191 blue:255 alpha:alpha];
    //4.设置颜色
    [color setFill];
    [color setStroke];
    //5.显示上下文 显示一个实心圆
    CGContextFillPath(context);
    
}

#pragma mark - 添加水印

/// 给图片添加文字水印：
+ (UIImage *)jx_WaterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed{
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

@end
