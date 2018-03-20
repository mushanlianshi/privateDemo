//
//  LBAnimationController.m
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBAnimationController.h"
#import "UIView+LBTap.h"
#import "LBGCDUtils.h"
#import "LBCustomProgressView.h"

@interface LBAnimationController ()

@end

@implementation LBAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"动画";
    //翻转
    [self initFlipView];
    //转场
    [self initCurlView];
    //旋转
    [self initRotateView];
    //画一个圆
    [self initCircleView];
    
    //动态的创建一个圆
    [self animationCreateCircle];
    
    //缩放动画
    [self initScaleView];
    //画一条虚线
    [self drawDottedLine];
    //画火柴人
    [self drawFireMan];
    
    [self drawColorProgressBar];
}

/** 翻转动画 */
-(void)initFlipView{
    __block UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = ImageNamed(@"digupicon_review_press_1");
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
//        make.centerX.mas_equalTo(self.view.centerX).offset(-kScreenWidth/4);
        make.left.offset((kScreenWidth - 55*3)/4);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = kFont(14);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"翻转" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(imageView.mas_bottom).offset(5);
    }];
    [button addTapBlock:^{
        //UIView 自带动画  从左侧翻转 显示另外一张图片
        [UIView transitionWithView:imageView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            imageView.image = ImageNamed(@"digdownicon_review_press_1");
        } completion:^(BOOL finished) {
            /** 左翻转动画 结束后， 停 1 秒后，再执行 右翻转动画 */
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //从右侧翻转 显示最初的图片  完成动画
                [UIView transitionWithView:imageView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                    imageView.image = ImageNamed(@"digupicon_review_press_1");
                } completion:^(BOOL finished) {
                    
                }];
            });
        }];
    }];
}

/** 转场动画  必须和转场代码写在一起 否则无效 */
bool isPositiveSide = false;
-(void)initCurlView{
    
    __block UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = ImageNamed(@"digupicon_review_press_1");
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = kFont(14);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"转场" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(imageView.mas_bottom).offset(5);
    }];
    [button addTapBlock:^{
//        if (isPositiveSide) {
//            imageView.image = ImageNamed(@"digupicon_review_press_1");
//        }else{
//            imageView.image = ImageNamed(@"digdownicon_review_press_1");
//        }
        
        CATransition *animation = [[CATransition alloc] init];
        animation.duration = 2.0;
        //设置转场的类型
        animation.type =  @"pageCurl";
        //设置动画方向
        animation.subtype = kCATransitionFromLeft;
        animation.removedOnCompletion = YES;
        [imageView.layer addAnimation:animation forKey:nil];
        isPositiveSide = !isPositiveSide;
    }];
    
    
}

-(void)initRotateView{
    WS(weakSelf);
    __block UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = ImageNamed(@"digupicon_review_press_1");
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
//        make.centerX.mas_equalTo(self.view.centerX).offset(kScreenWidth/4);
        make.right.offset(-(kScreenWidth - 55*3)/4);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = kFont(14);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"旋转" forState:UIControlStateNormal];
    [weakSelf.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(imageView.mas_bottom).offset(5);
    }];
    
    [button addTapBlock:^{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 2.f;
        //旋转360 一圈
        animation.toValue = [NSNumber numberWithDouble:M_PI*2];
        animation.cumulative = YES;
        animation.removedOnCompletion = YES;
        [imageView.layer addAnimation:animation forKey:nil];
    }];
}

/** 用贝塞尔曲线换一个园 */
-(void)initCircleView{
    
    WS(weakSelf);
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = kFont(14);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"画圆" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(180);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
    }];
    
    
    
    [button addTapBlock:^{
        CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
        shapLayer.frame = CGRectMake(10, 110, 60, 60);
        shapLayer.fillColor = [UIColor clearColor].CGColor;
        //设置线条的宽度和颜色
        shapLayer.lineWidth = 1;
        //画笔的颜色
        shapLayer.strokeColor = [UIColor redColor].CGColor;
        //创建贝塞尔曲线 起始路径  结束路径
//        UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 0, 0)];
        UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 60, 60)];
        shapLayer.path = endPath.CGPath;
        [weakSelf.view.layer addSublayer:shapLayer];
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
//        animation.duration = 2.0;
//        animation.fillMode = kCAFillModeForwards;
//        animation.fromValue = (__bridge id _Nullable)startPath.CGPath;
//        animation.toValue = (__bridge id _Nullable)endPath.CGPath;
//        animation.removedOnCompletion = NO;
//        [shapLayer addAnimation:animation forKey:nil];
    }];
    
}

