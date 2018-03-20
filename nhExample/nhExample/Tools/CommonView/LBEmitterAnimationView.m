//
//  LBEmitterAnimationView.m
//  nhExample
//
//  Created by liubin on 17/5/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBEmitterAnimationView.h"
#import "LBCustomAlertView.h"

#define EmitterColor_Red      [UIColor colorWithRed:255/255.0 green:0 blue:139/255.0 alpha:1]
#define EmitterColor_Yellow   [UIColor colorWithRed:251/255.0 green:197/255.0 blue:13/255.0 alpha:1]
#define EmitterColor_Blue     [UIColor colorWithRed:50/255.0 green:170/255.0 blue:207/255.0 alpha:1]

@implementation LBEmitterAnimationView


+(void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [window addSubview:backgroundView];
    
    LBCustomAlertView *alertView = [[LBCustomAlertView alloc] initWithTitle:@"恭喜您" content:@"获得了一次免费体验的机会" cancel:nil sure:@"确定"];
    [backgroundView addSubview:alertView];
    
    
    alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    alertView.alpha = 0.1;
    [alertView setSureBlock:^{
        [backgroundView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.5f animations:^{
        alertView.transform = CGAffineTransformMakeScale(1.f, 1.f);
        alertView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    CAEmitterLayer *emitterLayer = [self emitterLayer];
    [backgroundView.layer addSublayer:emitterLayer];
    
    CAAnimationGroup *group = [self animationGroup];
    [emitterLayer addAnimation:group forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [emitterLayer removeFromSuperlayer];
    });
}

/** 开始动画的动画组 */
+(CAAnimationGroup *)animationGroup{
    //红色块爆裂的动画
    CABasicAnimation *redBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.red.birthRate"];
    redBurst.fromValue = [NSNumber numberWithFloat:30.0];
    redBurst.toValue = [NSNumber numberWithFloat:0.0];
    redBurst.duration = 0.5;
    redBurst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    //黄色块粒子的动画
    CABasicAnimation *yellowBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.yellow.birthRate"];
    yellowBurst.fromValue = [NSNumber numberWithFloat:50.0];
    yellowBurst.toValue = [NSNumber numberWithFloat:0.0];
    yellowBurst.duration = 0.5;
    yellowBurst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //绿色块粒子的动画
    CABasicAnimation *blueBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.blue.birthRate"];
    blueBurst.fromValue = [NSNumber numberWithFloat:40.0];
    blueBurst.toValue = [NSNumber numberWithFloat:0.0];
    blueBurst.duration = 0.5;
    blueBurst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //star块粒子的动画
    CABasicAnimation *starBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.star.birthRate"];
    starBurst.fromValue = [NSNumber numberWithFloat:40.0];
    starBurst.toValue = [NSNumber numberWithFloat:0.0];
    starBurst.duration = 0.5;
    starBurst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[redBurst,yellowBurst,blueBurst,starBurst];
    
    return group;
}

/** 获取一个粒子效果的layer */
+(CAEmitterLayer *)emitterLayer{
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    
    UIImage *redImage = imageWithColor(EmitterColor_Red);
    CAEmitterCell *cell1 = [self cellWithImage:redImage];
    cell1.name = @"red";
    
    UIImage *yellowImage = imageWithColor(EmitterColor_Yellow);
    CAEmitterCell *cell2 = [self cellWithImage:yellowImage];
    cell2.name = @"yellow";
    
    UIImage *blueImage = imageWithColor(EmitterColor_Blue);
    CAEmitterCell *cell3 = [self cellWithImage:blueImage];
    cell3.name = @"blue";
    
    UIImage *starImage = ImageNamed(@"success_star");
    CAEmitterCell *cell4 = [self cellWithImage:starImage];
    cell4.name = @"star";
    
    //粒子发射的位子
    emitterLayer.emitterPosition = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    //粒子的范围
    emitterLayer.emitterSize = CGSizeMake(kScreenWidth, kScreenHeight);
    
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    //粒子的形状
    emitterLayer.emitterShape = kCAEmitterLayerRectangle;
    //粒子的混合模式
    emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    emitterLayer.emitterCells = @[cell1,cell2,cell3,cell4];
    
    return emitterLayer;
}

+(CAEmitterCell *)cellWithImage:(UIImage *)image{
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.name = @"heart";
    cell.contents = (__bridge id _Nullable)(image.CGImage);
    
    //1.cell的缩放比例
    cell.scale = 0.5;
    cell.scaleRange = 0.5;
    
    //2.每秒产生的数量 这样设置就一直不会消失了  我们需要时机置0  让他消失
//    cell.birthRate = 40;
    //3.粒子的声明周期
    cell.lifetime = 20;
    //4.每秒变透明的速度
//    cell.alphaSpeed = 0.02;
    //5.粒子的速度
    cell.velocity = 200;
    //随机的速度
    cell.velocityRange = 200;
    
    //6.y方向的加速度
    cell.yAcceleration = 9.8;
    cell.xAcceleration = 0;
    
    //7.掉落的角度范围
    cell.emissionRange = M_PI;
    
    cell.scaleSpeed = -0.05;
    
    cell.spin = 2 * M_PI;
    cell.spinRange = 2 * M_PI;
    
    return cell;
}

UIImage *imageWithColor(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 13, 17);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
