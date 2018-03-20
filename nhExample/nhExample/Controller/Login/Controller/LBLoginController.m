//
//  LBLoginController.m
//  nhExample
//
//  Created by liubin on 17/4/27.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBLoginController.h"
#import "LBCustomTextField.h"

@interface LBLoginController ()<UITextFieldDelegate>

@property (nonatomic, strong) LBCustomTextField *accoumtTextField;

@property (nonatomic, strong) LBCustomTextField *passWordTextField;

/** 记录账号右边图片的角度用的 */
@property (nonatomic, assign) CGFloat accountAngle;

@end

@implementation LBLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    WS(weakSelf);
    self.navigationItem.title = @"登录";
    UIImageView *logoIV = [[UIImageView alloc] init];
    [self.view addSubview:logoIV];
    logoIV.image = ImageNamed(@"login.bundle/video");
    [logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    
    UIView *loginView = [[UIView alloc] init];
    loginView.backgroundColor = [UIColor whiteColor];
    [loginView setLayerCornerRadius:5.f borderWitdh:0.8 borderColor:kCommonTintColor];
    loginView.layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoIV.mas_bottom);
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.height.mas_equalTo(88);
    }];
    
    _accoumtTextField = [[LBCustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 44) pleaceHolder:@"手机/邮箱/用户名" pleaceHolderColor:[UIColor lightGrayColor] textColor:[UIColor blackColor] leftImage:ImageNamed(@"login.bundle/user") rightImage:ImageNamed(@"login.bundle/pull") leftMargin:10];
//    _accoumtTextField.keyboardType = UIKeyboardTypeNumberPad;
    _accoumtTextField.returnKeyType = UIReturnKeyDone;
    _accoumtTextField.maxLength = 15;
    _accoumtTextField.isNoChinese = YES;
    _accoumtTextField.showRightImage = YES;
    _accoumtTextField.leftHightImage = ImageNamed(@"login.bundle/videouser");
    _accoumtTextField.delegate = self;
    _accoumtTextField.rightTapHandler = ^(LBCustomTextField *textField){
        if (weakSelf.accountAngle == M_PI) {
            weakSelf.accountAngle = 0;
            textField.rightView.transform = CGAffineTransformIdentity;
        }else{
            weakSelf.accountAngle = M_PI;
            textField.rightView.transform = CGAffineTransformMakeRotation(M_PI);
            //查询账号记录
        }
        
    };
    [loginView addSubview:_accoumtTextField];
    
    
    
    _passWordTextField = [[LBCustomTextField alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth-30, 44) pleaceHolder:@"密码" pleaceHolderColor:[UIColor lightGrayColor] textColor:[UIColor blackColor] leftImage:ImageNamed(@"login.bundle/pw") rightImage:ImageNamed(@"login.bundle/inVisible") leftMargin:10];
    _passWordTextField.returnKeyType = UIReturnKeyDone;
    _passWordTextField.showRightImage = YES;
    _passWordTextField.keyboardType = UIKeyboardTypeDefault;
    _passWordTextField.leftHightImage = ImageNamed(@"login.bundle/videopw");
    _passWordTextField.secureTextEntry = YES;
    _passWordTextField.delegate = self;
    _passWordTextField.rightTapHandler = ^(LBCustomTextField *textField){
        textField.secureTextEntry = !textField.secureTextEntry;
        textField.rightImage = textField.secureTextEntry ? ImageNamed(@"login.bundle/inVisible") : ImageNamed(@"login.bundle/visible");
        
    };
    [loginView addSubview:_passWordTextField];
    
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.backgroundColor = kCommonTintColor.CGColor;
    lineLayer.frame = CGRectMake(0, 44, kScreenWidth - 30, 0.8);
    [loginView.layer addSublayer:lineLayer];
    
    UIButton *loginButton = [[UIButton alloc] init];
    loginButton.backgroundColor = kCommonBgColor;
    [loginButton setTitle:@"登录" titleColor:[UIColor whiteColor]];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(loginView);
        make.top.equalTo(loginView.mas_bottom).offset(15);
        make.height.mas_equalTo(35);
    }];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *messageButton = [[UIButton alloc] init];
    [self.view addSubview:messageButton];
    [messageButton setTitle:@"短信登录" forState:UIControlStateNormal];
    [messageButton setTitleColor:kCommonTintColor forState:UIControlStateNormal];
    messageButton.titleLabel.font = kFont(14);
    [messageButton addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton);
        make.top.equalTo(loginButton.mas_bottom).offset(10);
    }];
    
    UIButton *forgotButton = [[UIButton alloc] init];
    [self.view addSubview:forgotButton];
    [forgotButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgotButton setTitleColor:kCommonTintColor forState:UIControlStateNormal];
    forgotButton.titleLabel.font = kFont(14);
    [forgotButton addTarget:self action:@selector(forgotButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginButton);
        make.top.equalTo(loginButton.mas_bottom).offset(10);
    }];
    
}


#pragma mark button事件

-(void)loginButtonClicked:(UIButton *)button{
    
}

-(void)messageButtonClicked:(UIButton *)button{
    
}

-(void)forgotButtonClicked:(UIButton *)button{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark textFiled delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

/** 失去第一响应  图片高亮取消 */
-(void)textFieldDidEndEditing:(UITextField *)textField{
   
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
