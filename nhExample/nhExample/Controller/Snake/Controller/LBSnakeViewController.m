//
//  LBSnakeViewController.m
//  nhExample
//
//  Created by liubin on 17/5/2.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBSnakeViewController.h"
#import "LBSnakeModel.h"
#import "LBSnakeNode.h"

@interface LBSnakeViewController ()

@property (nonatomic, strong) LBSnakeModel *snake;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LBSnakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSnake];
    [self createFoodRandom];
    [self snakeWalking];
}

/** 随机一个food */
-(void)createFoodRandom{
    //实物的区域 5 5  Kscreenwidth-5  Kscreenwidth - 100
    NSInteger rowColumn = ((kScreenWidth - 10)/kSnakeWidth);
    NSInteger colColumn = (kScreenHeight - 100 - 64)/kSnakeWidth;
    NSInteger foodX = arc4random()%rowColumn * kSnakeWidth ;
    NSInteger foodY = arc4random()%colColumn *kSnakeWidth;
    
    //判断food是不是在蛇身上
    for (LBSnakeNode *node in self.snake.snakeNodesArray) {
        if (CGPointEqualToPoint(node.nodeCenter, CGPointMake(foodX+kSnakeWidth/2, foodY+kSnakeWidth/22))) {
            [self createSnake];
            return;
        }
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor greenColor];
    view.frame = CGRectMake(foodX, foodY, kSnakeWidth, kSnakeWidth);
    [self.view addSubview:view];
}

/** 随机创建一个snake */
-(void)createSnake{
    LBSnakeNode *firstNode = [[LBSnakeNode alloc] init];
    firstNode.nodeCenter = CGPointMake(10*kSnakeWidth +kSnakeWidth/2, 8*kSnakeWidth + kSnakeWidth/2);
    LBSnakeNode *secondNode = [[LBSnakeNode alloc] init];
    secondNode.nodeCenter = CGPointMake(11*kSnakeWidth +kSnakeWidth/2, 8*kSnakeWidth + kSnakeWidth/2);
    _snake = [[LBSnakeModel alloc] init];
    _snake.snakeNodesArray = @[firstNode,secondNode].mutableCopy;
    _snake.directionType = arc4random()%4;
}

/** 蛇开始走的 */
-(void)snakeWalking{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(refreshSnake) userInfo:nil repeats:YES];
}

/** 刷新蛇的位子 */
-(void)refreshSnake{
    //1.取出最后一个位子  赋值给第一个用的
    LBSnakeNode *node = self.snake.snakeNodesArray.lastObject;
    CGPoint firstCenter = self.snake.snakeNodesArray.firstObject.nodeCenter;
    switch (self.snake.directionType) {
        case LBSnakeDirectionUp:
            //向上时  上移一个node的高度
            firstCenter.y -=kSnakeWidth;
            break;
        case LBSnakeDirectionDown:
            //向下时  下移一个node的高度
            firstCenter.y +=kSnakeWidth;
            break;
        case LBSnakeDirectionLeft:
            //向左时  左移一个node的高度
            firstCenter.x -=kSnakeWidth;
            break;
        case LBSnakeDirectionRight:
            //向右时  上移一个node的高度
            firstCenter.x -=kSnakeWidth;
            break;
            
        default:
            break;
    }
    
    //移除最后一个node
    [self.snake.snakeNodesArray removeLastObject];
    node.nodeCenter = firstCenter;
    //添加到第一个
    [self.snake.snakeNodesArray insertObject:node atIndex:0];
    
    /** 化蛇 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self drawSnake];
    });
    
    
    //判断是否撞墙 以及吃到自己
    if ([self isDead]) {
        MyLog(@"LBLog snake is die ===============");
        [self stopTimer];
    }
    
}

/** 画蛇 */
-(void)drawSnake{
    
    /** 需要重新拷贝个数组出来   不然一边便利一边修改会报错 self.view.subviews除外*/
//    for(UIView *view in self.view.subviews){
//        [view removeFromSuperview];
//    }
//    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
    
    //第一种拷贝一个数组=出来
    NSArray *array = self.view.layer.sublayers;
//    NSArray *copyArray = [NSArray arrayWithArray:array];
    NSArray *copyArray = array.mutableCopy;

    for (CAShapeLayer *layer in copyArray) {
        [layer removeFromSuperlayer];
    }
    
    //第二种  利用系统的API
//    [self.view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (int i=0; i<self.snake.snakeNodesArray.count; i++) {
        LBSnakeNode *node = self.snake.snakeNodesArray[i];
        UIBezierPath *bezierPath = nil;
        if (i==0) {
            bezierPath= [UIBezierPath bezierPathWithArcCenter:node.nodeCenter radius:kSnakeWidth/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        }else{
            bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(node.nodeCenter.x - kSnakeWidth/2, node.nodeCenter.y - kSnakeWidth/2, kSnakeWidth, kSnakeWidth)];
        }
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.fillColor = [UIColor redColor].CGColor;
        layer.path = bezierPath.CGPath;
        [self.view.layer addSublayer:layer];
    }
}

/** 检测是否死亡的方法 */
-(BOOL)isDead{
    //1.第一种  撞墙
    LBSnakeNode *firstNode = self.snake.snakeNodesArray.firstObject;
    if (firstNode.nodeCenter.x< kSnakeWidth/2 || firstNode.nodeCenter.x >(kScreenWidth - kSnakeWidth/2) || firstNode.nodeCenter.y < kSnakeWidth/2 || (firstNode.nodeCenter.y > (kScreenHeight - 100 - 64 -kScreenWidth/2))) {
        return YES;
    }
    //第二种  吃到自己
    for (int i =1; i<self.snake.snakeNodesArray.count -1; i++) {
        LBSnakeNode *node = self.snake.snakeNodesArray[i];
        if (CGPointEqualToPoint(firstNode.nodeCenter, node.nodeCenter)) {
            return YES;
        }
    }
    
//    CGPointEqualToPoint(<#CGPoint point1#>, <#CGPoint point2#>)
    
    return NO;
}

-(void)stopTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)startTimer{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(refreshSnake) userInfo:nil repeats:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
