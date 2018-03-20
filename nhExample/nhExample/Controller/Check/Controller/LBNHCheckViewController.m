//
//  LBNHCheckViewController.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHCheckViewController.h"
#import "LBUtils.h"
#import "LBNHUserInfoManager.h"
#import "LBNHCheckCell.h"
#import "LBNHCheckCellFrame.h"
#import "LBNHCheckRequest.h"
#import "LBNHHomeServiceDataModel.h"
#import "LBNHUserIconView.h"
#import "LBNHCheckActionRequest.h"
#import "LBNHCheckReportView.h"
#import "LBNHDynamicReportRequest.h"
#import "LBUtils.h"
#import "SDPhotoBrowser.h"
#import "LBNHHomePublishController.h"
#import "LBNHLoginController.h"
#import "LBNHPersonalCenterController.h"

const NSInteger kMinHoriOffset = 100;//横向距离大于100 才可以滑动到下一页

@interface LBNHCheckViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LBNHCheckCellDelegate,UIGestureRecognizerDelegate,SDPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *cellFrameArray;

/**  点击查看大图的图片 */
@property (nonatomic, strong) UIImage *selectedImage;



/** pan手势  用来拦截左滑无效  右滑下一页 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

/** 记录是否识别了手势 */
@property (nonatomic, assign) BOOL isRecognizGesture;

/** 记录pan手势最初的位置 */
@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, strong) LBNHUserIconView *iconView ;

@end

@implementation LBNHCheckViewController

-(void)viewWillAppear:(BOOL)animated{
    [LBUtils forBiddenSDWebImageDecode:YES];
    
    LBNHUserInfoModel *userInfo = [LBNHUserInfoManager sharedLBNHUserInfoManager].currentLoginUserInfo;
    //根据用户是否登录状态设置左边的图片
    if ([[LBNHUserInfoManager sharedLBNHUserInfoManager] isLogin]) {
        [_iconView setIconUrl:userInfo.avatar_url];
    }else{
        _iconView.image = ImageNamed(@"defaulthead");
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [LBUtils forBiddenSDWebImageDecode:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviBar];
    [self loadData];
    [self panGesture];//添加手势
}

-(void)initNaviBar{
    self.navigationItem.title = @"审核22";
    _iconView = [[LBNHUserIconView alloc] init];
//    [_iconView showRedBorder];
    _iconView.image = ImageNamed(@"defaulthead");
    WS(weakSelf);
    _iconView.tapHandler = ^(LBNHUserIconView *iconView){
        [weakSelf leftItemClicked];
    };
    _iconView.frame = CGRectMake(-10, 0, 35, 35);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_iconView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"submission") style:UIBarButtonItemStylePlain target:self action:@selector(rightNaviItemClicked)];
    
    NSLog(@"self.frame is %@ ",NSStringFromCGRect(self.view.frame));
}

-(void)leftItemClicked{
    if ([[LBNHUserInfoManager sharedLBNHUserInfoManager] isLogin]) {
        LBNHUserInfoModel *userInfo = [[LBNHUserInfoManager sharedLBNHUserInfoManager] currentLoginUserInfo];
        LBNHPersonalCenterController *personalVC = [[LBNHPersonalCenterController alloc] initWithUserInfo:userInfo];
        [self pushToVc:personalVC];
    }
    //没有登录 跳转到登录界面
    else{
        LBNHLoginController *loginVC = [[LBNHLoginController alloc] init];
        [self pushToVc:loginVC];
    }
}

-(void)loadData{
    LBNHCheckRequest *request = [LBNHCheckRequest lb_request];
    request.lb_url = kNHCheckDynamicListAPI;
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        if (success) {
            [self.dataArray removeAllObjects];
            [self.cellFrameArray removeAllObjects];
            //重新加载数据  collectionView回到第一个
            self.collectionView.contentOffset = CGPointZero;
            self.dataArray = [LBNHHomeServiceDataElement modelArrayWithArray:response];
            for (LBNHHomeServiceDataElement *element in self.dataArray) {
                LBNHCheckCellFrame *cellFrame = [[LBNHCheckCellFrame alloc] init];
                cellFrame.element = element;
                [self.cellFrameArray addObject:cellFrame];
            }
            [self.collectionView reloadData];
        }else{
            [LBTips showTips:@"网络错误 稍后再试"];
        }
    }];
}

-(void)leftNaviItemClicked{
    BOOL isLog = [[LBNHUserInfoManager sharedLBNHUserInfoManager] isLogin];
    if (isLog) {
        
    }else{
        
    }
}
-(void)rightNaviItemClicked{
    LBNHHomePublishController *publishVC = [[LBNHHomePublishController alloc] init];
    [self pushToVc:publishVC];
}


//计算即将到最后一个  重新加载数据
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat contentX = self.collectionView.contentOffset.x;
//    NSInteger index = contentX/kScreenWidth;
//    if (index == self.cellFrameArray.count - 1) {
//        [self loadData];
//    }
//}


/** 滑动到下一个内容 */
-(void)slideNext{
//    NSLog(@"self.collection ContentSize is %@ ",NSStringFromCGSize(self.collectionView.contentSize));
    CGPoint point = self.collectionView.contentOffset;
//    NSLog(@"xxxxx %f ",point.x + kScreenWidth);
//    CGPoint newPoint =CGPointMake(point.x+kScreenWidth, 0);
    point.x +=kScreenWidth;
//    [self.collectionView setContentOffset:point animated:YES];
    self.collectionView.contentOffset = point;
    CGFloat contentX = self.collectionView.contentOffset.x;
    NSInteger index = contentX/kScreenWidth;
    if (index == self.cellFrameArray.count - 1) {
        [self loadData];
    }
}

