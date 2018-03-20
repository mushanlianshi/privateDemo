//
//  LBNHHomeBaseViewController.m
//  nhExample
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomeBaseViewController.h"
#import "LBNHHomeRequest.h"
#import "LBNHHomeServiceDataModel.h"
#import "LBNHHomeCellFrame.h"
#import "UIViewController+LBLoading.h"
#import "LBNHHomeTableViewCell.h"
#import "LBNHBaseTableView.h"
#import "SDPhotoBrowser.h"
#import "LBSDImageCache.h"
#import "LBTips.h"
#import "LBNHThumRequest.h"
#import "LBNHPersonalCenterController.h"
#import "LBViewUtils.h"
#import "WMPlayer.h"
#import "LBNHBaseImageView.h"
#import "LBNHDetailViewController.h"
#import "LBDiscoveryCategoryController.h"
#import "LBNHHomePublishController.h"
#import "LBNHFileCacheManager.h"
#import "LBShareBottomView.h"
#import "LBCustomLongImageView.h"
#import "MJRefresh.h"


@interface LBNHHomeBaseViewController ()<LBNHHomeTableViewCellDelegate,SDPhotoBrowserDelegate,WMPlayerDelegate>

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) LBNHBaseRequest *request;

@property (nonatomic, strong) NSMutableArray *cellFrameArray;

@property (nonatomic, strong) NSMutableArray *elementDataArray;

@property (nonatomic, strong) NSArray *littleImagesURLs;




/** 点击的图片 */
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) WMPlayer *wmPlayer;
/** 记录当前正在播放的播放器 */
@property (nonatomic, strong) NSIndexPath *videoIndexPath;
/** 添加播放器的view */
@property (nonatomic, strong) LBNHBaseImageView *videoSuperView;

/** 记录是在window小屏放还是cell的 */
@property (nonatomic, assign) BOOL isWindowVideo;

@end

@implementation LBNHHomeBaseViewController

-(instancetype)initWithUrl:(NSString *)url{
    self=[super init];
    if (self) {
        self.url = url;
    }
    return self;
}

-(instancetype)initWithRequest:(LBNHBaseRequest *)request{
    self=[super init];
    if (self) {
        self.request = request;
    }
    return self;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//    [self.view addSubview:self.tableView];
//    [self.tableView registerClass:[LBNHHomeTableViewCell class] forCellReuseIdentifier:@"LBNHHomeTableViewCell"];
    //不要分割线
    self.needCellSepLine = NO;
    //显示刷新图标
    self.showRefreshIcon = YES;
    self.refreshType = LBBaseTableControllRefreshTypeBoth;//支持下拉刷新  和上啦加载
    [self showLoadingView];
    //有url 变成request
    if (self.url.length) {
        LBNHHomeRequest *request = [[LBNHHomeRequest alloc] init];
        request.lb_url = self.url;
        self.request = request;
    }
//    [self loadData];
    [self.tableView.mj_footer beginRefreshing];
    
}




#pragma mark 刷新数据 加载更多
-(void)lb_refresh{
    [super lb_refresh];
    [self loadData];
}

//模拟加载更多 把原来的数据在加载一般
-(void)lb_loadMore{
    [super lb_loadMore];
    
    if (!self.request) return;
    [self.request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        LBNHHomeServiceDataModel *baseModel = [LBNHHomeServiceDataModel modelWithDictionary:response];
        for (int i = 0; i < baseModel.data.count; i++) {
            LBNHHomeServiceDataElement *element = baseModel.data[i];
            //                NHHomeServiceDataElementMediaTypeLargeImage = 1,
            //                /** Gif图片*/
            //                NHHomeServiceDataElementMediaTypeGif = 2,
            //                /** 视频*/
            //                NHHomeServiceDataElementMediaTypeVideo = 3,
            //                /** 小图*/
            //                NHHomeServiceDataElementMediaTypeLittleImages = 4,
            if (element.group && element.group.media_type <5) {
                [self.elementDataArray addObject:element];
                LBNHHomeCellFrame *cellFrame = [[LBNHHomeCellFrame alloc] init];
                cellFrame.model = element;
                [self.cellFrameArray addObject:cellFrame];
            }
        }
        [self lb_endLoadMore];
        NSLog(@"currentThread i s %@ ",[NSThread currentThread]);
        [self lb_reloadData];
    }];
    
}

