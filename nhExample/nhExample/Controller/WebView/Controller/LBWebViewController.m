//
//  LBWebViewController.m
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBWebViewController.h"
#import "UIViewController+LBUtils.h"
#import "LBCustomNaviBar.h"
@interface LBWebViewController()<UIWebViewDelegate>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LBWebViewController

-(instancetype)initWithURLString:(NSString *)urlString title:(NSString *)title{
    return [self initWithURL:[NSURL URLWithString:urlString] title:title];
}

-(instancetype)initWithURL:(NSURL *)url title:(NSString *)title{
    self = [super init];
    if (self) {
        self.title = title;
        self.url = url;
    }
    return self;
}

-(void)viewDidLoad{
//    [self.webView showRedBorder];
    if ([self isBePushed]) {
        
    }else{
        LBCustomNaviBar *naviBar = [[LBCustomNaviBar alloc] initNaviBarLeftImage:ImageNamed(@"back_neihan") leftBlock:^{
            //设置模态退出时的动画
            [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            [self dismissViewControllerAnimated:YES completion:nil];
        } title:self.title rightImage:nil rightBlock:^{
            
        }];
        naviBar.frame = CGRectMake(0, 0, kScreenWidth, kNavibarHeight);
        [self.view addSubview:naviBar];
        self.webView.frame = CGRectMake(0, kNavibarHeight, kScreenWidth, kScreenHeight - kNavibarHeight);
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [self.webView loadRequest:request];
}


-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [self.view addSubview:_webView];
//        _webView.frame = self.view.bounds;
//        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _webView;
}

#pragma mark webView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingAnimation];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingAnimation];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideLoadingAnimation];
}

@end
