//
//  LBNHDetailViewController.m
//  nhExample
//
//  Created by liubin on 17/3/24.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHDetailViewController.h"
#import "LBNHHomeServiceDataModel.h"
#import "LBNHHomeTableViewCell.h"
#import "LBNHBaseTableView.h"
#import "LBNHDetailCell.h"
#import "LBNHDetailCommentRequest.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "LBBaseTableViewController.h"
#import "LBNHPersonalCenterController.h"
#import "LBNHThumRequest.h"


@interface LBNHDetailViewController()<LBNHHomeTableViewCellDelegate,LBNHDetailCellDelegate>{
    UITableView *_tableView;
}

@property (nonatomic, strong) LBNHSearchPostsCellFrame *searchCellFrame;

@property (nonatomic, strong) LBNHHomeCellFrame *cellFrame;

@property (nonatomic, strong) LBNHHomeTableViewCell *headerView;


/** 最近评论 */
@property (nonatomic, strong) NSMutableArray *lastestComments;

/** 热门评论 */
@property (nonatomic, strong) NSMutableArray *hotComments;

@end

@implementation LBNHDetailViewController

-(void)viewDidLoad{
    [self setUpNaviItems];
    self.tableView.tableHeaderView = self.headerView;
    [self loadData];
}

-(void)setUpNaviItems{
    self.navItemTitle = @"详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStylePlain target:self action:@selector(reportButtonClicked)];
    [self.tableView registerClass:[LBNHDetailCell class] forCellReuseIdentifier:@"LBNHDetailCell"];
}


-(instancetype)initWithSearchCellFrame:(LBNHSearchPostsCellFrame *)searchCellFrame{
    self = [super init];
    if (self) {
        self.searchCellFrame = searchCellFrame;
    }
    return self;
}

-(instancetype)initWithCellFrame:(LBNHHomeCellFrame *)cellFrame{
    self=[super init];
    if (self) {
        self.cellFrame = cellFrame;
        
    }
    return self;
}

-(void)loadData{
    //判断是主界面进来的还是搜索界面的  拼装数据
    if (self.cellFrame) {
        [self.cellFrame setModel:self.cellFrame.model isDetail:YES];
        self.headerView.cellFrame = self.cellFrame;
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, self.cellFrame.cellHeight);
    }else if (self.searchCellFrame){
        LBNHHomeCellFrame *cellFrame = [[LBNHHomeCellFrame alloc] init];
        LBNHHomeServiceDataElement *model = [[LBNHHomeServiceDataElement alloc] init];
        model.group = self.searchCellFrame.group;
        [cellFrame setModel:model isDetail:YES];
        self.headerView.cellFrame = cellFrame;;
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, cellFrame.cellHeight);
    }
    
    LBNHDetailCommentRequest *request = [[LBNHDetailCommentRequest alloc] init];
    request.lb_url = kNHHomeDynamicCommentListAPI;
    //判断是搜索跳过来的还是主界面的
    request.group_id =self.searchCellFrame ? self.searchCellFrame.group.ID : _cellFrame.model.group.ID;
    request.sort = @"hot";
    request.offset = 0;
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        if (success) {
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                if ([dic.allKeys containsObject:@"recent_comments"]) {
                    self.lastestComments = [LBNHHomeServiceDataElementComment modelArrayWithArray:response[@"recent_comments"]];
                }
                if ([dic.allKeys containsObject:@"top_comments"]){
                    self.hotComments = [LBNHHomeServiceDataElementComment modelArrayWithArray:response[@"top_comments"]];
                }
            }
        }else{
            [LBTips showTips:@"请求失败，稍后再试"];
        }
        [self lb_reloadData];
    }];
}

-(void)reportButtonClicked{
    NSLog(@"举报");
}

/** 分组数量*/
- (NSInteger)lb_numberOfSections{
    if (self.lastestComments.count && self.hotComments.count) {
        return 2;
    }else if (!self.lastestComments.count && !self.hotComments.count){
        return 0;
    }
    return 1;
}

/** 某个分组的cell数量*/
- (NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.lastestComments.count) {
            return self.lastestComments.count;
        }else{
            return self.hotComments.count;
        }
    }else if(section == 1){
        return self.hotComments.count;
    }
    return 0;
}

