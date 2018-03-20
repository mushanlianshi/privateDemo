//
//  LBRefreshCustomHeader.m
//  nhExample
//
//  Created by baletu on 2017/9/1.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBRefreshCustomHeader.h"

/** 超过多少开始刷新动画的距离 */
static CGFloat const kRefreshMargin = 100.0;
static CGFloat const kCircleRaduis = 17;
/** 太阳边上有多少线 */
static NSInteger const kLineCount = 8;
/** 太阳边上的长度 */
static CGFloat const kLineHeight = 7;
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


@interface LBRefreshCustomHeader ()

/** 中间太阳圆圈的layer  用来做太阳动画的 */
@property (nonatomic,strong) CAShapeLayer *circleLayer;

@end

@implementation LBRefreshCustomHeader

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 100);
//        CGRect frame = self.frame;
//        frame.size.width = kScreenWidth;
//        self.frame = frame;
        [self initUI];
    }
    return self;
}

#pragma mark 初始化UI
-(void)initUI{
    self.backgroundColor = [UIColor lightGrayColor];
    [self.layer addSublayer:self.circleLayer];
    [self drawSunLine];
}

/** 画中间太阳形状 */
-(void)drawSunLine{
    CAShapeLayer *shapLayer = (CAShapeLayer *)self.layer;
    shapLayer.lineWidth = 2;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//    [bezierPath moveToPoint:center];
    [bezierPath addArcWithCenter:center radius:kCircleRaduis startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    
    for (int i = 0 ; i < kLineCount; i++) {
        
        //1.计算边上线的起点
        CGPoint startPoint = CGPointMake(center.x + (kCircleRaduis + shapLayer.lineWidth) * sin( M_PI * 2 * i /8),center.y + (kCircleRaduis + shapLayer.lineWidth) * cos( M_PI * 2 *i/8));
        
        //2.计算终点
        CGPoint endPoint = CGPointMake(center.x + (kCircleRaduis + shapLayer.lineWidth + kLineHeight) * sin( M_PI * 2 *i/8) , center.y + (kCircleRaduis + shapLayer.lineWidth + kLineHeight) * cos( M_PI * 2 *i/8) );
        
        [bezierPath moveToPoint:startPoint];
        [bezierPath addLineToPoint:endPoint];
    }
    self.circleLayer.path = bezierPath.CGPath;
    
}

-(void)setState:(MJRefreshState)state{
    [super setState:state];
    if (state == MJRefreshStatePulling) {
        CGFloat offset = -self.scrollView.contentOffset.y;
        
    }else if (state == MJRefreshStateRefreshing){
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//        animation.duration = 1.0;
//        animation.repeatCount = CGFLOAT_MAX;
//        animation.removedOnCompletion = NO;
//        animation.fillMode = kCAFillModeForwards;
//        [self.circleLayer addAnimation:animation forKey:nil];
    }
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    NSLog(@"LBLog scrollViewContentOffsetDidChange %@ ",change);
    CGFloat offset = -[change[@"new"] CGPointValue].y;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(kScreenWidth, 0)];
    //1.小于一百
    if (offset <= kRefreshMargin && self.state == MJRefreshStateIdle) {
        [bezierPath addLineToPoint:CGPointMake(kScreenWidth, offset)];
        [bezierPath addLineToPoint:CGPointMake(0, offset)];
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        //小于这个值的时候一点一点增加进度
        self.circleLayer.strokeEnd = offset/kRefreshMargin;
        [CATransaction commit];
        
    }
    //大于100 太阳一直存在
    else if(offset > kRefreshMargin  || self.state == MJRefreshStateRefreshing){
        NSLog(@"LBLog offset is %f ",offset);
        self.circleLayer.strokeEnd = 1.0;
        //做太阳转圈的动画
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.circleLayer.affineTransform = CGAffineTransformMakeRotation(M_PI * 2 * offset/50);
        [CATransaction commit];
        
        //做底下弧形的形状
        [bezierPath  addLineToPoint:CGPointMake(kScreenWidth, kRefreshMargin)];
        [bezierPath addQuadCurveToPoint:CGPointMake(0, kRefreshMargin) controlPoint:CGPointMake(kScreenWidth/2, kRefreshMargin)];
    }
    
    
    //路径闭合
    [bezierPath closePath];
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.path = bezierPath.CGPath;
}



+(Class)layerClass{
    return [CAShapeLayer class];
}

-(CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc] init];
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = [UIColor redColor].CGColor;
        _circleLayer.lineWidth = 3;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.frame = self.bounds;
    }
    return _circleLayer;
}

@end
