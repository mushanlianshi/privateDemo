//
//  LBNHPersonalCenterController.m
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHPersonalCenterController.h"
#import "LBNHUserInfoModel.h"
#import "LBUtils.h"
#import "LBNHUserInfoManager.h"
#import "LBNHPersonalRequest.h"
#import "LBNHPersonalHeaderView.h"
#import "LBBaseTableViewController.h"
#import "LBNHBaseTableView.h"
#import "LBNHHomeTableViewCell.h"
#import "LBNHHomeCellFrame.h"
#import "LBNHPersonalHeaderSectionView.h"
#import "LBNHHomeServiceDataModel.h"
#import "SDPhotoBrowser.h"
#import "LBNHThumRequest.h"
#import "LBNHCustomNoDataEmptyView.h"
#import "LBNHFansAndAttentionController.h"
#import "LBNHDetailCell.h"
#import "LBNHDetailModel.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface LBNHPersonalCenterController ()<LBNHHomeTableViewCellDelegate,LBNHPersonalHeaderViewDelegate,LBNHPersonalHeaderSectionViewDelegate,SDPhotoBrowserDelegate>

@property (nonatomic, strong) LBNHUserInfoModel *userInfo;

@property (nonatomic, assign) NSInteger user_id;

/** 存放frame是数组 */
@property (nonatomic, strong) NSMutableArray *cellFrameArray;

/** tableview的头header */
@property (nonatomic, strong) LBNHPersonalHeaderView *headerView;

@property (nonatomic, assign) LBNHPersonalColumnType selectedColumnType;


/** 投稿等section的header */
@property (nonatomic, strong) LBNHPersonalHeaderSectionView *sectionHeader;

@property (nonatomic, strong) LBNHCustomNoDataEmptyView *emptyView;


@property (nonatomic, strong) NSArray *littleImagesURLs;
/** 记录选中的selectedImage */
@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation LBNHPersonalCenterController

-(instancetype)initWithUserInfo:(LBNHUserInfoModel *)userInfo{
    self=[super init];
    if (self) {
        _userInfo = userInfo;
    }
    return self;
}

