//
//  LBCustomADView.m
//  nhExample
//
//  Created by liubin on 17/4/18.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomADView.h"
#import <objc/runtime.h>
#import "LBGCDUtils.h"
const char adTimeKey;
const char clickBlockKey;
@interface LBCustomADView()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *timeButton;

@property (nonatomic, copy) void(^clickADBlock)();
@end

@implementation LBCustomADView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adViewClicked:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}


-(void)showADViewImage:(UIImage *)image superView:(UIView *)superView limitTime:(NSTimeInterval)limitTime clickBlock:(void (^)())clickBlock{
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    if (clickBlock) {
        objc_setAssociatedObject(self, &clickBlockKey, clickBlock, OBJC_ASSOCIATION_COPY);
    }
    
    [superView addSubview:self];
    self.imageView.image = image;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1.f;
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue =  [NSNumber numberWithFloat:1.15];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.imageView.layer addAnimation:animation forKey:nil];
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    endAnimation.duration = 1.f;
    endAnimation.fromValue = [NSNumber numberWithFloat:1.15f];
    endAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    //保证保持动画后的状态  不然回原装会有一个闪的效果
    endAnimation.fillMode = kCAFillModeForwards;
    endAnimation.removedOnCompletion = NO;
    WS(weakSelf);
    //稍微小点  防止结束回去了
    [LBGCDUtils GCDAfterTime:1.f queue:nil block:^{
        [weakSelf.imageView.layer addAnimation:endAnimation forKey:nil];
    }];
    
    __block NSInteger timeLimit = limitTime + 1;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (timeLimit <=0) {
            [self stopTimer];
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSString *title = [NSString stringWithFormat:@"%lds 跳过",timeLimit];
                [self.timeButton setTitle:title forState:UIControlStateNormal];
            });
            timeLimit --;
        }
    });
    objc_setAssociatedObject(self, &adTimeKey, timer, OBJC_ASSOCIATION_RETAIN);
    dispatch_resume(timer);
    
}

-(void)stopTimer{
    dispatch_source_t timer = objc_getAssociatedObject(self, &adTimeKey);
    dispatch_source_cancel(timer);
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

-(void)layoutSubviews{
    self.imageView.frame = self.bounds;
    CGFloat width = 50.f;
    CGFloat height =30.f;
    self.timeButton.frame = CGRectMake(self.width - width -5, 25, width, height);
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(UIButton *)timeButton{
    if (!_timeButton) {
        _timeButton = [[UIButton alloc] init];
        [_timeButton addTarget:self action:@selector(hiddenTimeButton:) forControlEvents:UIControlEventTouchUpInside];
        _timeButton.titleLabel.font = kFont(12);
        [_timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _timeButton.layerCornerRadius = 5;
        _timeButton.layerBorderWidth = 1;
        _timeButton.layerBorderColor = [UIColor whiteColor];
        [self addSubview:_timeButton];
    }
    return _timeButton;
}

-(void)adViewClicked:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"LBLog adView clicked =========");
    dispatch_block_t handler = objc_getAssociatedObject(self, &clickBlockKey);
    if (handler) {
        [self removeFromSuperview];
        handler();
    }
//    (void(^LBblock)()) block;
}

-(void)hiddenTimeButton:(UIButton *)button{
    [self removeFromSuperview];
}

-(void)dealloc{
    NSLog(@"LBlog adview dealloc ====================");
}

@end
