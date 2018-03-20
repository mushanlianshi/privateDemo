//
//  LBNHHomePublishController.m
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomePublishController.h"
#import "LBPublishTopView.h"
#import "LBPublishPleaceHolderTextView.h"
#import "LBPublishPickImageBottomView.h"
#import "TZImagePickerController.h"
#import "LBPublishPictureView.h"
#import "MBProgressHUD+LBAddtion.h"
#import "LBNHPublishRequest.h"
#import "LBNHUserInfoManager.h"
#import "LBNHUserInfoModel.h"
#import "LBNHPublishSelectColumnController.h"

NSInteger const kMaxImagesCount  = 9;//最大选择9张
NSInteger const kMaxInputCount = 300 ;//最多输入300字

@interface LBNHHomePublishController ()<LBPublishPleaceHolderDelegate,LBPublishPickImageBottomViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) LBPublishTopView *topView;

@property (nonatomic, strong) LBPublishPleaceHolderTextView *pleaceTextView;

@property (nonatomic, strong) LBPublishPickImageBottomView *bottomView;

@property (nonatomic, strong) LBPublishPictureView *pickerShowView;

/** 滚动用的scrollview */
@property (nonatomic, strong) UIScrollView *scrollView;

/** 选中的图片 */
@property (nonatomic, strong) NSMutableArray *imagesArray;

/** 匿名 */
@property (nonatomic, assign) BOOL isAnonymous;

/** 选择的类别 */
@property (nonatomic, assign) NSInteger category_id;


/** 请求的队列group  用来维护请求的  确保请求结束收到回调 */
@property (nonatomic, retain) dispatch_group_t group;

@end

@implementation LBNHHomePublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNaviItem];
    [self setupViews];
    [self addNotificationObservers];
}
-(void)setUpNaviItem{
    self.navigationItem.title = @"投稿";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
}

/** 发布请求 */
-(void)rightItemClicked{
    //注销第一响应
    [self.pleaceTextView resignFirstResponder];
    if (self.pleaceTextView.text.length == 0) {
        [MBProgressHUD showHintText:@"内容不能为空" superView:self.view];
        return;
    }
    [MBProgressHUD showLoading:self.view];
    //定义一个变量  确保发布和上传图片都成功了 才算成功  才返回上一层  所以需要group等待异步回调
    __block BOOL successFlag =NO;
    _group = dispatch_group_create();
    LBNHPublishRequest *request = [LBNHPublishRequest lb_request];
    request.text = self.pleaceTextView.text;
    request.is_anonymous = self.isAnonymous;
    //只有图片 category_id默认是2
    if (self.imagesArray.count) {
        request.category_id = 2;
    }else{
        request.category_id = self.category_id;
    }
    request.user_id = [LBNHUserInfoManager sharedLBNHUserInfoManager].currentLoginUserInfo.user_id;
    request.isPost = YES;
    dispatch_group_enter(_group);
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        NSLog(@"LBLog request ======1==1==1==1=");
        if (success) {
            successFlag = YES;
        }
        dispatch_group_leave(_group);
    }];
    
    //上传图片
    LBNHPublishRequest *upRequest = [LBNHPublishRequest lb_request];
    upRequest.isPost = YES;
    upRequest.lb_url = @"http://lf.snssdk.com/neihan/file/upload/v1/image/";
    if (self.imagesArray.count) {
        upRequest.category_id = 2;
    }else{
        upRequest.category_id = self.category_id;
    }
    upRequest.lb_imagesArray = self.imagesArray;
    upRequest.text = self.pleaceTextView.text;
    upRequest.is_anonymous = self.isAnonymous;
    upRequest.user_id = [LBNHUserInfoManager sharedLBNHUserInfoManager].currentLoginUserInfo.user_id;
    dispatch_group_enter(_group);
    [upRequest lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        NSLog(@"LBLog request ======2==2==2==2=");
        if (successFlag) {
            successFlag = YES;
        }
        dispatch_group_leave(_group);
    }];
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        NSLog(@"LBLog request ======3==3==3==3=");
        [MBProgressHUD hidAllHudsInSuperView:self.view];
        if (successFlag) {
            //返回上一层级
            [self pop];
        }
    });
    
}

-(void)setupViews{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 70, 0));
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    [self.pleaceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    [self.pickerShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.pleaceTextView.mas_bottom);
        make.height.mas_equalTo(kScreenWidth);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(70);
    }];
}

