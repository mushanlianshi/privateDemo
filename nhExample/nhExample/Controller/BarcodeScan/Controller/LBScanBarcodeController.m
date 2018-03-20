//
//  LBScanBarcodeController.m
//  nhExample
//
//  Created by liubin on 17/5/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBScanBarcodeController.h"
#import "LBScanView.h"
#import "LBScanViewStyle.h"
#import "LBImageTitleButton.h"
#import "LBBottomAverageButtonView.h"
#import "LBMyQRCodeController.h"
#import "LBPresentPushAnimation.h"
#import "LBDismissPopAnimation.h"
#import "LBAuthorUtil.h"
#import "LBScanNative.h"
#import "LBScanResult.h"


@interface LBScanBarcodeController ()<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) LBScanView *scanView;

@property (nonatomic, strong) LBScanViewStyle *scanStyle;

@property (nonatomic, strong) LBBottomAverageButtonView *bottomView;

/** present 和 dismiss用的动画 */
@property (nonatomic, strong) LBPresentPushAnimation *presentAnimation;

@property (nonatomic, strong) LBDismissPopAnimation *dismissAnimation;

@end

@implementation LBScanBarcodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initAnimationors];
}

-(void)initUI{
//    self.navigationController.navigationBarHidden = YES;
    MyLog(@"LBLog self.view frame is %@ ",NSStringFromCGRect(self.view.frame));
    _scanStyle = [LBScanViewStyle alipayStyle];
    _scanView = [[LBScanView alloc] initWithFrame:self.view.bounds scanStyle:_scanStyle readyString:@"相机准备中"];
    [self.view addSubview:_scanView];
    _scanView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    
    MyLog(@"LBLog self.view frame is %@ ",NSStringFromCGRect(self.view.frame));
    
    [self initBottomView];
}

/** 初始化需要的动画 */
-(void)initAnimationors{
    self.presentAnimation = [[LBPresentPushAnimation alloc] init];
    self.dismissAnimation = [[LBDismissPopAnimation alloc] init];
}

-(void)initBottomView{
    WS(weakSelf);
    NSArray *images = @[ImageNamed(@"CodeScan.bundle/qrcode_scan_btn_photo"),ImageNamed(@"CodeScan.bundle/qrcode_scan_btn_flash"),ImageNamed(@"CodeScan.bundle/qrcode_scan_btn_myqrcode")];
    NSArray *highImages = @[ImageNamed(@"CodeScan.bundle/qrcode_scan_btn_photo_down"),ImageNamed(@"CodeScan.bundle/qrcode_scan_btn_flash_down"),ImageNamed(@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down")];
    NSArray *titles = @[@"相册",@"闪光灯",@"我的二维码"];
    _bottomView = [[LBBottomAverageButtonView alloc] initImages:images highImages:highImages titles:titles];
//    [_bottomView showRedBorder];
    _bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 80 - 64, kScreenWidth, 80);
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.clickHandler = ^(NSInteger index, BOOL isSelected){
        MyLog(@"LBlog index is %ld ",index);
        switch (index) {
            case 0:
                {
                    BOOL authority = [LBAuthorUtil isHasPhotoLibraryAuthority:YES];
                    if (authority) {
                       UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
                        pickerController.delegate = weakSelf;
                        pickerController.editing = YES;
                        pickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                        [weakSelf presentViewController:pickerController animated:YES completion:nil];
                    }
//                    [weakSelf.scanView setNeedsDisplay];
//                    [weakSelf.view layoutIfNeeded];
                }
                break;
            case 1:
                {
                    if (![weakSelf.scanView isFlashAvailbe]) return ;
                    [weakSelf.scanView setFlashState:isSelected];
                }
                break;
            case 2:
                {
                    LBMyQRCodeController *qrController = [[LBMyQRCodeController alloc] init];
                    //设置动画的代理是自己
                    qrController.transitioningDelegate = weakSelf;
                    [weakSelf presentViewController:qrController animated:YES completion:nil];
                }
                break;
            default:
                break;
        }
    };
    [self.view addSubview:_bottomView];
}


#pragma mark 打开图库的回调
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    MyLog(@"LBLog   选择图片取消  =========");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
     UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [LBScanNative recognizeImage:image success:^(NSArray<LBScanResult *> *array) {
            if (array.count) {
                LBScanResult *result = array[0];
                [MBProgressHUD showHintText:result.resultString superView:nil];
            }else{
                [MBProgressHUD showHintText:@"没有识别图片" superView:nil];
            }
        }];
    }];
}


-(void)viewDidAppear:(BOOL)animated{
    MyLog(@"LBLog self.view frame is DidAppear %@ ",NSStringFromCGRect(self.view.frame));
    [self.scanView startScaning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.scanView stopScaning];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 动画的代理

/** 返回present的动画 */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.presentAnimation;
}

/** 返回dismiss的动画 */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.dismissAnimation;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc{
    MyLog(@"LBLog lbscabBarcodeController dealloc ============");
}

@end