-(void)dealloc{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

int lastOffset = 0;

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *value = change[@"new"];
        CGPoint offset = [value CGPointValue];
        if (abs(offset.y - lastOffset) > 150) {
            NSLog(@"LBLog 跳帧了=====");
        }
        NSLog(@"LBLog tableview content offset is %@ ",NSStringFromCGPoint(offset));
        lastOffset = offset.y;
    }
}

/**
 加载数据请求
 */
-(void)loadData{
    if (!self.request) return;
    [self.request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        
        LBNHHomeServiceDataModel *baseModel = [LBNHHomeServiceDataModel modelWithDictionary:response];
        //不是第一次加载  是刷新的
        if (_cellFrameArray != nil && baseModel.tip.length) {
            [LBViewUtils showRefreshInfo:[NSString stringWithFormat:@"增加了%@",response[@"tip"]] superView:self.view belowView:self.navigationItem.titleView];
            [self lb_endRefresh];
        }
        NSDictionary *dic = [NSDictionary new];
        
        for (int i = 0; i < baseModel.data.count; i++) {
            LBNHHomeServiceDataElement *element = baseModel.data[i];
            //                NHHomeServiceDataElementMediaTypeLargeImage = 1,
            //                /** Gif图片*/
            //                NHHomeServiceDataElementMediaTypeGif = 2,
            //                /** 视频*/
            //                NHHomeServiceDataElementMediaTypeVideo = 3,
            //                /** 小图*/
            //                NHHomeServiceDataElementMediaTypeLittleImages = 4,
            if (element.group && element.group.media_type <5) {
                [self.elementDataArray addObject:element];
                LBNHHomeCellFrame *cellFrame = [[LBNHHomeCellFrame alloc] init];
                cellFrame.model = element;
                [self.cellFrameArray addObject:cellFrame];
            }
        }
        NSLog(@"currentThread i s %@ ",[NSThread currentThread]);
        [self hiddenLoadingView];
        [self endRefreshIconAnimation];
        [self lb_reloadData];
    }];
}

#pragma mark tableViewDelegate的代理方法  我们这里都有子类去实现了  需要子类复写

/** 分组数量*/
- (NSInteger)lb_numberOfSections{
    return 1;
}

/** 某个分组的cell数量*/
- (NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    return self.cellFrameArray.count;
}

/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
//    LBNHHomeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LBNHHomeTableViewCell" forIndexPath:indexPath];
    LBNHHomeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LBNHHomeTableViewCell"];
    if (!cell) {
        cell = [[LBNHHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LBNHHomeTableViewCell"];
    }
    cell.delegate = self;
    cell.cellFrame = self.cellFrameArray[indexPath.row];
    NSLog(@"CELL ----- %p ",cell);
    return cell;
}

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    //去detail详情页
    LBNHDetailViewController *detailVC = [[LBNHDetailViewController alloc] initWithCellFrame:self.cellFrameArray[indexPath.row]];
    [self pushToVc:detailVC];
}

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    LBNHHomeCellFrame *cellFrmae = self.cellFrameArray[indexPath.row];
    return cellFrmae.cellHeight;
}

-(BOOL)lb_showHightLigthRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

/** 某个组头*/
//- (UIView *)lb_headerAtSection:(NSInteger)section{
//    
//}
//
///** 某个组尾*/
//- (UIView *)lb_footerAtSection:(NSInteger)section{
//    
//}
//
///** 某个组头高度*/
//- (CGFloat)lb_sectionHeaderHeightAtSection:(NSInteger)section{
//    
//}
//
///** 某个组尾高度*/
//- (CGFloat)lb_sectionFooterHeightAtSection:(NSInteger)section{
//    
//}


#pragma mark homeTableViewCell的事件的回调

