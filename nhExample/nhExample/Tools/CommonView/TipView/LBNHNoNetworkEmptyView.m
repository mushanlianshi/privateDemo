//
//  LBNHNoNetworkEmptyView.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHNoNetworkEmptyView.h"


@interface LBNHNoNetworkEmptyView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *loadButton;

@end

@implementation LBNHNoNetworkEmptyView

-(instancetype)init{
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = kCommonBgColor;
        [self addSubview:_imageView];
        
        _loadButton = [[UIButton alloc] init];
        [_loadButton setTitle:@"请检查网络设置" forState:UIControlStateNormal];
        [_loadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loadButton addTarget:self action:@selector(retryButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loadButton];
    }
    return self;
}

-(void)showInSuperview:(UIView *)superView{
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    [superView addSubview:self];
    self.frame = superView.bounds;
    _imageView.frame = self.bounds;
    [_loadButton sizeToFit];
    self.loadButton.center = self.center;
    
}

-(void)dismiss{
    [self.imageView removeFromSuperview];
    [self.loadButton removeFromSuperview];
    [self removeFromSuperview];
}

-(void)retryButtonClicked{
    if (self.retryHandle) {
        self.retryHandle(self);
    }
}


@end