-(instancetype)initWithUserID:(NSInteger)userID{
    self=[super init];
    if (self) {
        self.user_id = userID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarItem];
    [self loadData];
}
-(void)setNaviBarItem{
    self.navItemTitle  = @"个人中心";
//    self.navigationItem.title = @"个人中心";
    if ([LBUtils isCurrentLoginUserInfo:self.userInfo.user_id?self.userInfo.user_id:self.user_id]) {
        WS(weakSelf);
        [self setRightNaviItemTitle:@"退出登录" rightHandler:^(NSString *titleString) {
            [[LBNHUserInfoManager sharedLBNHUserInfoManager] didLogout];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    NSLog(@"self.frame is %@ ",NSStringFromCGRect(self.view.frame));
}

-(void)loadData{
    LBNHPersonalRequest *request = [LBNHPersonalRequest lb_request];
    request.lb_url = kNHUserProfileInfoAPI;
    request.user_id = self.userInfo.user_id?self.userInfo.user_id:self.user_id;
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        if (success) {
            NSLog(@"currentThread log is %@ ",[NSThread currentThread]);
            self.userInfo = [LBNHUserInfoModel modelWithDictionary:response];
            self.headerView.userInfoModel = self.userInfo;
            [self.tableView registerClass:[LBNHDetailCell class] forCellReuseIdentifier:@"LBNHDetailCell"];
            self.tableView.showsHorizontalScrollIndicator = YES;
            
            
        }else{
            [LBTips showTips:@"请求出错，稍后再试"];
        }
    }];
    
}


/**
 * 投稿 收藏 评论栏目的设置事件
 */
-(void)setSelectedColumnType:(LBNHPersonalColumnType)selectedColumnType{
    _selectedColumnType = selectedColumnType;
    NSString *url ;
    switch (selectedColumnType) {
        case LBNHPersonalColumnTypePublish:
            {
                url = kNHUserPublishDraftListAPI;
            }
            break;
        case LBNHPersonalColumnTypeCollection:
            {
                url = kNHUserColDynamicListAPI;
            }
            break;
        case LBNHPersonalColumnTypeComment:
            {
                url = kNHUserDynamicCommentListAPI;
            }
            break;
        }
    if (url) {
        LBNHPersonalRequest *request = [[LBNHPersonalRequest alloc] init];
        request.lb_url = url;
        request.user_id = self.userInfo.user_id ? self.userInfo.user_id :self.user_id;
        [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
            if (success) {
                NSLog(@"response is %@ ",response);
                [self.dataArray removeAllObjects];
                [self.cellFrameArray removeAllObjects];
                if (selectedColumnType == LBNHPersonalColumnTypePublish || selectedColumnType == LBNHPersonalColumnTypeCollection) {
                    LBNHHomeServiceDataModel *model = [LBNHHomeServiceDataModel modelWithDictionary:response];
                    for (LBNHHomeServiceDataElement *element in model.data) {
                        [self.dataArray addObject:element];
                        LBNHHomeCellFrame *cellFrame = [[LBNHHomeCellFrame alloc] init];
                        cellFrame.model = element;
                        [self.cellFrameArray addObject:cellFrame];
                    }
                    NSLog(@"currentThread log is %@ ",[NSThread currentThread]);
                    [self lb_reloadData];
                    //没有收藏 投稿的内容 显示emptyView
                    if (selectedColumnType == LBNHPersonalColumnTypePublish) {
                        [self showEmptyViewHidden:self.cellFrameArray.count content:@"不会发段子的土豪不是好逗比" imageName:@"nosubmission"];
                    }else if (selectedColumnType == LBNHPersonalColumnTypeCollection){
                        [self showEmptyViewHidden:self.cellFrameArray.count content:@"问君能有几多愁，恰似一个段子我没留" imageName:@"nocollection"];
                    }
                    
                }
                //评论的显示
                else if (selectedColumnType == LBNHPersonalColumnTypeComment){
                    for (NSDictionary *dic in response[@"data"]) {
                        LBNHHomeServiceDataElementComment *comment = [LBNHHomeServiceDataElementComment modelWithDictionary:dic[@"comment"]];
                        [self.dataArray addObject:comment];
                    }
                    [self lb_reloadData];
                    [self showEmptyViewHidden:self.dataArray.count content:@"发挥你的想象力，给别人评论一下去吧" imageName:@"nocomment"];
                }
            }else{
                [LBTips showTips:@"网络出错 稍后再试"];
            }
        }];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)cellFrameArray{
    if (!_cellFrameArray) {
        _cellFrameArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return _cellFrameArray;
}

-(LBNHPersonalHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[LBNHPersonalHeaderView alloc] init];
        _headerView.frame =CGRectMake(0, 64, kScreenWidth, 280);
        _headerView.delegate = self;
//        self.tableView.tableHeaderView = _headerView;
        self.tableView.tableHeaderView = _headerView;
    }
    return _headerView;
}

-(LBNHCustomNoDataEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[LBNHCustomNoDataEmptyView alloc] initWithTitle:@"" image:ImageNamed(@"nosubmission") desc:@"不会发段子的土豪不是好逗比"];
        _emptyView.frame = CGRectMake(0, 280+40, kScreenWidth, 200);
        [self.tableView  addSubview:_emptyView];
    }
    return _emptyView;
}

#pragma mark 显示没有数据的view
-(void)showEmptyViewHidden:(BOOL)isHidden content:(NSString *)content imageName:(NSString *)imageName{
    self.emptyView.hidden = isHidden;
    if (isHidden) {
        return;
    }
    self.emptyView.bottomLabel.text = content;
    self.emptyView.imageView.image = ImageNamed(imageName);
            if (self.tableView.height<320+self.emptyView.height) {
                NSLog(@"self.tableView height %f %f",self.tableView.height,self.emptyView.height);
    //            self.tableView.height = 320+self.emptyView.height;
                self.tableView.contentSize  =CGSizeMake(kScreenWidth, 320+self.emptyView.height);
            }
    
    
//    self.tableView.contentSize = CGSizeMake(kScreenWidth, 150);
//    self.tableView.contentOffset = CGPointMake(0, 400);
//    NSLog(@"self.tableView contentsize is %@ ",NSStringFromCGSize(self.tableView.contentSize));
}

