//
//  LBCustomPageControl.m
//  nhExample
//
//  Created by liubin on 17/4/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomPageControl.h"
@interface LBCustomPageControl ()
#define kOrangeColor [UIColor orangeColor]
#define kRedColor [UIColor redColor]

/** 选中显示的layer */
@property (nonatomic, strong) CAShapeLayer *selectedLayer;

/** 底部正常显示的layer */
@property (nonatomic, strong) CAShapeLayer *showLayer;

/** 用来记录上次移动的path  用来做动画用 */
@property (nonatomic, strong) UIBezierPath *selectedPath;

@end

@implementation LBCustomPageControl


+(instancetype)pageControl{
    return [[self alloc] init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化默认的值
        _pageSpace = 5;
        _pageWidth = 20;
        _pageHeight = 5;
        _normalItemColor = kOrangeColor;
        _selectedItemColor = kRedColor;
        _numberOfItems = 0;
    }
    return self;
}

/** 调整layer的位置 */
-(void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    [self.layer insertSublayer:self.selectedLayer above:self.showLayer];
}


-(void)setCurrentIndex:(NSInteger)currentIndex{
//    NSLog(@"setcurrentIndex ====== %d ",currentIndex);
    _currentIndex = currentIndex;
    //这个path用来做动画的
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(currentIndex*(_pageWidth+_pageSpace), 5)];
    [path addLineToPoint:CGPointMake((currentIndex + 1)*_pageWidth + _pageSpace*currentIndex, 5)];
    
    //path 动画
    CGFloat duration = 1.f;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    animation.fromValue = (__bridge id _Nullable)(self.selectedPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(path.CGPath);
    
    [self.selectedLayer addAnimation:animation forKey:@""];
    //记录动画的path
    self.selectedPath = path;
}

-(void)setNumberOfItems:(NSInteger)numberOfItems{
    _numberOfItems = numberOfItems;
    //如果默认的大于设置的宽度 调整下位置
    if (self.pageWidth*numberOfItems + self.pageSpace *(numberOfItems-1)>self.width) {
        self.pageWidth = (self.width - self.pageSpace*(numberOfItems - 1))/numberOfItems;
    }
    CGFloat originalX = 0;
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 内容充不满，需要靠右边对齐
//    CGFloat offset = self.width - self.pageWidth *self.numberOfItems - self.pageSpace*(self.numberOfItems-1);
    for (int i =0 ; i<self.numberOfItems; i++) {
        originalX = i*(_pageWidth + _pageSpace);
        // 移动path到某一点
        [path moveToPoint:CGPointMake(originalX, 5)];
        //开始画线
        [path addLineToPoint:CGPointMake(originalX+_pageWidth, _pageHeight)];
        path.lineWidth = _pageHeight;
        if (i == 0) {
            //默认第一个选中
            self.selectedPath = path;
            self.selectedLayer.path = self.selectedPath.CGPath;
        }
    }
    //设置默认选中的layer
    self.showLayer.path = path.CGPath;
}


-(void)setSelectedItemColor:(UIColor *)selectedItemColor{
    _selectedItemColor = selectedItemColor;
    self.selectedLayer.strokeColor = _selectedItemColor.CGColor;
}

-(void)setNormalItemColor:(UIColor *)normalItemColor{
    _normalItemColor = normalItemColor;
    self.showLayer.strokeColor = _normalItemColor.CGColor;
}

-(CAShapeLayer *)showLayer{
    if (!_showLayer) {
        _showLayer = [[CAShapeLayer alloc] init];
        _showLayer.strokeColor = self.normalItemColor.CGColor;
        _showLayer.lineWidth = 5;
        [self.layer addSublayer:_showLayer];
    }
    return _showLayer;
}

-(CAShapeLayer *)selectedLayer{
    if (!_selectedLayer) {
        _selectedLayer = [[CAShapeLayer alloc] init];
        //画线的颜色
        _selectedLayer.strokeColor = self.selectedItemColor.CGColor;
        _selectedLayer.lineWidth = 5;
        [self.layer addSublayer:_selectedLayer];
    }
    return _selectedLayer;
}

@end
