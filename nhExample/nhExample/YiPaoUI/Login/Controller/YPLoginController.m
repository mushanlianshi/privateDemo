//
//  YPLoginController.m
//  nhExample
//
//  Created by liubin on 17/5/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "YPLoginController.h"
#import "LBCustomNaviBar.h"
#import "LBCustomTextField.h"
#import "UIButton+LBInit.h"
#import "UIImage+SubImage.h"
#import "UIView+LBTap.h"
#import "LBAlertController.h"

#define BackGroundColor [UIColor colorWithRed:0.22 green:0.74 blue:0.61 alpha:1.00]

#define kTitleColor [UIColor colorWithRed:0.40 green:0.43 blue:0.47 alpha:1.00]

@interface YPLoginController ()

@end

@implementation YPLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor colorWithRed:0.90 green:0.91 blue:0.93 alpha:1.00];
    
    [self initNaviBar];
    [self initView];
    
    
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//}

-(void)initNaviBar{
    
    WS(weakSelf);
    LBCustomNaviBar *naviBar = [[LBCustomNaviBar alloc] initNaviBarTintColor:[UIColor whiteColor] backgroundColor:BackGroundColor leftImage:ImageNamed(@"back_neihan") leftBlock:^{
        MyLog(@"LBlog back ========");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } title:@"用户登录" rightImage:ImageNamed(@"nearbypeople") rightBlock:^{
        MyLog(@"LBlog right =======");
    }];
    naviBar.titleFont = LBAdjustFont(18);
//    naviBar.frame = CGRectMake(0, 0, kScreenWidth, kNavibarHeight);
    [self.view addSubview:naviBar];
    
    
}

-(void)initView{
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavibarHeight, kScreenWidth, LBLayoutValue(204))];
    logoView.backgroundColor = BackGroundColor;
    [self.view addSubview:logoView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LBLayoutValue(114), LBLayoutValue(114))];
    logoImageView.image = ImageFiled(@"logoImage.png");
    [logoView addSubview:logoImageView];
    logoImageView.center = CGPointMake(kScreenWidth/2, LBLayoutValue(204)/2);
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoView.frame), kScreenWidth, LBLayoutValue(100))];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    
    UIImage *accountLeftImage = ImageFiled(@"YPLogin.bundle/account@2x.png");
    UIImage *accountRightImage = ImageFiled(@"YPLogin.bundle/form-del-nor@2x.png");
//    LBCustomTextField *account = [[LBCustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, LBLayoutValue(50)) pleaceHolder:@"昵称/手机号码" pleaceHolderColor:[UIColor lightGrayColor] textColor:[UIColor blackColor] leftImage:accountLeftImage rightImage:accountRightImage ImageSize:CGSizeZore leftMargin:10];
    LBCustomTextField *account = [[LBCustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, LBLayoutValue(50)) pleaceHolder:@"昵称/手机号码" pleaceHolderColor:[UIColor lightGrayColor] textColor:[UIColor blackColor] leftImage:accountLeftImage rightImage:accountRightImage ImageSize:CGSizeMake(LBLayoutValue(18), LBLayoutValue(18)) leftMargin:10];
    account.font = LBAdjustFont(18);
    [inputView addSubview:account];
    
    CALayer *accountLine = [CALayer layer];
    accountLine.frame = CGRectMake(LBLayoutValue(18), LBLayoutValue(49), kScreenWidth-LBLayoutValue(60), 1);
    accountLine.backgroundColor = [UIColor lightGrayColor].CGColor;
    [inputView.layer addSublayer:accountLine];
    
    
    UIImage *passwordLeftImage = ImageFiled(@"YPLogin.bundle/password@2x.png");
    UIImage *passwordRightImage = ImageFiled(@"YPLogin.bundle/form-show-sel@2x.png");
    LBCustomTextField *password = [[LBCustomTextField alloc] initWithFrame:CGRectMake(0, LBLayoutValue(50), kScreenWidth, LBLayoutValue(50)) pleaceHolder:@"密码" pleaceHolderColor:[UIColor lightGrayColor] textColor:[UIColor blackColor] leftImage:passwordLeftImage rightImage:passwordRightImage ImageSize:CGSizeMake(LBLayoutValue(18), LBLayoutValue(18)) leftMargin:10];
    password.font = LBAdjustFont(16);
    password.isSecurity = YES;
    password.showRightImage = YES;
    [inputView addSubview:password];
    
    CALayer *passwordLine = [CALayer layer];
    passwordLine.frame = CGRectMake(0, LBLayoutValue(99), kScreenWidth, 1);
    passwordLine.backgroundColor = [UIColor lightGrayColor].CGColor;
    [inputView.layer addSublayer:passwordLine];
    
    UIButton *loginButton = [[UIButton alloc] initWithTitle:@"登录" titleColor:[UIColor whiteColor] titleFont:LBAdjustFont(18) backGroundColor:BackGroundColor target:self selector:@selector(loginButtonClicked:)];
    loginButton.layer.cornerRadius = LBLayoutValue(10);
    loginButton.frame = CGRectMake(LBLayoutValue(20), CGRectGetMaxY(inputView.frame)+LBLayoutValue(20), kScreenWidth - 2*LBLayoutValue(20), LBLayoutValue(50));
    [self.view addSubview:loginButton];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(kScreenWidth/2, CGRectGetMaxY(loginButton.frame) + LBLayoutValue(20), 1, LBLayoutValue(16));
    line.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:line];
    
    UIButton *forgetButton = [[UIButton alloc] initWithTitle:@"忘记密码" titleColor:kTitleColor target:self selector:@selector(forgetButtonClicked:)];
    [self.view addSubview:forgetButton];
    forgetButton.titleLabel.font = LBAdjustFont(16);
    forgetButton.backgroundColor = [UIColor clearColor];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-kScreenWidth/2 - LBLayoutValue(20));
        make.top.equalTo(loginButton.mas_bottom).offset(LBLayoutValue(20));
        make.height.mas_equalTo(LBLayoutValue(16));
    }];
    
    UIButton *registerButton = [[UIButton alloc] initWithTitle:@"立即注册" titleColor:BackGroundColor target:self selector:@selector(registerButtonClicked:)];
    registerButton.titleLabel.font = LBAdjustFont(16);
    registerButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kScreenWidth/2 + LBLayoutValue(20));
        make.top.height.equalTo(forgetButton);
    }];
    
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(LBLayoutValue(90));
    }];
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"使用以下账号直接登录";
    hintLabel.textColor = kTitleColor;
