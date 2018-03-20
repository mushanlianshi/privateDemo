//
//  LBMyQRCodeController.m
//  nhExample
//
//  Created by liubin on 17/5/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBMyQRCodeController.h"
#import "LBScanNative.h"
#import "LBNaviBarView.h"


@interface LBMyQRCodeController ()

@property (nonatomic, copy) NSString *myInfo;

@property (nonatomic, strong) UIImage *logoImage;

@property (nonatomic, strong) UIImageView *qrImageView;



@end

@implementation LBMyQRCodeController


-(instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        self.logoImage = image;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    WS(weakSelf);
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
    LBNaviBarView *naviBar = [[LBNaviBarView alloc] initWithLeftImage:@"back_neihan" title:@"我的二维码" leftBlock:^{
        if (weakSelf.navigationController) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    } backGroundColor:kCommonBgColor];
    [self.view addSubview:naviBar];
    self.myInfo = @"刘彬\t liu_bin_home@163.com\t 17301600702";
    self.qrImageView.frame = CGRectMake(30 , (kScreenHeight - (kScreenWidth - 60)/2)/2, (kScreenWidth - 60), (kScreenWidth - 60));
//    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(kScreenWidth - 30*2);
//        make.center.equalTo(self.view);
//    }];
    [self createQRCode];
    
}



-(void)createQRCode{
    UIImage *image = self.logoImage ? self.logoImage : ImageNamed(@"icon_5");
    UIImage *qrImage = [LBScanNative createQRCodeString:self.myInfo QRSize:CGSizeMake(kScreenWidth - 2*30, kScreenWidth - 2*30) logoImage:image logoSize:image.size logoType:LBQRCodeLogoTypeCenter];
    
    self.qrImageView.image = qrImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImageView *)qrImageView{
    if (!_qrImageView) {
        _qrImageView = [[UIImageView alloc] init];
        [self.view addSubview:_qrImageView];
    }
    return _qrImageView;
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
