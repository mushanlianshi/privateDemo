//
//  LBNHAttetionListViewController.m
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHAttetionListViewController.h"
#import "LBNHBaseRequest.h"
#import "LBNHAttetionListModel.h"
#import "LBNHAttentionListCell.h"
#import "LBBaseTableViewController.h"
#import "LBNHBaseTableView.h"
#import "LBNHPersonalCenterController.h"
#import "LBNHAttetionListRequest.h"

@interface LBNHAttetionListViewController ()<LBNHAttentionListCellDelegate>

@property (nonatomic, strong) LBNHBaseRequest *request;



@end

@implementation LBNHAttetionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐好友";
    //只能加载更多
    self.refreshType = LBBaseTableControllRefreshTypeLoadMore;
    [self loadData];
}

-(instancetype)initWithRequest:(LBNHBaseRequest *)request{
    self=[super init];
    if (self) {
        self.request = request;
    }
    return self;
}

-(void)loadData{
    if (self.request) {
        [self.request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
            if (success) {
                NSDictionary *dic = (NSDictionary *)response;
                if([dic.allKeys containsObject:@"users"]){
                    self.dataArray = [LBNHAttetionListModel modelArrayWithArray:response[@"users"]];
                }
                if (self.dataArray.count == 0) {
                    if ([dic.allKeys containsObject:@"recommend_users"]) {
                        self.dataArray = [LBNHAttetionListModel modelArrayWithArray:response[@"recommend_users"]];
                    }
                }
                [self lb_reloadData];
            }else{
                [LBTips showTips:@"加载出错  稍后再试"];
            }
        }];
    }
}

-(void)lb_loadMore{
    [super lb_loadMore];
    if ([self.request isKindOfClass:[LBNHAttetionListRequest class]]) {
        LBNHAttetionListRequest *request = (LBNHAttetionListRequest *)self.request;
        request.offset = request.offset+20;
        request.lb_url = self.request.lb_url;
        [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
            [self lb_endLoadMore];
            if (success) {
                NSDictionary *dic = (NSDictionary *)response;
                if ([dic.allKeys containsObject:@"users"]) {
                    NSArray *array = [LBNHAttetionListModel modelArrayWithArray:response[@"users"]];
                    [self.dataArray addObjectsFromArray:array];
                }
                if (self.dataArray.count == 0) {
                    if ([dic.allKeys containsObject:@"recommend_users"]) {
                        self.dataArray = [LBNHAttetionListModel modelArrayWithArray:response[@"recommend_users"]];
                    }
                }
                [self lb_reloadData];
            }else{
                [LBTips showTips:@"加载更多失败"];
            }
        }];
    }
}


#pragma mark tableView需要实现的方法

/** 分组数量*/
- (NSInteger)lb_numberOfSections{
    return 1;
}

/** 某个分组的cell数量*/
- (NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    LBNHAttentionListCell *cell = [[LBNHAttentionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LBNHAttentionListCell"];
    cell.attentionModel = self.dataArray[indexPath.row];
    cell.delegate = self;
    cell.selectedBackgroundView = [UIView new];
    return cell;
}

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    
}

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    return  75;
}

-(CGFloat)lb_sectionHeaderHeightAtSection:(NSInteger)section{
    return 44;
}

-(UIView *)lb_headerAtSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    label.text = @"    如此高逼格的段友怎能不关注？！";
    label.textColor = kCommonBlackColor;
    label.backgroundColor = [UIColor lightGrayColor];
    return label;
}

#pragma mark cell的代理

-(void)attentionListCell:(LBNHAttentionListCell *)attentionCell userIconTapped:(UIImageView *)iconView{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:attentionCell];
    LBNHAttetionListModel *model = self.dataArray[indexPath.row];
    LBNHPersonalCenterController *vc = [[LBNHPersonalCenterController alloc] initWithUserID:model.user_id];
    [self pushToVc:vc];
    NSLog(@"userIconTapped =======");
}

-(void)attentionListCell:(LBNHAttentionListCell *)attentionCell careUserClicked:(UIButton *)careButton{
    NSLog(@"attentionListCell =======");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:attentionCell];
    __block LBNHAttetionListModel *model = self.dataArray[indexPath.row];
    //模拟网络请求  发送关注状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        model.is_following = !model.is_following;
        [attentionCell setCareButtonIsCare:model.is_following];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
