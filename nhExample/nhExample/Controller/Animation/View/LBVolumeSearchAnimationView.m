//
//  LBVolumeSearchAnimationView.m
//  nhExample
//
//  Created by baletu on 2017/8/29.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBVolumeSearchAnimationView.h"

static CGFloat const kAnimationDuration = 0.05;

static CGFloat const kLineHeight = 20;

/** 搜索波浪半径的值 */
static CGFloat waveRaduis = 0.0;
/** 转圈的角度变化量 */
static CGFloat circleOffset = 0.05;

@interface LBVolumeSearchAnimationView()

/** 定时器   用来做动画用的  定时刷新动画 */
@property (nonatomic,strong) NSTimer *timer;

/** 内园不动的园的半径 */
@property (nonatomic,assign) CGFloat raduis;

/** 中间填充音量的view */
@property (nonatomic,strong) UIView *centerView;

/** 中间音量大小变化的layer */
@property (nonatomic,strong) CAShapeLayer *centerLayer;

@end

@implementation LBVolumeSearchAnimationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _animationState = LBVolumeStateTypeSearch;
        [self centerView];
    }
    return self;
}


//clockwise 0为顺时针，1为逆时针。
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 3);
    CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
    self.raduis = self.bounds.size.width/8;
    
    //1. 画最里面不动的两个弧线
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, self.raduis, 0.75 * M_PI, M_PI * 1.25, NO);
    //开始画path
    CGContextStrokePath(context);

//    CGContextSetLineWidth(context, 3);
//    CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, self.raduis, 1.75 * M_PI, M_PI * 2.5, NO);
//    CGContextStrokePath(context);
    
    //2.画下面不动的竖线
//    CGContextSetLineWidth(context, 3);
//    CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
    CGContextMoveToPoint(context, self.bounds.size.width/2, self.bounds.size.height/2 + self.raduis);
    CGContextAddLineToPoint(context, self.bounds.size.width/2, self.bounds.size.height/2 + self.raduis + kLineHeight);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
    
 
    if (_animationState == LBVolumeStateTypeSearch) {
        [self drawSearchWaveWithContext:context];
    }else{
        [self drawCircleWithContext:context];
    }
}

#pragma mark 绘制波浪搜索的动画
-(void)drawSearchWaveWithContext:(CGContextRef)context{
    waveRaduis = waveRaduis  > self.bounds.size.width / 2 ? 0 : waveRaduis;
    waveRaduis ++;
    CGFloat raduis = self.raduis + waveRaduis;
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, raduis, 0.75 * M_PI, M_PI * 1.25, NO);
    CGContextStrokePath(context);
    
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, raduis, M_PI * 1.75, M_PI * 2.25, NO);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
    
    // 在画一个从内园开始的
    if (waveRaduis > self.raduis * 1.5) {
        CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, waveRaduis - self.raduis * 1.5 + self.raduis, 0.75 * M_PI, M_PI * 1.25, NO);
        CGContextStrokePath(context);
        
        CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, waveRaduis - self.raduis * 1.5 + self.raduis, M_PI * 1.75, M_PI * 2.25, NO);
        CGContextStrokePath(context);
    }
    
    //偏移量大于3倍的时候 再画一个园
    if (waveRaduis > self.raduis * 3) {
        CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, waveRaduis - self.raduis * 3 + self.raduis, 0.75 * M_PI, M_PI * 1.25, NO);
        CGContextStrokePath(context);
        
        CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, waveRaduis - self.raduis * 3 + self.raduis, M_PI * 1.75, M_PI * 2.25, NO);
        CGContextStrokePath(context);
    }
    
}

#pragma mark 绘制圆形搜索的动画
-(void)drawCircleWithContext:(CGContextRef)context{
    circleOffset += 0.05;
    CGFloat raduis = self.bounds.size.width * 1 / 3;
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, raduis, 0 + circleOffset, M_PI_2 + circleOffset, NO);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(context);
    
    
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, raduis, M_PI + circleOffset, M_PI + M_PI_2  + circleOffset, NO);
    /** 设置画笔的颜色 */
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(context);
}


#pragma mark 刷新动画
-(void)refreshAnimation{
    //标记刷新  调用drawRect方法
    [self setNeedsDisplay];
}

#pragma mark 开始结束动画
-(void)startAnimating{
    [self stopAnimating];
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:kAnimationDuration target:self selector:@selector(refreshAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)stopAnimating{
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}


#pragma mark 设置volume音量的时候 设置中间的变化
-(void)setVolume:(NSInteger)volume{
    if (volume > 100 || volume < 0 || _volume == volume) {
        return;
    }
    CGFloat height = volume * self.centerView.bounds.size.height/100;
    self.centerLayer.frame = CGRectMake(0, self.centerView.bounds.size.height - height, self.centerView.bounds.size.width, height);
}

#pragma mark lazy load
-(UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.layer.borderColor = [UIColor purpleColor].CGColor;
        _centerView.layer.borderWidth = 3;
        _centerView.layer.masksToBounds = YES;
        [self addSubview:_centerView];
    }
    return _centerView;
}

-(CAShapeLayer *)centerLayer{
    if (!_centerLayer) {
        _centerLayer = [CAShapeLayer layer];
        _centerLayer.backgroundColor = [UIColor purpleColor].CGColor;
        [self.centerView.layer addSublayer:_centerLayer];
    }
    return _centerLayer;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width/8;
    CGFloat height = width * 2;
    self.centerView.layer.cornerRadius = width/2;
    self.centerView.frame = CGRectMake((self.bounds.size.width - width)/2, (self.bounds.size.height - height)/2 - width / 2, width, height);
}

@end
