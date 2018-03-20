//
//  LBDrawView.m
//  testPush
//
//  Created by baletu on 2017/8/31.
//  Copyright © 2017年 baletu. All rights reserved.
//

#import "LBDrawView.h"

@interface LBDrawView ()

/** 划线的路径 */
@property (nonatomic,strong) UIBezierPath *bezierPath;

@end

@implementation LBDrawView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化一些默认值
        _strokeColor = [UIColor redColor];
        _lineWidth = 5;
        _isTouchAble = YES;
    }
    return self;
}

-(void)setLineWidth:(CGFloat)lineWidth{
    if (_lineWidth != lineWidth && lineWidth > 0.5) {
        _lineWidth = lineWidth;
        self.bezierPath.lineWidth = lineWidth;
    }
}

-(void)setStrokeColor:(UIColor *)strokeColor{
    if (_strokeColor != strokeColor && strokeColor) {
        _strokeColor = strokeColor;
        CAShapeLayer *shapLayer = (CAShapeLayer *)self.layer;
        shapLayer.strokeColor = strokeColor.CGColor;
    }
}

-(void)setIsClearDrawLine:(BOOL)isClearDrawLine{
    _isClearDrawLine = isClearDrawLine;
    if (isClearDrawLine) {
        self.bezierPath = nil;
        CAShapeLayer *shapLayer = (CAShapeLayer *)self.layer;
        shapLayer.path = nil;
    }
}


#pragma mark 让layer是CAShapLayer
+(Class)layerClass{
    return [CAShapeLayer class];
}


#pragma mark 移动  划线处理
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.isTouchAble) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.bezierPath moveToPoint:point];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.isTouchAble) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.bezierPath addLineToPoint:point];
    [self.bezierPath moveToPoint:point];
    
    CAShapeLayer *shapLayer = (CAShapeLayer *)self.layer;
    shapLayer.path = self.bezierPath.CGPath;
    shapLayer.strokeColor = self.strokeColor.CGColor;
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.isTouchAble) {
        return;
    }
}



#pragma mark lazy load
-(UIBezierPath *)bezierPath{
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPath];
    }
    return _bezierPath;
}

-(UIImage *)imageForDrawLine{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