/** 动态的画圆 */
-(void)animationCreateCircle{
    WS(weakSelf);
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = kFont(14);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"开始画圆" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(90);
        make.top.offset(180);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
    }];
    [button addTapBlock:^{
        __block CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
        shapLayer.frame = CGRectMake(90, 110, 60, 60);
        shapLayer.fillColor = [UIColor clearColor].CGColor;
        //设置线条的宽度和颜色
        shapLayer.lineWidth = 1;
        //画笔的颜色
        shapLayer.strokeColor = [UIColor redColor].CGColor;
        shapLayer.strokeStart = 0;
        shapLayer.strokeEnd = 0;
        //创建一个圆的路径
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 60, 60)];
        shapLayer.path = circlePath.CGPath;
        [weakSelf.view.layer addSublayer:shapLayer];
        
        //逐渐改变strokeEnd结束的位置   实现一个动画效果
        [LBGCDUtils GCDTimer:1.0 offsetTime:0.05 queue:dispatch_get_main_queue() block:^{
            shapLayer.strokeEnd +=0.05;
            MyLog(@"GCD shapLayer strokeEnd is  %f ",shapLayer.strokeEnd);
        }];
        
    }];
}

/** 缩放动画 */
-(void)initScaleView{
    
    __block UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = ImageNamed(@"digupicon_review_press_1");
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(110);
        //        make.centerX.mas_equalTo(self.view.centerX).offset(kScreenWidth/4);
        make.left.offset(170);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = kFont(14);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"开始画圆" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(170);
        make.top.offset(180);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
    }];
    
    [button addTapBlock:^{
        //第一种  用UIView的动画方法
//        [UIView animateWithDuration:1.f animations:^{
//            CGRect frame = imageView.frame;
//            frame.size = CGSizeMake(frame.size.width +10, frame.size.height+10);
//            imageView.frame = frame;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:1.f animations:^{
//                CGRect frame = imageView.frame;
//                frame.size = CGSizeMake(frame.size.width -10, frame.size.height-10);
//                imageView.frame = frame;
//            } completion:^(BOOL finished) {
//                
//            }];
//        }];
//        return ;
        //第二种   用animation的scale
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 1.f;
        animation.fromValue = [NSNumber numberWithFloat:1.f];
        animation.toValue = [NSNumber numberWithFloat:1.2f];
        //fillMode 默认kCAFillModeRemoved  设置kCAFillModeForwards 加不移除 才会保持动画后的状态
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        [imageView.layer addAnimation:animation forKey:nil];
        
        
        CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        endAnimation.duration = 1.f;
        endAnimation.fromValue = [NSNumber numberWithFloat:1.2f];
        endAnimation.toValue = [NSNumber numberWithFloat:1.f];
        //下面两行一起才保证保留动画后的状态
        endAnimation.fillMode = kCAFillModeForwards;
        endAnimation.removedOnCompletion = NO;
        [LBGCDUtils GCDAfterTime:1.f queue:nil block:^{
            [imageView.layer addAnimation:endAnimation forKey:nil];
        }];
    }];
}

