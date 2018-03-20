//
//  LBAnimatingUtils.m
//  testPush
//
//  Created by baletu on 2017/7/19.
//  Copyright © 2017年 baletu. All rights reserved.
//

#import "LBAnimatingUtils.h"
#import <objc/message.h>


@implementation LBAnimatingUtils

+(void)JDShopCarAnimatingImage:(UIImage *)animatingImage startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint superView:(UIView *)superView{
    CGFloat duration = 3.f;
    superView = superView ? superView : [UIApplication sharedApplication].keyWindow;
    
    //创建一个layer用来显示图片   和贝瑟尔曲线结合做动画
    CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
    //给layer添加图片
    shapLayer.contents = (id)animatingImage.CGImage;
    shapLayer.frame = CGRectMake(startPoint.x - 20, startPoint.y - 20, animatingImage.size.width, animatingImage.size.height);
    [superView.layer addSublayer:shapLayer];

    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    //1.移到开始轨迹
    [bezierPath moveToPoint:startPoint];
    //添加曲线 控制点  做个抛物线
    [bezierPath addQuadCurveToPoint:endPoint controlPoint:CGPointMake(20, 100)];
    
    
    //2.轨迹动画
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = duration;
    //动画结束不返回最初的样子
    positionAnimation.removedOnCompletion= NO;
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.path = bezierPath.CGPath;
    
    
    
    //3.缩小动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(1.0);
    scaleAnimation.toValue = @(0.6);
    scaleAnimation.duration = duration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    
    //4.旋转动画
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = @(0);
    rotateAnimation.toValue = [NSNumber numberWithDouble:M_PI * 2.0];
    rotateAnimation.cumulative = YES;
    rotateAnimation.duration = duration;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.removedOnCompletion = NO;
    
    //5.闪烁动画
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = duration/10;
    opacityAnimation.fromValue = @(1);
    opacityAnimation.toValue = @(0);
    opacityAnimation.repeatCount = CGFLOAT_MAX;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    
    
    
    [shapLayer addAnimation:positionAnimation forKey:nil];
    [shapLayer addAnimation:scaleAnimation forKey:nil];
    [shapLayer addAnimation:rotateAnimation forKey:nil];
    [shapLayer addAnimation:opacityAnimation forKey:nil];
}


+(void)scaleViewAnimating:(UIView *)view{
    [view.layer removeAnimationForKey:@"boundces"];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.8),@(1.2),@(0.9),@(1.1),@(1.0)];
    animation.duration = 1;
    animation.calculationMode = kCAAnimationCubic;
    //    animation.fillMode = kCAFillModeForwards;
    //    animation.removedOnCompletion = NO;
    [view.layer addAnimation:animation forKey:@"boundces"];
}


+(void)transformXViewAnimating:(UIView *)view{
    id lastView = objc_getAssociatedObject(self, @selector(transformXViewAnimating:));
    if (lastView == view) {
        return;
    }
    [view.layer removeAnimationForKey:@"positionAnimating"];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.values = @[@(20),@( -20),@( 10),@( -10),@(0)];
    //    animation.keyTimes = @[@(0.25),@(0.5),@(0.75),@(1.0),@(1.25)];
    animation.duration = 1;
    animation.calculationMode = kCAAnimationCubic;
    [view.layer addAnimation:animation forKey:@"positionAnimating"];
    objc_setAssociatedObject(self, @selector(transformXViewAnimating:), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+(void)showNextController:(UIViewController *)controller currentController:(UIViewController *)currentController isPush:(BOOL)isPush duration:(CGFloat)duration animationType:(UIViewControllerAnimationType)animationType isBack:(BOOL)isBack{
    [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        currentController.view.alpha = 0.15;
    } completion:^(BOOL finished) {
        controller.view.alpha = 0.15;
        if (isPush) {
            if (isBack) {
                [currentController.navigationController popViewControllerAnimated:NO];
            }else{
                [currentController.navigationController pushViewController:controller animated:NO];
            }
            
        }else{
            if (isBack) {
                [currentController dismissViewControllerAnimated:NO completion:nil];
            }else{
                [currentController presentViewController:controller animated:NO completion:nil];
            }
        }
        [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            controller.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            currentController.view.alpha = 1.0;
        }];
    }];
}


+ (void)animationShowImageView:(UIView *)imageView{
    imageView.clipsToBounds = YES;
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath addArcWithCenter:CGPointMake(imageView.bounds.size.width/2, imageView.bounds.size.height/2) radius:30 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    shapLayer.frame = imageView.bounds;
    shapLayer.path = bezierPath.CGPath;
    
    
    UIBezierPath *bezierPath2 = [[UIBezierPath alloc] init];
    [bezierPath2 addArcWithCenter:CGPointMake(imageView.bounds.size.width/2, imageView.bounds.size.height/2) radius:200 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    shapLayer.frame = imageView.bounds;
    shapLayer.path = bezierPath.CGPath;
    imageView.layer.mask = shapLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(bezierPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(bezierPath2.CGPath);
    animation.duration = 1.f;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [shapLayer addAnimation:animation forKey:nil];
    imageView.layer.mask = shapLayer;
}

@end
