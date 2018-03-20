//
//  UIViewController+LBLoading.m
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "UIViewController+LBLoading.h"
#import <objc/runtime.h>


/**
 自定义loadingView
 */
@interface LBNHControllerLoadingView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UILabel *titleLabel;

-(void)startAnimation;
@end

@implementation LBNHControllerLoadingView


/**
 重新布局位置
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(self.width/2-20, self.height/2 -40, 120, 40);
    self.indicatorView.frame = CGRectMake(self.width/2-60, self.titleLabel.y, 40, 40);
}

-(void)startAnimation{
    [self.indicatorView startAnimating];
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"正在加载...";
        _titleLabel.textColor = kTextColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

@end


/** loadingview的key */
const static char loadingViewKey;

@implementation UIViewController (LBLoading)

/** 获取loadingview */
-(UIView *)loadingView{
    NSLog(@"LBLog loadingView address is %p ",&loadingViewKey);
    return objc_getAssociatedObject(self, &loadingViewKey);
}

-(void)setLoadingView:(UIView *)view{
    objc_setAssociatedObject(self, &loadingViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/** 显示loadingView */
-(void)showLoadingViewWithFrame:(CGRect)frame{
    if (!self.loadingView) {
        LBNHControllerLoadingView *loadingView = [[LBNHControllerLoadingView alloc] init];
        [self setLoadingView:loadingView];
        [self.view addSubview:loadingView];
        loadingView.frame = frame;
        loadingView.center = self.view.center;
        loadingView.centerY = self.view.centerY -50;
        [loadingView startAnimation];
    }
}

/**
 显示loadingView
 */
-(void)showLoadingView{
    [self showLoadingViewWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
}

/**
 隐藏显示的loadingView
 */
-(void)hiddenLoadingView{
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
    }
}

@end
