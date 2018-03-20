//
//  LBNHLoginController.m
//  nhExample
//
//  Created by liubin on 17/4/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHLoginController.h"
#import "LBCustomAlertView.h"
#import "LBNHUserInfoManager.h"

@interface LBNHLoginController ()



@end

@implementation LBNHLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviViews];
}


-(void)initNaviViews{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(userLogin)];
    self.navigationItem.title = @"点击👉右边登录";
}

/** 模拟用户登录 */
-(void)userLogin{
    WS(weakSelf);
    [self showLoadingView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenLoadingView];
        LBCustomAlertView *alertView = [[LBCustomAlertView alloc] initWithTitle:@"提示" content:@"点击登录按钮，你将登录内涵段子，这里模拟数据本地写死" cancel:@"取消" sure:@"确定"];
        [alertView setSureBlock:^{
            // 写死的用户信息
            NSDictionary *userInfoDict = @{
                                           @"is_blocking": @(0),
                                           @"session_key": @"b391787a2cd16be0f914259f0cf829a4",
                                           @"media_id": @(0),
                                           @"description": @"\u8fd9\u4e2a\u4eba\u5f88\u61d2\uff0c\u4ec0\u4e48\u4e5f\u6ca1\u6709\u7559\u4e0b",
                                           @"name": @"测试用户",
                                           @"point": @(100),
                                           @"mobile": @"",
                                           @"gender": @(1),
                                           @"visit_count_zrecent": @(0),
                                           @"verified_agency": @"",
                                           @"bg_img_url": @"http://p3.pstatp.com/origin/bc2000955fc8046e109",
                                           @"verified_content": @"",
                                           @"avatar_url": @"http://p1.pstatp.com/thumb/e580000d5c689f3bd23",
                                           @"followings_count": @(123),
                                           @"followers_count": @(45),
                                           @"user_id": @(50697375933),
                                           @"is_blocked": @(0),
                                           @"user_verified": @(0),
                                           @"screen_name": @"Charles姚鑫"
                                           };
            [[LBNHUserInfoManager sharedLBNHUserInfoManager] didLoginInWithUserInfoDic:userInfoDict];
            [weakSelf pop];
        }];
        [alertView showInSuperView:nil];
    });
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