#pragma mark 重写reloaddata  处理下tableView的显示
//-(void)lb_reloadData{
//    [super lb_reloadData];
//    if (self.emptyView.isHidden) {
//        self.tableView.frame = self.view.bounds;
//    }else{
//        //调节显示没有图片的位置
//        if (self.tableView.height<320+self.emptyView.height) {
//            NSLog(@"self.tableView height %f %f",self.tableView.height,self.emptyView.height);
////            self.tableView.height = 320+self.emptyView.height;
//            self.tableView.contentSize  =CGSizeMake(kScreenWidth, 320+self.emptyView.height);
//        }
//    }
//}

#pragma mark table数据源的方法
-(NSInteger)lb_numberOfSections{
    return 1;
}
-(NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    if (self.selectedColumnType == LBNHPersonalColumnTypeComment) {
        return self.dataArray.count;
    }
    return self.cellFrameArray.count;
}
-(CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedColumnType == LBNHPersonalColumnTypeComment) {
        return [self.tableView fd_heightForCellWithIdentifier:@"LBNHDetailCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            LBNHDetailCell *detailCell = (LBNHDetailCell *)cell;
            detailCell.commentModel = self.dataArray[indexPath.row];
        }];
    }else{
        LBNHHomeCellFrame *cellFrame = self.cellFrameArray[indexPath.row];
        NSLog(@"cellFrame height is %f " ,cellFrame.cellHeight);
        return cellFrame.cellHeight;
    }
}
/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedColumnType == LBNHPersonalColumnTypePublish || self.selectedColumnType == LBNHPersonalColumnTypeCollection) {
        LBNHHomeTableViewCell *cell = [[LBNHHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LBNHHomeTableViewCell"];
        cell.cellFrame = self.cellFrameArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }else if (self.selectedColumnType == LBNHPersonalColumnTypeComment){
//        LBNHDetailCell *cell = [[LBNHDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LBNHDetailCell"];
        LBNHDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LBNHDetailCell" forIndexPath:indexPath];
        cell.commentModel = self.dataArray[indexPath.row];
        return cell;
    }
    return nil;
}
-(UIView *)lb_headerAtSection:(NSInteger)section{
    return self.sectionHeader;
}

-(CGFloat)lb_sectionHeaderHeightAtSection:(NSInteger)section{
    return 40.f;
}

-(LBNHPersonalHeaderSectionView *)sectionHeader{
    if (!_sectionHeader) {
        _sectionHeader = [[LBNHPersonalHeaderSectionView alloc] initWithTitles:@[@"投稿",@"收藏",@"评论"]];
        _sectionHeader.frame = CGRectMake(0, 0, kScreenWidth, 30);
        _sectionHeader.backgroundColor = [UIColor whiteColor];
        _sectionHeader.delegate = self;
        [_sectionHeader defaultClickedIndex:0];
    }
    return _sectionHeader;
}

#pragma mark headerView的delegate
-(void)personalHeaderView:(LBNHPersonalHeaderView *)headerView clickedIndex:(NSInteger)index{
    NSLog(@"personalHeaderView %ld",index);
    LBNHFansAndAttentionController *vc = [[LBNHFansAndAttentionController alloc] initWithUserId:self.userInfo.user_id?self.userInfo.user_id:self.user_id attentionType:index];
    [self pushToVc:vc];
}

#pragma mark sctionHeader的delegate
-(void)personalSectionView:(LBNHPersonalHeaderSectionView *)sectionView clickedIndex:(NSInteger)index{
    NSLog(@"personalSectionView %ld",index);
    self.selectedColumnType = index;
}


#pragma mark homeTableViewCell的事件的回调
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
            
            break;
            
        default:
            break;
    }
}


/** 点浏览大图的回调  点击的索引  以及urls */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell didClickedImageView:(UIImageView *)imageView currentIndex:(NSInteger)currentIndex urls:(NSArray <NSURL *>*)urls{
    SDPhotoBrowser *photoBrowser = [[SDPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = currentIndex;
    photoBrowser.imageCount = urls.count;
    //    photoBrowser.sourceImagesContainerView = imageView;
    photoBrowser.currentImageView = imageView;
    self.littleImagesURLs = urls;
    self.selectedImage = imageView.image;
    [photoBrowser show];
}


/** 点播放视频的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell didClickedVideo:(NSString *)videoUrl videoCoverImage:(LBNHBaseImageView *)coverImageView{
    
}

#pragma mark  photoBrowser的代理
-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return self.selectedImage;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