#pragma mark colletionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cellFrameArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LBNHCheckCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"LBNHCheckCell" forIndexPath:indexPath];
    cell.cellFrame = self.cellFrameArray[indexPath.row];
    cell.delegate = self;
    NSLog(@"cell ---- % p ",cell);
    return cell;
}
/** 设置layout的delegate 的每个item的大小 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    LBNHCheckCellFrame *cellFrame = self.cellFrameArray[indexPath.row];
    CGSize size = CGSizeMake(kScreenWidth, cellFrame.cellHeight);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark checkCell delegate

/** 喜欢和不喜欢的点击事件  当动画做完了  才给回调 发请求处理*/
-(void)checkCell:(LBNHCheckCell *)checkCell didFinishLoadingWithFlag:(BOOL)isLikeFlag{
    [MBProgressHUD showLoading:self.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:checkCell];
    LBNHCheckCellFrame *cellFrame = self.cellFrameArray[indexPath.row];
    NSInteger action = isLikeFlag ? 5 : 6;
    LBNHCheckActionRequest *request = [LBNHCheckActionRequest lb_request];
    request.lb_url = kNHCheckDynamicListAPI;
    request.action = kIntegerToStr(action);
    request.group_id = cellFrame.element.group.ID;
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        [MBProgressHUD hidAllHudsInSuperView:self.view];
        if (response) {
            [self slideNext];
        }else{
            [LBTips showTips:@"加载失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self slideNext];
            });
        }
    }];
    
}

/** 举报的点击事件 */
-(void)checkCell:(LBNHCheckCell *)checkCell reportClicked:(BOOL)reportClicked{
    LBNHCheckReportView *reportView = [[LBNHCheckReportView alloc] initWithContents:@[@"垃圾广告",@"淫秽内容",@"煽情骗顶",@"以前看过",@"抄袭我的内容",@"其他"]];
    [reportView showInSuperView:self.view];
    WS(weakSelf);
    reportView.itemHandler = ^(LBNHCheckReportView *reView, UIButton *button, NSInteger index){
        [MBProgressHUD showLoading:weakSelf.view];
        LBNHDynamicReportRequest *request = [LBNHDynamicReportRequest lb_request];
        request.lb_url = kNHHomeReportDynamicAPI;
        [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
            [MBProgressHUD hidAllHudsInSuperView:weakSelf.view];
            
            if (success) {
                [reView dismiss];
                [weakSelf slideNext];
            }else{
                [LBTips showTips:@"举报失败，稍后再试"];
            }
        }];
    };
}

#pragma mark 点击查看大图

-(void)checkCell:(LBNHCheckCell *)checkCell imageView:(UIImageView *)imageView currentIndex:(NSInteger)currentIndex urls:(NSArray<NSURL *> *)urls{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageView = imageView;
    browser.currentImageIndex = 0;
    browser.delegate = self;
    browser.imageCount = urls.count;
    self.selectedImage = imageView.image;
    [browser show];
}

/** 默认显示的图片  不是高质量的 */
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return self.selectedImage;
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //1.创建collectionView的约束
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        //2.设置约束条件
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = NO;
        //3.注册colletionview重复利用的对象
        [_collectionView registerClass:[LBNHCheckCell class] forCellWithReuseIdentifier:@"LBNHCheckCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        //设置最小一个手指触发
        [_panGesture setMinimumNumberOfTouches:1];
        //设置最大应许一个手指
        [_panGesture setMaximumNumberOfTouches:1];
        _panGesture.delegate = self;
        [self.view addGestureRecognizer:_panGesture];
    }
    return _panGesture;
}



#pragma mark 处理pan手势
-(void)panGestureHandler:(UIPanGestureRecognizer *)panGesture{
    CGPoint point = [panGesture locationInView:self.view];
    if (panGesture.state == UIGestureRecognizerStateBegan ) {
        _isRecognizGesture =NO;
        self.startPoint = point;
    }
    if ( panGesture.state == UIGestureRecognizerStateChanged) {
        //还没有识别手势 继续识别
        if (!_isRecognizGesture) {
            if (fabs(point.y - self.startPoint.y)>60) {
                return;
            }
            //2.水平方向小于最小距离 不触发
                    if (fabs(point.x - self.startPoint.x)<kMinHoriOffset) {
                        return;
                    }else if(self.startPoint.x - point.x  >kMinHoriOffset){
                        //3.达到条件 触发下一页
                        [self slideNext];
                        _isRecognizGesture = YES;
                    }
        }
        
//        //2.水平方向小于最小距离 不触发
//        if (fabs(point.x - self.startPanPoint.x)<kMinHoriOffset) {
//            return;
//        }else{
//            //3.达到条件 触发下一页
//            
//        }
        
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded){
        //结束时 置0 重置所有判断条件
        _isRecognizGesture = NO;
        self.startPoint = CGPointZero;
    }
}

#pragma mark - UIGestureRecognizer 判断接受事件的  scrollview就不识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    return YES;
}

-(NSMutableArray *)cellFrameArray{
    if (!_cellFrameArray) {
        _cellFrameArray = [NSMutableArray new];
    }
    return _cellFrameArray;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

@end