-(void)homeTableViewCellCategoryClicked:(LBNHHomeTableViewCell *)cell{
    if (self.isCategory) {
        return;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LBNHHomeCellFrame *cellFrame = self.cellFrameArray[indexPath.row];
    LBNHHomeServiceDataElement *element = cellFrame.model;
    LBDiscoveryCategoryController *cateVc = [[LBDiscoveryCategoryController alloc] initWithCategoryId:element.group.category_id];
    cateVc.navigationItem.title = element.group.category_name;
    [self pushToVc:cateVc];
    
}

/** 点击个人头像 去个人中心的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell goToPersonalCenterWithUserInfo:(LBNHUserInfoModel *)userInfo{
    NSLog(@"goto detail vc========");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LBNHHomeCellFrame *cellFrame = self.cellFrameArray[indexPath.row];
    LBNHHomeServiceDataElement *element = cellFrame.model;
    LBNHPersonalCenterController *vc = [[LBNHPersonalCenterController alloc] initWithUserInfo:element.group.user];
    [self pushToVc:vc];
}


/** 点赞一栏的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell thumBottonItemClicked:(LBThumBottomClickItemType)itemType{
    //获取点击的indexPath
    NSIndexPath *indexPath =[self.tableView indexPathForCell:cell];
    switch (itemType) {
        case LBThumBottomClickItemTypeThum:
            [self requestThumBarWithActionName:@"digg" indexPath:indexPath];
            break;
        case LBThumBottomClickItemTypeStep:
            [self requestThumBarWithActionName:@"bury" indexPath:indexPath];
            break;
        case LBThumBottomClickItemTypeComment:
            
            break;
        case LBThumBottomClickItemTypeShare:
            {
                LBShareBottomView * shareView = [[LBShareBottomView alloc] init];
                [shareView showDefault];
            }
            break;
            
        default:
            break;
    }
}


/** 点浏览大图的回调  点击的索引  以及urls */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell didClickedImageView:(LBCustomLongImageView *)imageView currentIndex:(NSInteger)currentIndex urls:(NSArray <NSURL *>*)urls{
    SDPhotoBrowser *photoBrowser = [[SDPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = currentIndex;
    photoBrowser.imageCount = urls.count;
//    photoBrowser.sourceImagesContainerView = imageView;
    photoBrowser.currentImageView = imageView;
    self.littleImagesURLs = urls;
    self.selectedImage = imageView.originalLongImage ? imageView.originalLongImage : imageView.image;
    
    [photoBrowser show];
}

///** 默认显示的图片  不是高质量的 */
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
//    
//}
///** 显示高质量图片的url */
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
//    return self.littleImagesURLs[index];
//}
/** 点播放视频的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell didClickedVideo:(NSString *)videoUrl videoCoverImage:(LBNHBaseImageView *)coverImageView{
    self.videoIndexPath = [self.tableView indexPathForCell:cell];
    self.videoSuperView = coverImageView;
    //创建视频  记录当前播放的indexpath  和视频的superView
    self.wmPlayer = [[WMPlayer alloc] initWithFrame:coverImageView.bounds];
    self.wmPlayer.URLString = videoUrl;
    self.wmPlayer.delegate = self;
    [coverImageView addSubview:self.wmPlayer];
    [self.wmPlayer play];
    
}

#pragma mark 播放器的daili

//点击播放暂停按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
    
}
//点击关闭按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    if (self.wmPlayer.isFullscreen) {
        self.wmPlayer.isFullscreen = NO;
        [self videoToCell];
    }else{
        [self releaseWMPlayer];
    }
}
//点击全屏按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (fullScreenBtn.isSelected) {//全屏
        _wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];//设置更行状态栏
        [self videoToFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
        [UIViewController attemptRotationToDeviceOrientation];
        //        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    }else{
        if (self.isWindowVideo) {
            [self videoToWindowSmall];
        }else{
            [self videoToCell];
        }
    }
}
//单击WMPlayer的代理方法
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    NSLog(@"singleTaped =====  ");
}
//双击WMPlayer的代理方法
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{

}
//播放失败的代理方法
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    
}
//准备播放的代理方法
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    
}
//播放完毕的代理方法 释放资源
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    [self releaseWMPlayer];
}

/** 在Window上播放 右下角 */
-(void)videoToWindowSmall{
    [_wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        _wmPlayer.transform = CGAffineTransformIdentity;
        CGFloat height = kScreenHeight *0.35;
        _wmPlayer.frame = CGRectMake(kScreenWidth/2, kScreenWidth-kTabbarHeight-height, kScreenWidth/2, height);
        _wmPlayer.playerLayer.frame = _wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:_wmPlayer];
        //重新约束子控件
        [_wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_wmPlayer);
            make.height.mas_equalTo(40);
        }];
        
        [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_wmPlayer);
            make.width.mas_equalTo(_wmPlayer);
            make.height.mas_equalTo(40);
        }];
        
        [_wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_wmPlayer.topView).offset(45);
            make.right.mas_equalTo(_wmPlayer.topView).offset(-45);
            make.center.equalTo(_wmPlayer.topView);
            make.top.equalTo(_wmPlayer.topView);
        }];
        
        [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_wmPlayer).offset(5);
            make.top.mas_equalTo(_wmPlayer).offset(5);
            make.height.width.mas_equalTo(30);
        }];
        
        [_wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_wmPlayer);
            make.width.mas_equalTo(_wmPlayer);
            make.height.mas_equalTo(30);
        }];
    } completion:^(BOOL finished) {
        _wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        [UIViewController attemptRotationToDeviceOrientation];
        _wmPlayer.fullScreenBtn.selected = NO;
        self.isWindowVideo = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_wmPlayer];;
    }];
}
//半屏 在cell上显示的方法
-(void)videoToCell{
    //先移除不管是在window上还是imageView上
    [_wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        _wmPlayer.transform = CGAffineTransformIdentity;
        _wmPlayer.frame = self.videoSuperView.bounds;
        _wmPlayer.playerLayer.frame = _wmPlayer.bounds;
        [self.videoSuperView addSubview:_wmPlayer];
        [self.videoSuperView bringSubviewToFront:_wmPlayer];
        
        //重新约束子控件
        [_wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_wmPlayer);
            make.height.mas_equalTo(40);
        }];
        
        [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_wmPlayer);
            make.left.equalTo(_wmPlayer);
            make.width.mas_equalTo(_wmPlayer);
            make.height.mas_equalTo(40);
        }];
        
        [_wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_wmPlayer.topView).offset(45);
            make.right.mas_equalTo(_wmPlayer.topView).offset(-45);
            make.center.equalTo(_wmPlayer.topView);
            make.top.equalTo(_wmPlayer.topView);
        }];
        
        [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_wmPlayer).offset(5);
            make.top.mas_equalTo(_wmPlayer).offset(5);
            make.height.width.mas_equalTo(30);
        }];
        
        [_wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_wmPlayer);
            make.width.mas_equalTo(_wmPlayer);
            make.height.mas_equalTo(30);
        }];
        
    } completion:^(BOOL finished) {
        _wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        self.isWindowVideo = NO;
        _wmPlayer.fullScreenBtn.selected = NO;
    }];
}
//全屏
-(void)videoToFullScreenWithInterfaceOrientation:(UIInterfaceOrientation)orientation{
//    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO]; 
    [self.wmPlayer removeFromSuperview];
    [UIViewController attemptRotationToDeviceOrientation];
    self.wmPlayer.transform = CGAffineTransformIdentity;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        self.wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if (orientation == UIInterfaceOrientationLandscapeRight){
        self.wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    _wmPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _wmPlayer.playerLayer.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
    //重新设置约束  虽然坐标点在坐上角  但是宽高已经改变了  需要计算
    [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wmPlayer).offset(kScreenWidth-40);
        make.left.equalTo(_wmPlayer);
        make.width.mas_equalTo(kScreenHeight);
        make.height.mas_equalTo(40);
    }];
    
    [_wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wmPlayer);
        make.left.equalTo(_wmPlayer);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(kScreenHeight);
    }];
    
    [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wmPlayer).offset(10);
        make.top.offset(10);
        make.height.width.mas_equalTo(30);
    }];
    
    
    [_wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
    }];
    NSLog(@"_wmplayer frame si %@ ",NSStringFromCGRect(_wmPlayer.frame));
    //虽然坐标点在坐上角  但是宽高已经改变了  需要计算
    [_wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(kScreenHeight/2-37/2, kScreenWidth/2-37/2));
    }];
    
    [_wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_wmPlayer);
        make.width.mas_equalTo(kScreenHeight);
        make.height.mas_equalTo(30);
    }];
    
    _wmPlayer.fullScreenBtn.selected = YES;
    [_wmPlayer bringSubviewToFront:_wmPlayer.bottomView];
    