/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
//    LBNHDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LBNHDetailCell"];
    LBNHDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LBNHDetailCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[LBNHDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LBNHDetailCell"];
    }
    if (indexPath.section == 0) {
        if (self.lastestComments.count) {
            cell.commentModel = self.lastestComments[indexPath.row];
        }else{
            cell.commentModel = self.hotComments[indexPath.row];
        }
        
    }else if (indexPath.section == 1){
        cell.commentModel = self.hotComments[indexPath.row];
    }
    cell.delegate = self;
    NSLog(@"LBLog LBNHDetailCell %p ",cell);
    return cell;
}

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    
}

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.lastestComments.count) {
            CGFloat height = [self.tableView fd_heightForCellWithIdentifier:@"LBNHDetailCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                LBNHDetailCell *detailCell = (LBNHDetailCell *)cell;
                detailCell.commentModel = self.lastestComments[indexPath.row];
            }];
            return height;
        }else{
            CGFloat height = [self.tableView fd_heightForCellWithIdentifier:@"LBNHDetailCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                LBNHDetailCell *detailCell = (LBNHDetailCell *)cell;
                detailCell.commentModel = self.hotComments[indexPath.row];
            }];
            return height;
        }
        
    }else{
        CGFloat height = [self.tableView fd_heightForCellWithIdentifier:@"LBNHDetailCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            LBNHDetailCell *detailCell = (LBNHDetailCell *)cell;
            detailCell.commentModel = self.hotComments[indexPath.row];
        }];
        return height;
    }
    
//    return 80;
//    LBNHDetailCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    return cell.cellHeight;
}

/** 某个组头*/
- (UIView *)lb_headerAtSection:(NSInteger)section{
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 29, kScreenWidth, 1);
    layer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:1].CGColor;
    
    if (section == 0) {
        UILabel *label = [[UILabel alloc] init];
        label.frame =CGRectMake(0, 0, kScreenWidth, 30);
        label.textColor = kCommonHighLightRedColor;
        label.text = @"  热门评论";
        label.font = kFont(14);
        label.backgroundColor = [UIColor whiteColor];
        [label.layer addSublayer:layer];
        return label;
    }else{
        UILabel *label = [[UILabel alloc] init];
        label.frame =CGRectMake(0, 0, kScreenWidth, 30);
        label.textColor = kCommonHighLightRedColor;
        label.text = @"  新鲜评论";
        label.font = kFont(14);
        label.backgroundColor = [UIColor whiteColor];
        [label.layer addSublayer:layer];
        return label;
    }
}



-(LBNHHomeTableViewCell *)headerView{
    if (!_headerView) {
        _headerView = [[LBNHHomeTableViewCell alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}


/** 某个组头高度*/
- (CGFloat)lb_sectionHeaderHeightAtSection:(NSInteger)section{
    return 30;
}

-(NSMutableArray *)hotComments{
    if (!_hotComments) {
        _hotComments = [NSMutableArray new];
    }
    return _hotComments;
}

-(NSMutableArray *)lastestComments{
    if (!_lastestComments) {
        _lastestComments = [NSMutableArray new];
    }
    return _lastestComments;
}


#pragma mark header 点击的回调

/** 点击个人头像 去个人中心的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell goToPersonalCenterWithUserInfo:(LBNHUserInfoModel *)userInfo{
    LBNHPersonalCenterController *person = [[LBNHPersonalCenterController alloc] initWithUserInfo:self.cellFrame.model.group.user];
    [self pushToVc:person];
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
    
}


/** 点播放视频的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell didClickedVideo:(NSString *)videoUrl videoCoverImage:(LBNHBaseImageView *)coverImageView{
    
}

/** 关注的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell careButtonClicked:(UIButton *)careButton{
    
}



#pragma mark cell的回调

/** 头像点击的回调  去个人中心 */
-(void)detailCell:(LBNHDetailCell *)detailCell iconViewClicked:(LBNHBaseImageView *)iconView{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:detailCell];
    LBNHPersonalCenterController *person;
    LBNHHomeServiceDataElementComment *comment ;
    if (indexPath.section == 0) {
        comment = self.lastestComments[indexPath.row];
        person = [[LBNHPersonalCenterController alloc] initWithUserID:comment.user_id];
    }else if (indexPath.section == 1){
        comment = self.hotComments[indexPath.row];
        person = [[LBNHPersonalCenterController alloc] initWithUserID:comment.user_id];
    }
    [self pushToVc:person];
}


/** 处理点赞请求的数据 */
-(void)requestThumBarWithActionName:(NSString *)actionName indexPath:(NSIndexPath *)indexPath{
    LBNHHomeCellFrame *cellFrame = self.cellFrame;
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


@end