/** 添加键盘通知 */
-(void)addNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)updateViewConstraints {
//    [super updateViewConstraints];
//    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.view);
//        make.height.mas_equalTo(70);
//        make.bottom.mas_equalTo(self.view);
//    }];
//}
//
//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    if (self.imagesArray.count) {
//        
//        self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.pickerShowView.bottom+10);
//        NSLog(@"11111self.scrollView contentSize is %@ ",NSStringFromCGSize(self.scrollView.contentSize));
//        NSLog(@"111pickerShowView frame is %@ ",NSStringFromCGRect(self.pickerShowView.frame));
//    }else{
//        self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.pleaceTextView.bottom);
//        NSLog(@"222self.scrollView contentSize is %@ ",NSStringFromCGSize(self.scrollView.contentSize));
//    }
//}

-(LBPublishTopView *)topView{
    if (!_topView) {
        _topView = [[LBPublishTopView alloc] init];
        _topView.topicName = @"聊电影";
        WS(weakSelf);
        _topView.topicHandler = ^(UIButton *button){
            [weakSelf goToSelectColumn];
        };
        [self.scrollView addSubview:_topView];
    }
    return _topView;
}


-(LBPublishPleaceHolderTextView *)pleaceTextView{
    if (!_pleaceTextView) {
        _pleaceTextView = [[LBPublishPleaceHolderTextView alloc] init];
        _pleaceTextView.pleaceHolderLeftMargin = 5;
        _pleaceTextView.pleaceHolderTopMargin = 5;
        _pleaceTextView.delegate = self;
        _pleaceTextView.pleaceHolder = @"您的投稿经过段友审核才能发布哦！我们的目标是：专注内涵，拒绝黄反！可以矫情，不要煽情！敬告：发布色情敏感内容会被封号处理";
        [self.scrollView addSubview:_pleaceTextView];
    }
    return _pleaceTextView;
}

-(LBPublishPickImageBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[LBPublishPickImageBottomView alloc] init];
//        [_bottomView showRedBorder];
        _bottomView.delegate = self;
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

-(LBPublishPictureView *)pickerShowView{
    if (!_pickerShowView) {
        _pickerShowView = [[LBPublishPictureView alloc] init];
        [self.scrollView addSubview:_pickerShowView];
//        [self.view insertSubview:_pickerShowView belowSubview:self.bottomView];
    }
    return _pickerShowView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}


#pragma mark 键盘的处理
-(void)keyBoardWillShow:(NSNotification *)notification{
    [self showKeyBoard:YES withNotification:notification];
}

-(void)keyBoardWillDisappear:(NSNotification *)notification{
    [self showKeyBoard:NO withNotification:notification];
}
-(void)showKeyBoard:(BOOL)isShow withNotification:(NSNotification *)notification{
    NSLog(@"notification is %@ ",notification);
    //duration = 0.25
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect rect = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyBoardHeight = rect.size.height;
    if (isShow) {
        [UIView animateWithDuration:duration animations:^{
           [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.left.right.equalTo(self.view);
               make.height.mas_equalTo(70);
               make.bottom.equalTo(self.view).offset(-keyBoardHeight);
               [self.bottomView layoutIfNeeded];
           }];
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.height.mas_equalTo(80);
                make.bottom.equalTo(self.view);
                [self.bottomView layoutIfNeeded];
            }];
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark 选择栏目的方法

-(void)goToSelectColumn{
    //因为在block里调用的   所以要weak引用
    WS(weakSelf);
    LBNHPublishSelectColumnController *columnController = [[LBNHPublishSelectColumnController alloc] init];
    columnController.selectedHandler =^(LBNHPublishSelectColumnController *controller, NSString *title,NSInteger category_id){
        weakSelf.category_id = category_id;
        weakSelf.topView.topicName = title;
    };
    [weakSelf pushToVc:columnController];
}

#pragma mark pleaceHolder的代理
-(void)pleaceHolderTextChanged:(LBPublishPleaceHolderTextView *)pleaceTextView{
    NSString *text = [pleaceTextView text];
    if (text.length > kMaxInputCount) {
        pleaceTextView.text = [text substringToIndex:kMaxInputCount];
        self.bottomView.hintNumber = 0;
    }else{
        self.bottomView.hintNumber = kMaxInputCount - text.length;
    }
}


#pragma mark 底部view的delegate
/** 是否是匿名的回调 */
-(void)publishPickImage:(LBPublishPickImageBottomView *)publishImageView isWithOutName:(BOOL)withOutName{
    self.isAnonymous = withOutName;
}

/** 选择图片的回调 */
-(void)publishPickImageSelected:(LBPublishPickImageBottomView *)publishImageView{
    [self addImages];
}


-(void)addImages{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaxImagesCount - self.imagesArray.count delegate:self];
    imagePicker.pickerDelegate = self;
    imagePicker.allowPickingVideo = NO;//不应许选择视频
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark 选择图片的回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    if(photos.count){//有图片继续选择
        if (self.imagesArray.count) {
//            [self.imagesArray addObjectsFromArray:photos];
            [self.pickerShowView addImages:photos];
            [self.imagesArray addObjectsFromArray:photos];
        }else{
            self.pickerShowView.imagesArray = photos.mutableCopy;
            self.imagesArray = photos.mutableCopy;
        }
        [self changeScrollViewContentSize];
    }//没有图片
}
-(void)changeScrollViewContentSize{
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.pickerShowView.bottom+10);
    NSLog(@"self.scrollView ContentSize is %@ ",NSStringFromCGSize(self.scrollView.contentSize));
}
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
