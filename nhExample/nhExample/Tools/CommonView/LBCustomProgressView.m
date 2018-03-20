//
//  LBCustomProgressView.m
//  nhExample
//
//  Created by liubin on 17/5/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomProgressView.h"

@interface LBCustomProgressView()<CAAnimationDelegate>

@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation LBCustomProgressView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //1. 设置渐变色的属性
        CAGradientLayer *gradientLayer = (CAGradientLayer *)[self layer];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        //注意是CGColor类型的
        NSArray *colors = @[(id)[[UIColor redColor] colorWithAlphaComponent:0.3].CGColor,(id)[UIColor redColor].CGColor];

        gradientLayer.colors = [NSArray arrayWithArray:colors];
//        gradientLayer.locations = @[@(0.5),@(1.0)];
        
        self.maskLayer = [CALayer layer];
        self.maskLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        self.maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        self.layer.mask = self.maskLayer;
        
        //开始动画
//        [self startAnimating];
        

        
    }
    return self;
}

-(void)startAnimating{
    CAGradientLayer *layer = (CAGradientLayer *)[self layer];
    NSMutableArray *colorsArray = [layer colors].mutableCopy;
    //把最后一个移到第一个  实现颜色变换  每次都移动  做出变换 动画效果
    UIColor *lastColor = [colorsArray lastObject];
    [colorsArray insertObject:lastColor atIndex:0];
    
    [layer setColors:colorsArray];
//    layer.locations = @[@(0.5),@(1.0)];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.toValue = colorsArray;
    animation.duration = 0.1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //设置代理  动画结束继续开始动画
    animation.delegate = self;
    [layer addAnimation:animation forKey:nil];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self startAnimating];
}

-(void)setProgress:(CGFloat)progress{
    if (_progress!=progress) {
        [self setNeedsLayout];
        _progress = MIN(1.0, progress);
    }
}

-(void)layoutSubviews{
    CGRect rect = self.bounds;
    rect.size.width = self.bounds.size.width * self.progress;
    self.maskLayer.frame = rect;
    MyLog(@"self.maskLayer frame is %@ ",NSStringFromCGRect(self.maskLayer.frame));
}


/** 从写系统默认的方法  返回一个渐变色的layer 的类 */
+(Class)layerClass{
    return [CAGradientLayer class];
}

-(void)dealloc{
    MyLog(@"LBLog progressView dealloc ==================");
}



@end
