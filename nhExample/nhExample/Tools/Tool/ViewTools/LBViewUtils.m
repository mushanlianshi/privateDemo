//
//  LBViewUtils.m
//  nhExample
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBViewUtils.h"
#import "MJRefresh.h"
@implementation LBViewUtils

+(void)addPullRefreshToScrollView:(UIScrollView *)scrollView pullRefreshHandler:(dispatch_block_t)pullRefreshHnadler{
    if (scrollView == nil || pullRefreshHnadler == nil) return;
    LBRefreshCustomHeader *header =[LBRefreshCustomHeader headerWithRefreshingBlock:^{
        if (pullRefreshHnadler) {
            pullRefreshHnadler();
        }
    }];
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if (pullRefreshHnadler) {
//            pullRefreshHnadler();
//        }
//    }];
//    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
//    [header setTitle:@"正在更新" forState:MJRefreshStateRefreshing];
//    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//    header.stateLabel.font = [UIFont systemFontOfSize:13];
//    header.stateLabel.textColor = kCommonBlackColor;
//    //隐藏显示时间的
//    header.lastUpdatedTimeLabel.hidden = YES;
    scrollView.mj_header = header;
}

+(void)addPushLoadMoreToScrollView:(UIScrollView *)scrollView loadMoreHandler:(dispatch_block_t)loadMoreHandler{
    if (scrollView == nil || loadMoreHandler == nil) return;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (loadMoreHandler) {
            loadMoreHandler();
        }
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"内涵正在为您加载数据" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了~" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = kRGBColor(90, 90, 90);
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    scrollView.mj_footer = footer;
}


/**
 * 停止下拉刷新
 */
+(void)endPullRefreshScrollView:(UIScrollView *)scrollView{
    [scrollView.mj_header endRefreshing];
}

/**
 * 停止上啦加载
 */
+(void)endPushLoadMoreScrollView:(UIScrollView *)scrollView{
    [scrollView.mj_footer endRefreshing];
}

+(void)hiddenRefreshHeaderScrollView:(UIScrollView *)scrollView{
    scrollView.mj_header.hidden = YES;
}

/**
 隐藏上啦加载控件
 */
+(void)hiddenLoadMoreFooterScrollView:(UIScrollView *)scrollView{
    scrollView.mj_footer.hidden = YES;
}


/**
 提示没有更多数据加载
 */
+(void)noticeNoMoreDataForScrollView:(UIScrollView *)scrollView{
    [scrollView.mj_footer endRefreshingWithNoMoreData];
}

+(BOOL)isHeaderRefreshScrollView:(UIScrollView *)scrollView{
    return scrollView.mj_header.isRefreshing;
}

/**
 判断底部是否正在加载更多
 */
+(BOOL)isFooterLoadMoreScrollView:(UIScrollView *)scrollView{
    return scrollView.mj_footer.isRefreshing;
}


+(void)showRefreshInfo:(NSString *)info superView:(UIView *)superView belowView:(UIView *)belowView{
    UIButton *button=[[UIButton alloc] init];
    [button setBackgroundColor:[UIColor colorWithRed:0.92 green:0.53 blue:0.24 alpha:1.00]];
    button.userInteractionEnabled=NO;
    NSString *title=info;
    [button setTitle:title forState:UIControlStateNormal];
    button.frame=CGRectMake(0, -64, kScreenWidth, 35);
    //    [self.navigationController.navigationBar addSubview:button];
    [superView addSubview:button];
    [superView insertSubview:button belowSubview:belowView];
    CGFloat duration=0.5;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        button.transform=CGAffineTransformMakeTranslation(0, 64);
    } completion:^(BOOL finish){
        [UIView animateWithDuration:duration delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            button.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finish){
            [button removeFromSuperview];
        }];
    }];
}

/** 获取当前正在显示的控制器 */
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