//    [hintLabel showRedBorder];
    [bottomView addSubview:hintLabel];
    hintLabel.font = LBAdjustFont(14);
//    hintLabel.adjustsFontSizeToFitWidth = YES;
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView).offset(-LBLayoutValue(80 - 7));
        make.centerX.equalTo(bottomView);
        make.height.mas_equalTo(LBLayoutValue(14));
//        make.width.mas_equalTo(LBLayoutValue(150));
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hintLabel.mas_left).offset(-LBLayoutValue(20));
        make.left.equalTo(bottomView).offset(LBLayoutValue(20));
        make.centerY.equalTo(hintLabel);
        make.height.mas_equalTo(1);
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintLabel.mas_right).offset(LBLayoutValue(20));
        make.right.equalTo(bottomView).offset(-LBLayoutValue(20));
        make.centerY.equalTo(hintLabel);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *qq = [[UIImageView alloc] init];
    qq.image = ImageFiled(@"YPLogin.bundle/login_qq@2x.png");
    [bottomView addSubview:qq];
    [qq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView).offset(LBLayoutValue(5));
        make.centerX.equalTo(bottomView);
        make.height.width.mas_equalTo(LBLayoutValue(35));
    }];
    [qq addTapBlock:^{
        MyLog(@"LBlog qq login");
    }];
    
    UIImageView *weibo = [[UIImageView alloc] init];
    weibo.image = ImageFiled(@"YPLogin.bundle/login_wb@2x.png");
    [bottomView addSubview:weibo];
    [weibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(qq.mas_left).offset(-LBLayoutValue(30));
        make.centerY.equalTo(qq);
        make.width.height.mas_equalTo(qq);
    }];
    [weibo addTapBlock:^{
        MyLog(@"LBlog weibo login");
    }];
    
    UIImageView *wechat = [[UIImageView alloc] init];
    wechat.image = ImageFiled(@"YPLogin.bundle/login_wx@2x.png");
    [bottomView addSubview:wechat];
    [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qq.mas_right).offset(LBLayoutValue(30));
        make.centerY.equalTo(qq);
        make.width.height.mas_equalTo(qq);
    }];
    [wechat addTapBlock:^{
        MyLog(@"LBlog wechat login");
    }];
    
}
#pragma mark VC 声明周期
-(void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)loginButtonClicked:(UIButton *)button{
    MyLog(@"LBlog loginButtonClicked ==========");
}

-(void)forgetButtonClicked:(UIButton *)button{
    MyLog(@"LBlog forgetButtonClicked ==========");
}

-(void)registerButtonClicked:(UIButton *)button{
    MyLog(@"LBlog registerButtonClicked ==========");
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
