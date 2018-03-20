//
//  LBCircleAnimationController.m
//  nhExample
//
//  Created by liubin on 17/4/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCircleAnimationController.h"
#import "LBCustomCircleAnimationView.h"

@interface LBCircleAnimationController ()

@end

@implementation LBCircleAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    LBCustomCircleAnimationView *circleView = [[LBCustomCircleAnimationView alloc] initWithCircleRaduis:440 centerPoint:CGPointMake(self.view.bounds.size.width/2, 0) outCircleImage:nil innerCircleImage:nil circleMargin:80];
    [circleView addSubViews:[self btnArrayCreat] showViewCount:4];
    [self.view addSubview:circleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///按钮数组
- (NSArray *)btnArrayCreat{
    
    NSMutableArray *btnArray = [NSMutableArray array];
    
    for (int i = 0; i < 7; i++) {
        LBButton *button=[[LBButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [button setImage:[UIImage imageNamed:@"digupicon_review_press_1"] forState:UIControlStateNormal];
        button.backgroundColor=[UIColor yellowColor];
        button.layer.cornerRadius= 60/2;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"第%d个",i + 1] forState:UIControlStateNormal];
        button.tag=100+i;
        [btnArray addObject:button];
    }
    
    return btnArray;
}
@end



@implementation LBButton

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return  CGRectMake(0, 0.6*self.frame.size.height, self.frame.size.width, 0.4*self.frame.size.height);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect frame = self.frame;
    CGFloat width = frame.size.height * 0.6;
    return CGRectMake(frame.size.height*0.2, 0, width, width);
}


@end