//    for (UIView *view in _wmPlayer.subviews) {
//        [view showRedBorder];
//    }
    [[UIApplication sharedApplication].keyWindow addSubview:_wmPlayer];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_wmPlayer];
}

#pragma mark 释放播放器资源
-(void)releaseWMPlayer{
    [self.wmPlayer pause];
    [self.wmPlayer removeFromSuperview];
    [self.wmPlayer.playerLayer removeFromSuperlayer];
    [self.wmPlayer resetWMPlayer];
}
#pragma mark  photoBrowser的代理
-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return self.selectedImage;
}

#pragma mark 设置状态栏的隐藏与否 需要与setNeedsStatusBarAppearanceUpdate 一起使用才生效
-(BOOL)prefersStatusBarHidden{
    if (_wmPlayer.superview) {
        if (_wmPlayer.isFullscreen) {
            return YES;
        }
    }
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (_wmPlayer.isFullscreen) {
        return UIStatusBarStyleLightContent;
    }else{
        
        return UIStatusBarStyleDefault;
    }
}

//add for 调整状态栏方向
-(BOOL)shouldAutorotate{
    return NO;
}

#pragma mark 计算cell是否滑出去一定距离  暂停播放视频
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //如果播放器的父控件在 播放器就在
    if (_wmPlayer.superview) {
        //1. 获取当前indexpath在tableview中的位置
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.videoIndexPath];
        //2. 转换当前区域在Controller中的view的位置
        CGRect rectInVCView = [self.tableView convertRect:rectInTableView toView:self.tableView.superview];
        //3.判断这个区域的y是否在可播放区域
        if (rectInVCView.origin.y<-self.videoSuperView.height||rectInVCView.origin.y>kScreenHeight - kTabbarHeight - kNavibarHeight) {
            //4.判断是否在window上播放 是 不处理继续播放  不是 取消播放 释放资源
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:_wmPlayer]&&self.isWindowVideo) {
                self.isWindowVideo =YES;
            }else{
                [self releaseWMPlayer];
            }
        }else{
            //在可视区域  不在window上  不处理 在window上 释放
            if ([self.videoSuperView.subviews containsObject:_wmPlayer]) {
                
            }else{
                [self releaseWMPlayer];
            }
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self releaseWMPlayer];
}


