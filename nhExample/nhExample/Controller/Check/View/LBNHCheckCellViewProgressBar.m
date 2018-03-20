//
//  LBNHCheckCellViewProgressBar.m
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHCheckCellViewProgressBar.h"

@interface LBNHCheckCellViewProgressBar()


/** 左侧显示百分比的label */
@property (nonatomic, strong) UILabel *leftLabel;

/** 右侧显示百分比的label */
@property (nonatomic, strong) UILabel *rightLabel;

/** 显示进度条的左边的layer */
@property (nonatomic, strong) CAShapeLayer *leftLayer;

/** 显示进度条的右边的layer */
@property (nonatomic, strong) CAShapeLayer *rightLayer;

@end

@implementation LBNHCheckCellViewProgressBar

+(instancetype)bar{
    return [[self alloc] init];
}

//左右label显示的方法 移除动画的layer 显示百分比
-(void)showLeftAndRightLabel{
    [self.leftLabel.layer removeAllAnimations];
    [self.rightLabel.layer removeAllAnimations];
    
    self.leftLabel.frame = CGRectMake(5, self.height/2  -20, 35, 10);
    self.rightLabel.frame = CGRectMake(self.width- 30 -5, self.height/2  -20, 35, 10);
    
    NSLog(@"self.leftLabel frame is %@ ",NSStringFromCGRect(self.leftLabel.frame));
    NSLog(@"rightLabel frame is %@ ",NSStringFromCGRect(self.rightLabel.frame));
    NSLog(@"self frame is %@ ",NSStringFromCGRect(self.frame));
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(0.5);
    animation.toValue = @(1.0);
    animation.duration = 0.3f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.leftLabel.layer addAnimation:animation forKey:@"leftLabelAnimation"];
    [self.rightLabel.layer addAnimation:animation forKey:@"rightLabelAnimation"];
    [self performSelector:@selector(sendAnimationFinish) withObject:nil afterDelay:0.5];
}
-(void)sendAnimationFinish{
    if (self.finishAnimationBlock) {
        self.finishAnimationBlock();
    }
}

-(void)setLeftScale:(CGFloat)leftScale{
    _leftScale = leftScale;
    NSInteger leftCount = leftScale*100;
    self.leftLabel.text = [NSString stringWithFormat:@"%ld%%",leftCount];
    
    //贝瑟尔曲线的高度
    CGFloat height = 10;
    UIRectCorner corner ;
    if (leftScale == 1) {
        corner = UIRectCornerAllCorners;//如果是1 百分百 四个角弧度
    }else{
        corner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    }
    //开始的path
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, self.height/2.0-height/2.0, 0, height) byRoundingCorners:corner cornerRadii:CGSizeMake(5.f, 5.f)];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, self.height/2.0-height/2.0, self.width*leftScale, height) byRoundingCorners:corner cornerRadii:CGSizeMake(5.f, 5.f)];
    
    CGFloat duration = 0.8;
    [self performSelector:@selector(showLeftAndRightLabel) withObject:nil afterDelay:duration];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    animation.fromValue = (__bridge id _Nullable)beginPath.CGPath;
    animation.toValue = (__bridge id _Nullable)endPath.CGPath;
    [self.leftLayer addAnimation:animation forKey:@"leftLayerAnimation"];
    
}


-(void)setRightScale:(CGFloat)rightScale{
    _rightScale = rightScale;
    NSInteger rightCount = rightScale*100;
    self.rightLabel.text = [NSString stringWithFormat:@"%ld%%",rightCount];
    
    //贝瑟尔曲线的高度
    CGFloat height = 10;
    UIRectCorner corner ;
    if (rightScale == 1) {
        corner = UIRectCornerAllCorners;//如果是1 百分百 四个角弧度
    }else{
        corner = UIRectCornerTopRight | UIRectCornerBottomRight;
    }
    //开始的path
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.width, self.height/2.0-height/2.0, 0, height) byRoundingCorners:corner cornerRadii:CGSizeMake(5.f, 5.f)];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.width - self.width*rightScale, self.height/2.0-height/2.0, self.width*rightScale, height) byRoundingCorners:corner cornerRadii:CGSizeMake(5.f, 5.f)];
    
    CGFloat duration = 0.8;
//    [self performSelector:@selector(showLeftAndRightLabel) withObject:nil afterDelay:duration];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    animation.fromValue = (__bridge id _Nullable)beginPath.CGPath;
    animation.toValue = (__bridge id _Nullable)endPath.CGPath;
    [self.rightLayer addAnimation:animation forKey:@"rightLayerAnimation"];
}


-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = kFont(12);
        _leftLabel.textColor = [UIColor colorWithRed:1.00f green:0.50f blue:0.64f alpha:1.00f];;
        [self addSubview:_leftLabel];
    }
    return _leftLabel;
}

-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = kFont(12);
        _rightLabel.textColor = [UIColor colorWithRed:0.48f green:0.82f blue:0.90f alpha:1.00f];;
        [self addSubview:_rightLabel];
    }
    return _rightLabel;
}

-(CAShapeLayer *)leftLayer{
    if (!_leftLayer) {
        _leftLayer = [[CAShapeLayer alloc] init];
        _leftLayer.fillColor =[UIColor colorWithRed:1.00f green:0.50f blue:0.64f alpha:1.00f].CGColor;
        [self.layer addSublayer:_leftLayer];
    }
    return _leftLayer;
}

-(CAShapeLayer *)rightLayer{
    if (!_rightLayer) {
        _rightLayer = [[CAShapeLayer alloc] init];
        _rightLayer.fillColor =[UIColor colorWithRed:0.48f green:0.82f blue:0.90f alpha:1.00f].CGColor;
        [self.layer addSublayer:_rightLayer];
    }
    return _rightLayer;
}



@end
