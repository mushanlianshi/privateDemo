//
//  LBBaseViewController.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBaseViewController.h"
#import "LBNHLoadingView.h"
#import "LBNHNoNetworkEmptyView.h"
#import "AFNetworkReachabilityManager.h"

@interface LBBaseViewController ()

@property (nonatomic, strong) LBNHLoadingView *loadingViewInner;

@property (nonatomic, strong) LBNHNoNetworkEmptyView *noNetworkEmptyView;

@end

@implementation LBBaseViewController


/**
 一般是home  discovery等界面的父VC 不需要显示导航栏
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIView setAnimationsEnabled:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


/**
 在viewDidload中检测发请求的通知   当请求成功的时候结束加载框
 */
-(void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataSucess) name:KLBNHLoadDataSucessNotification object:nil];
//    if (!self.isNetworkReachable) {
//        [self showLoadingAnimation];
//    }
}



-(void)loadDataSucess{
    [self hideLoadingAnimation];
}





/**
 pop到上一层
 */
-(void)pop{
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 pop到跟VC
 */
-(void)popToRootVc{
    if (self.navigationController != nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)popToVc:(UIViewController *)vc{
    if (![vc isKindOfClass:[UIViewController class]]) return;
    if (self.navigationController != nil) {
        [self.navigationController popToViewController:vc animated:YES];
    }
}

- (void)pushToVc:(UIViewController *)vc{
    if (![vc isKindOfClass:[UIViewController class]]) return;
    if (self.navigationController == nil ) return;
    if (vc.hidesBottomBarWhenPushed == NO) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissWithCompletion:(dispatch_block_t)completion{
    [self dismissViewControllerAnimated:YES completion:completion];
}



- (void)removeChildVc:(UIViewController *)childVc{
    if ([childVc isKindOfClass:[UIViewController class]] == NO) {
        return ;
    }
    [childVc.view removeFromSuperview];
    //当某个子视图控制器将从父视图控制器中删除时，parent参数为nil。
    [childVc willMoveToParentViewController:nil];
    [childVc removeFromParentViewController];
}

- (void)addChildVc:(UIViewController *)childVc{
    if ([childVc isKindOfClass:[UIViewController class]] == NO) {
        return ;
    }
    [childVc willMoveToParentViewController:self];
    [self addChildViewController:childVc];
    [self.view addSubview:childVc.view];
    childVc.view.frame = self.view.bounds;
}


/**
 重写方法 取消键盘第一响应
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/** 加载中*/
- (void)showLoadingAnimation{
    [self.loadingViewInner showInSuperview:self.view];
    [self.view bringSubviewToFront:_loadingViewInner];
}

/** 停止加载*/
- (void)hideLoadingAnimation{
    [self.loadingViewInner dismiss];
}

-(void)showNoNetworkEmptyView{
    [self.noNetworkEmptyView showInSuperview:self.view];
    self.noNetworkEmptyView.retryHandle = ^(LBNHNoNetworkEmptyView *view){
        [view dismiss];
    };
}

-(void)hideNoNetworkEmptyView{
    [self.noNetworkEmptyView dismiss];
}

/** 请求数据，交给子类去实现*/
- (void)loadData{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(LBNHNoNetworkEmptyView *)noNetworkEmptyView{
    if (!_noNetworkEmptyView) {
        _noNetworkEmptyView = [[LBNHNoNetworkEmptyView alloc] init];
    }
    return _noNetworkEmptyView;
}

-(LBNHLoadingView *)loadingViewInner{
    if (!_loadingViewInner) {
        _loadingViewInner = [[LBNHLoadingView alloc] init];
    }
    return _loadingViewInner;
}

-(BOOL)isNetworkReachable{
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    MyLog(@"LBLog %@  dealloc ==========",NSStringFromClass([self class]));
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if([self respondsToSelector:aSelector])
    {
        
        return self;
    }
    else
        return nil;
}

//-(id)forwardingTargetForSelector:(SEL)aSelectore{
//    id cls = [super forwardingTargetForSelector:aSelectore];
////#ifndef  DEBUG
//    if (!cls) {
//        return nil;
//    }
////#endif
//    return cls;
//}

@end
