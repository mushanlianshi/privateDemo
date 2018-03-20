//
//  LBCustomSlideViewController.m
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomSlideViewController.h"

@interface LBCustomSlideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger childsCount;

@end

@implementation LBCustomSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadSlideVC{
    if ([self.dataSource respondsToSelector:@selector(numbersOfChildViewControllerInSlideController:)]) {
        self.childsCount = [self.dataSource numbersOfChildViewControllerInSlideController:self];
    }
    if (!self.childsCount) return;
    for (int i =0 ; i<self.childsCount; i++) {
        if ([self.dataSource respondsToSelector:@selector(slideViewController:viewControllerAtIndex:)]) {
            UIViewController *vc = [self.dataSource slideViewController:self viewControllerAtIndex:i];
            [self addChildViewController:vc];
            [self.scrollView addSubview:vc.view];
            if (self.view.width == 0) return;
            vc.view.frame = CGRectMake(i*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
        }
    }
//    self.scrollView.frame = self.view.bounds;
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.childsCount, self.scrollView.height);
    NSLog(@"SlideController view frame is %@ ",NSStringFromCGRect(self.scrollView.frame));
    NSLog(@"SlideController view contentSize is %@ ",NSStringFromCGSize(self.scrollView.contentSize));
}


/**
 * 设置索引对应的controller显示
 */
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*selectedIndex, 0) animated:YES];
}

/** 重写方法  计算scrollview的位置 contentSize */
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.view.width == 0) return;
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*self.childViewControllers.count, self.scrollView.height);
//    NSLog(@"self.childControler %@ ",self.childViewControllers);
    for (int i = 0; i<self.childViewControllers.count; i++) {
        UIViewController *vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(i*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
    }
    
}


-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark  scrollview delegate
//scrollview 滚动的方法
-(void)scrollViewDidScroll:(UIScrollView *)mscrollView{
//     NSLog(@"lblog scrollViewDidScroll dealloc===========");
//    CGPoint point=mscrollView.contentOffset;
}
//开始拽动的时候停止计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"lblog scrollViewWillBeginDragging dealloc===========");
}
//结束拽动的时候开始计时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"lblog scrollViewDidEndDragging dealloc===========");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    if ([self.delegate respondsToSelector:@selector(slideViewController:slideIndex:)]) {
        NSLog(@"滚动到第%ld 个controller ",index);
        [self.delegate slideViewController:self slideIndex:index];
    }
}


@end
