//
//  LBCustomCircleAnimationView.m
//  nhExample
//
//  Created by liubin on 17/4/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomCircleAnimationView.h"

/** 其实位置距离两边的间距是10 */
const CGFloat kSideOffset = 10;

@interface LBCustomCircleAnimationView()

/** 外圆的imageview */
@property (nonatomic, strong) UIImageView *circleImageView;

/** 内园的iamgeview */
@property (nonatomic, strong) UIImageView *innerImageView;

/** 圆的半径 */
@property (nonatomic, assign) CGFloat raduis;

/** 记录圆的中心点的  */
@property (nonatomic, assign) CGPoint centerPoint;

/** 内外圆的间距 */
@property (nonatomic, assign) CGFloat circleMargin;

/** 子view显示的数组 */
@property (nonatomic, copy) NSArray *viewsArray;

/** 最多显示的个数 */
@property (nonatomic, assign) NSInteger showCount;

/** 手势开始的起点 */
@property (nonatomic, assign) CGPoint beginPoint;

/** 移动的距离 */
@property (nonatomic, assign) CGFloat moveDistance;

/** 记录旋转是否结束 用来判断是否做动画用的 */
@property (nonatomic, assign) BOOL isMoveEnd;

/** 第一个view相对于父控件的界面刚漏出的偏移量 */
@property (nonatomic, assign) CGFloat firstViewX;

/** 用来记录item之间的间距的 */
@property (nonatomic, assign) CGFloat itemMargin;
@end

@implementation LBCustomCircleAnimationView

-(instancetype)initWithCircleRaduis:(CGFloat)raduis centerPoint:(CGPoint)centerPoint outCircleImage:(UIImage *)outImage innerCircleImage:(UIImage *)innerImage circleMargin:(CGFloat)circleMargin{
    CGFloat xx = centerPoint.x -  raduis;
    CGFloat yy = centerPoint.y - raduis;
    self = [super initWithFrame:CGRectMake(xx, yy, raduis*2, raduis*2)];
    if (self) {
        self.raduis = raduis;
        self.circleMargin = circleMargin;
        self.centerPoint = centerPoint;
        
        self.circleImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.circleImageView.layerCornerRadius = raduis;
//        self.circleImageView.clipsToBounds = YES;
        self.circleImageView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.8];
        if (outImage) {
            self.circleImageView.image = outImage;
        }
        self.circleImageView.userInteractionEnabled = YES;
        [self addSubview:_circleImageView];
        
        self.innerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(circleMargin, circleMargin, (raduis - circleMargin) * 2, (raduis - circleMargin) * 2)];
        self.innerImageView.layerCornerRadius = (raduis - circleMargin);
//        self.innerImageView.clipsToBounds = YES;
        self.innerImageView.backgroundColor = [UIColor lightGrayColor];
        //让內圆接受事件  是为了内圈滑动无效
        _innerImageView.userInteractionEnabled = YES;
        if (innerImage) {
            self.innerImageView.image = innerImage;
        }
        [self addSubview:_innerImageView];
        
        UIPanGestureRecognizer *zhuanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(zhuanGestureHandler:)];
        [self.circleImageView addGestureRecognizer:zhuanGesture];
        
        self.firstViewX = raduis - centerPoint.x;
    }
    return self;
}

