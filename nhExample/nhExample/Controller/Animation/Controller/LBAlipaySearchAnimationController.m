//
//  LBAlipaySearchAnimationController.m
//  nhExample
//
//  Created by liubin on 17/5/2.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBAlipaySearchAnimationController.h"
#import "LBAlipaySearchCircleView.h"

@interface LBAlipaySearchAnimationController ()<CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray *circleViewsArray;

@property (nonatomic, strong) UILabel *searchLabel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LBAlipaySearchAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索";
    [self startAnimations];
}

-(void)startAnimations{
    [self.searchLabel.layer addAnimation:[self opacityAnimationForEver:0.5] forKey:nil];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(addCircleViews) userInfo:nil repeats:YES];
}



-(void)addCircleViews{
    LBAlipaySearchCircleView *circleView = [[LBAlipaySearchCircleView alloc] init];
    circleView.frame = CGRectMake(30, 60, kScreenWidth - 60, kScreenWidth - 60);
    [circleView.layer addAnimation:[self transfromAnimationGroup] forKey:@"circleViewAnimation"];
    circleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:circleView];
    //添加到数组中管理  是为了移除时用的
    [self.circleViewsArray addObject:circleView];
}
-(CAAnimation *)transfromAnimationGroup{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.f];
    animation.toValue = [NSNumber numberWithFloat:5.f];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(1);
    opacity.toValue = @(0);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,opacity];
    group.duration = 4;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = 1.f;
    //设置代理是为了让动画结束的时候 移除view
    group.delegate = self;
    return group;
}

/** 获取一个opacity的动画 */
-(CAAnimation *)opacityAnimationForEver:(CGFloat)time{
    /** 用opacity来实例化一个动画 */
    /*!
     1.opacity 透明度
     2.transform ：翻页，渐变，上，下拉进，拉出的效果
     3.bounds：变大变小
     4.position：位置
     */
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.f];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.duration = time;
    animation.repeatCount = CGFLOAT_MAX;
    // 3.动画结束时是否执行逆动画
    animation.autoreverses = YES;
    //设置动画做完保持动画状态  以免又回到最初的样子
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 4.设置动画的速度变化
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}

#pragma mark animation delegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.circleViewsArray.firstObject) {
        LBAlipaySearchCircleView *circleView = (LBAlipaySearchCircleView *)self.circleViewsArray.firstObject;
        [circleView removeFromSuperview];
        [self.circleViewsArray removeObjectAtIndex:0];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    __block UIImageView *lastView;
    //模拟网络数据   3秒后添加搜索到的好友
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0; i<5; i++) {
            UIImageView *iv = [[UIImageView alloc] init];
            iv.bounds = CGRectMake(0, 0, 40, 40);
            NSString *imageName = [NSString  stringWithFormat:@"icon_%d",i];
            iv.image = ImageNamed(imageName);
            iv.layerCornerRadius = 20;
            //1.随机一个角度
            int  jiaodu = arc4random()%360;
            //2.计算半径
            int raduis = (kScreenWidth - 60)/2;
            iv.tag = i;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firendsIconClicked:)];
            iv.userInteractionEnabled = YES;
            [iv addGestureRecognizer:tap];
            
            CGFloat centerX = self.view.center.x + raduis*cos(jiaodu*M_PI/180);
            CGFloat centerY = 60+(kScreenWidth - 60)/2 +raduis*sin(jiaodu*M_PI/180);
            MyLog(@"LBlog jiaodu %d %f %f ",jiaodu,centerX,centerY);
            iv.center = CGPointMake(centerX, centerY);
//            if (lastView) {
//                //保证两个离得距离开一些
//                if (fabsf(centerX - lastView.centerX)< 40 || fabsf(centerY-lastView.centerY)) {
//                    iv.center = CGPointMake(centerX+40, centerY+40);
//                }
//            }
            [self.view addSubview:iv];
            lastView = iv;
        }
    });
}

#pragma mark 搜索到的好友呗点击了
-(void)firendsIconClicked:(UITapGestureRecognizer *)tapGesture{
    UIImageView *iv = (UIImageView *)[tapGesture view];
    MyLog(@"LBLog clicked index is %d ",iv.tag);
}

-(void)viewWillDisappear:(BOOL)animated{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 懒加载view
-(UILabel *)searchLabel{
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.textAlignment = NSTextAlignmentCenter;
        _searchLabel.textColor = [UIColor redColor];
        _searchLabel.text = @"正在搜索附近的人...";
        _searchLabel.frame = CGRectMake(0, 20, kScreenWidth, 30);
//        _searchLabel.backgroundColor = [UIColor colorWithRed:255.0/231 green:255.0/231 blue:255.0/233 alpha:1.0];
        [self.view addSubview:_searchLabel];
    }
    return _searchLabel;
}

-(NSMutableArray *)circleViewsArray{
    if (!_circleViewsArray) {
        _circleViewsArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _circleViewsArray;
}

-(void)dealloc{
    MyLog(@"LBLog %@ dealloc ",NSStringFromClass([self class]));
}

@end
