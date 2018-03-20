//
//  LBCheckBoxView.m
//  testPush
//
//  Created by baletu on 2017/7/27.
//  Copyright © 2017年 baletu. All rights reserved.
//

#import "LBCheckBoxView.h"

@interface LBCheckBoxView ()

/** 用来记录动画layer的  下次在绘制的时候移除添加的 */
@property (nonatomic,strong) CAShapeLayer *shapLayer;

@end

@implementation LBCheckBoxView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _fillColor = [UIColor redColor];
        _duiColor = [UIColor whiteColor];
        _circleColor = [UIColor lightGrayColor];
    }
    return self;
}


-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect{
    NSLog(@"LBLog self.layer sublayers count is %zd ",self.layer.sublayers.count);
    CGPoint centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat raduis = self.bounds.size.width/2 - 0.5;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:raduis startAngle:0 endAngle:M_PI * 2  clockwise:YES];
    circlePath.lineWidth = 1;
    
    
    if (self.isSelected) {
        
        //1.设置填充颜色
        [_fillColor set];
        //2.封闭
        [circlePath fill];
        
        UIBezierPath *duiPath = [[UIBezierPath alloc] init];
        [duiPath moveToPoint:CGPointMake( 0.3 * raduis, raduis)];
        [duiPath addLineToPoint:CGPointMake(0.8 * raduis, 1.4 * raduis)];
        [duiPath addLineToPoint:CGPointMake(1.8 * raduis, 0.25 * raduis)];
        duiPath.lineWidth = 2;
        duiPath.lineCapStyle = kCGLineCapRound;
        [_duiColor set];

        if (_isAnimating) {
            _shapLayer = [[CAShapeLayer alloc] init];
            _shapLayer.frame = self.bounds;
            _shapLayer.path = duiPath.CGPath;
            _shapLayer.fillColor = [UIColor clearColor].CGColor;
            _shapLayer.strokeColor = [UIColor whiteColor].CGColor;
            _shapLayer.lineWidth = 2;
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.duration = 0.6;
            animation.fromValue = @(0);
            animation.toValue = @(1);
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];;
            [_shapLayer addAnimation:animation forKey:nil];

            [self.layer addSublayer:_shapLayer];
        }
        //不用动画 贝塞尔曲线开始画
        else{
            [duiPath stroke];
        }
        
    }else{
        [self.shapLayer removeFromSuperlayer];
        [_circleColor setStroke];
        [circlePath stroke];
    }
}


@end
