//
//  LBScanGridAnimationView.m
//  nhExample
//
//  Created by liubin on 17/5/4.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBScanGridAnimationView.h"

@interface LBScanGridAnimationView()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LBScanGridAnimationView

-(instancetype)initScanAnimationFrame:(CGRect)frame superView:(UIView *)superView image:(UIImage *)image{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.clipsToBounds = YES;
        self.imageView.frame = self.bounds;
        self.imageView.image = image;
    }
    return self;
}

-(void)startScanAnimationFrame:(CGRect)frame superView:(UIView *)superView image:(UIImage *)image{
    self.clipsToBounds = YES;
    self.frame = frame;
    self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _imageView.image = image;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = [NSNumber numberWithFloat:-frame.size.height];
    animation.toValue = [NSNumber numberWithFloat:0.5f];
    animation.duration = 1.5;
    animation.repeatCount = CGFLOAT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
//    animation.autoreverses = YES;
    [_imageView.layer addAnimation:animation forKey:@"gridAnimation"];
}


-(void)startScanAnimating{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = [NSNumber numberWithFloat:-self.frame.size.height];
    animation.toValue = [NSNumber numberWithFloat:0.5f];
    animation.duration = 1.5;
    animation.repeatCount = CGFLOAT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //    animation.autoreverses = YES;
    [_imageView.layer addAnimation:animation forKey:@"gridAnimation"];
}

-(void)stopScanAnimating{
//    CABasicAnimation *animation = (CABasicAnimation *)[self.layer animationForKey:@"gridAnimation"];
    [_imageView.layer removeAnimationForKey:@"gridAnimation"];
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(void)dealloc{
    MyLog(@"LBlog LBScanANimatioNView  dealloc ==============");
}

@end