#pragma mark 旋转手势处理
-(void)zhuanGestureHandler:(UIPanGestureRecognizer *)zhuanGesture{
    UIView *view = [self.viewsArray objectAtIndex:0];
    MyLog(@"zhuanGestureHandler ========");
    if (zhuanGesture.state == UIGestureRecognizerStateBegan) {
        self.isMoveEnd = NO;
        self.beginPoint = [zhuanGesture locationInView:self];
    }else if (zhuanGesture.state == UIGestureRecognizerStateChanged){
        self.isMoveEnd = NO;
        CGPoint point = [zhuanGesture locationInView:self];
        CGFloat offsetX = point.x - _beginPoint.x;
        CGFloat offsetY = point.y - _beginPoint.y;
        CGFloat offset = sqrt((offsetX * offsetX) + (offsetY * offsetY));
        //右拉
        if (point.x > _beginPoint.x) {
            self.moveDistance +=offset;
        }else{
            self.moveDistance -=offset;
        }
        
//        self.moveDistance += offsetX;
        
        //1.计算左边第一个不要出界  因为moveDistance最初为0  移动的距离我们一直算着 所以保证不>0就可以了
        if (self.moveDistance >=0) {
            self.moveDistance = 0;
        }
        
        //2.计算右边最后一个不要出界
        //最后一个原来便宜的距离是
        CGFloat lastOffset = (self.viewsArray.count - self.showCount)*(kScreenWidth - 2*kSideOffset -view.width)/(self.showCount - 1);
        if (fabsf(self.moveDistance) > lastOffset) {
            self.moveDistance = -lastOffset;
        }
        
        NSLog(@"self.moveDistance is %f ",self.moveDistance);
        [self caculateSubviewsPosition];
        //赋值新的开始点
        self.beginPoint = point;
        
    }else if (zhuanGesture.state == UIGestureRecognizerStateEnded) {
        self.isMoveEnd = YES;
        // 计算结束的时候self.moveDistance该为多少才能保证布局和最初显示的一样  只是item换了
        for (int i =0 ; i<self.viewsArray.count - self.showCount + 1; i++) {
            UIView *view = self.viewsArray[i];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            CGRect rect = [view.superview convertRect:view.frame toView:window];
            MyLog(@"LBLog convert rect %@ ",NSStringFromCGRect(rect));
            //显示的第一个在窗口中的  只要漏出一半就保留显示
            if (rect.origin.x>-view.size.width/2) {
//                CGFloat orignalX = self.firstViewX + kSideOffset + self.itemMargin *i;
//                CGFloat newX = view.frame.origin.x;
                //始终保持 显示距离屏幕kSideOffset距离
                CGFloat offsetX = kSideOffset - rect.origin.x;
//                MyLog(@"LBLog convert rect orignalx %d  %f %f %f %f ",i,orignalX,newX,offsetX,self.moveDistance);
                self.moveDistance += offsetX ;
                MyLog(@"LBLog convert rect orignalx %f ",self.moveDistance);
                [self caculateSubviewsPosition];
                break;
            }
        }
    }
}

-(void)addSubViews:(NSArray *)views showViewCount:(NSInteger)showCount{
    if (!views.count) return;
    self.viewsArray = views;
    self.showCount = showCount ? showCount : 4;
    [self caculateSubviewsPosition];
}

/** 计算各个子view的位置 */
-(void)caculateSubviewsPosition{
    UIView *view = self.viewsArray[0];
    //获取第一个位置的子view的宽度  用来算view的位置的
    CGFloat viewWidth = view.width;
    CGFloat centerX = 0;
    CGFloat centerY = 0;
    //两个item之间的x方向的距离
    CGFloat centerMargin = (kScreenWidth - 2*kSideOffset - viewWidth/2 * 2)/(self.showCount - 1);
    self.itemMargin = centerMargin;
    for (int i = 0 ; i<self.viewsArray.count; i++) {
        centerX = self.firstViewX + kSideOffset + viewWidth/2 + centerMargin * i + self.moveDistance;
        //centerY 可根据半径和x位置来算出y的距离  半径是大小圆中间的半径 r*r = x*x + y*y; 注意在下半圆
        MyLog(@"LBlog === x  r %f %f %f ",centerX, (self.raduis - centerX),(self.raduis - self.circleMargin/2));
        centerY = sqrt((self.raduis - self.circleMargin/2)*(self.raduis - self.circleMargin/2) - (self.raduis - centerX)*(self.raduis - centerX)) + self.raduis;
        
        //需要处理 在內圆和外圆中间那圈圆的范围才显示  不然会出现centery为 nan  也就是超出了范围  因为我们的x是拿外圆算的 x不在中间圆上 在的是y  所以x方向不能超过中间的圈  不然y就出问题了
        if (centerX > self.circleMargin/2 && centerX < self.raduis*2 - self.circleMargin/2) {
            UIView *subView = self.viewsArray[i];
            
            MyLog(@"LBLog center x y %f %f ",centerX,centerY);
            [self addSubview:subView];
            if (self.isMoveEnd) {
                //拖动结束的时候 做动画
                [UIView animateWithDuration:0.4 animations:^{
                     subView.center = CGPointMake(centerX, centerY);
                } completion:^(BOOL finished) {
                  
                }];
            }else{
                //拖动的时候不做动画  直接移动
                subView.center = CGPointMake(centerX, centerY);
            }
        }
        
    }
    
}



@end