-(void)drawDottedLine{
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = kFont(14);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"开始画虚线" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(250);
        make.top.offset(180);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
    }];
    
    WS(weakSelf);
    [button addTapBlock:^{
        CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
        shapLayer.frame = CGRectMake(250, 110, 60, 60);
        shapLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//        shapLayer.fillColor = [UIColor blueColor].CGColor;
        //设置画笔的颜色
//        shapLayer.strokeColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f].CGColor;
        shapLayer.strokeColor = [UIColor redColor].CGColor;
        shapLayer.lineWidth = 1.f;
        shapLayer.lineJoin = kCALineJoinRound;
        
        //设置线的长度10  间隔5
        [shapLayer setLineDashPattern:@[[NSNumber numberWithInt:5],[NSNumber numberWithInt:2]]];
        
        //设置路径
        CGMutablePathRef path = CGPathCreateMutable();
        //移到shap的中间开始画
        CGPathMoveToPoint(path, NULL, 0, 30);
        //添加线到右边点
//        __block int width =10;
//        __block dispatch_source_t source = [LBGCDUtils GCDInterValTimer:0.2 queue:nil block:^{
//            CGPathAddLineToPoint(path, NULL, width, 30);
//            MyLog(@"CGD width is %d ",width);
//            width +=10;
//            if (width >= 70) {
//                dispatch_source_cancel(source);
//                CGPathRelease(path);
//            }
//        }];
        CGPathAddLineToPoint(path, NULL, 60, 30);
        shapLayer.path = path;
        CGPathRelease(path);
        //释放路径对象
        [weakSelf.view.layer addSublayer:shapLayer];
    }];
    
    
}

-(void)drawFireMan{
    WS(weakSelf);
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"火柴人" forState:UIControlStateNormal];
    button.titleLabel.font = kFont(14);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTapBlock:^{
        UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
        [bezierPath addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:M_PI*2 clockwise:YES];//画圆 O
        [bezierPath moveToPoint:CGPointMake(150, 125)];//移动到圆正下边 准备划线
        [bezierPath addLineToPoint:CGPointMake(150, 175)];//画竖线 |
        [bezierPath addLineToPoint:CGPointMake(125, 225)];//画反的斜线/
        [bezierPath moveToPoint:CGPointMake(150, 175)];//移动到竖线的下面
        [bezierPath addLineToPoint:CGPointMake(175, 225)];//画\
       
        [bezierPath moveToPoint:CGPointMake(100, 150)];//移动到一横的开始点
        [bezierPath addLineToPoint:CGPointMake(200, 150)];//画一横--
        
        CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
        shapLayer.frame = self.view.bounds;
        shapLayer.fillColor = [UIColor clearColor].CGColor;
        shapLayer.strokeColor = kCommonTintColor.CGColor;
        shapLayer.lineWidth = 5;
        shapLayer.lineJoin = kCALineJoinRound;
        shapLayer.lineCap = kCALineCapRound;
        shapLayer.path = bezierPath.CGPath;
//        shapLayer.fillMode =
        [weakSelf.view.layer addSublayer:shapLayer];
        
        
    }];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.offset(240);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark 画一个渐变色的progressbar
-(void)drawColorProgressBar{
    WS(weakSelf);
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"渐变色progress" forState:UIControlStateNormal];
    button.titleLabel.font = kFont(14);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTapBlock:^{
//        LBCustomProgressView *progressView = [[LBCustomProgressView alloc] initWithFrame:CGRectMake(110, 220, 60, 10)];
        LBCustomProgressView *progressView = [[LBCustomProgressView alloc] init];
        progressView.frame = CGRectMake(110, 220, 60, 10);
        progressView.tag = 1001;
        [progressView showRedBorder];
        [weakSelf.view addSubview:progressView];
        [weakSelf startProgress];
        
        //设置整体的背景色渐变
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0.0, 1.0);
        layer.colors = @[(id)[[UIColor redColor] colorWithAlphaComponent:0.5].CGColor,(id)[UIColor redColor].CGColor];
        //设置颜色分割点（范围：0-1） 默认均匀分布
//        layer.locations = @[@(0.5),@(1.0)];
        
        layer.frame = weakSelf.view.bounds;
        
//        [weakSelf.view.layer addSublayer:layer];
        [weakSelf.view.layer insertSublayer:layer atIndex:0];
        
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(110);
        make.top.offset(240);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
    }];
}

-(void)startProgress{
    LBCustomProgressView *progressView = [self.view viewWithTag:1001];
    progressView.progress +=0.1;
    if (progressView.progress == 1.0) {
        return;
    }
    [self performSelector:@selector(startProgress) withObject:nil afterDelay:0.3];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