/** 处理点赞请求的数据 */
-(void)requestThumBarWithActionName:(NSString *)actionName indexPath:(NSIndexPath *)indexPath{
    LBNHHomeCellFrame *cellFrame = self.cellFrameArray[indexPath.row];
    LBNHHomeServiceDataElement *element = cellFrame.model;
    if ([actionName isEqualToString:@"digg"]) {
        if (element.group.user_digg) {
            [LBTips showTips:@"你已顶过"];
            return;
        }else if (element.group.user_bury){
            [LBTips showTips:@"你已踩过"];
            return;
        }
    }else if ([actionName isEqualToString:@"bury"]){
        if (element.group.user_digg) {
            [LBTips showTips:@"你已顶过"];
            return;
        }else if (element.group.user_bury){
            [LBTips showTips:@"你已踩过"];
            return;
        }
    }
    LBNHThumRequest *request = [[LBNHThumRequest alloc] init];
    request.actionName = actionName;
    request.lb_url = kNHHomeDynamicLikeAPI;
    request.group_id = element.group.ID;
    LBNHHomeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    WeakObject(weakCell, cell);
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        
        if ([actionName isEqualToString:@"digg"]) {
            if (success) {
                [weakCell didDigg];
            }else
            {
                [LBTips showTips:@"请求失败，稍后再试"];
            }
        }else if ([actionName isEqualToString:@"bury"]){
            if (success) {
                [weakCell didBury];
            }else{
                [LBTips showTips:@"请求失败，稍后再试"];
            }
        }
    }];
    
}
//-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
//    return self.littleImagesURLs[index];
//}

#pragma mark 懒加载数组

-(NSMutableArray *)cellFrameArray{
    if (!_cellFrameArray) {
        _cellFrameArray = [NSMutableArray new];
    }
    return _cellFrameArray;
}

-(NSMutableArray *)elementDataArray{
    if (!_elementDataArray) {
        _elementDataArray = [NSMutableArray new];
    }
    return _elementDataArray;
}
@end
