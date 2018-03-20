//
//  LBNHDiscoveryBookVController.m
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHDiscoveryBookController.h"
#import "LBNHDiscoveryBookRequest.h"
#import "LBNHDiscoveryModel.h"
#import "LBNHDiscoveryBookCell.h"
#import "MBProgressHUD+LBAddtion.h"
#import "LBNHBaseTableView.h"
#import "LBNHDetailViewController.h"
#import "LBNHFileCacheManager.h"
#import "NSFileManager+LBPath.h"

static NSString *LBBookCell = @"LBNHDiscoveryBookCell";

@interface LBNHDiscoveryBookController ()

@end

@implementation LBNHDiscoveryBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}


-(void)loadData{
    //先读取本地的数据  有新数据在刷新
    self.dataArray = [LBNHFileCacheManager getObjectByFileName:NSStringFromClass([LBNHDiscoveryBookRequest class])];
    [self lb_reloadData];
    if (!self.dataArray) {
        [MBProgressHUD showLoading:self.view];
    }
    LBNHDiscoveryBookRequest *request = [LBNHDiscoveryBookRequest lb_request];
    request.lb_url = kNHDiscoverSubscribeListAPI;
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        if (success) {
            [MBProgressHUD hidAllHudsInSuperView:self.view];
            self.dataArray = [LBNHDiscoveryCategoryElement modelArrayWithArray:response];
            //数据保存本地 下次先读本地在请求网络数据   有在更新
            [LBNHFileCacheManager saveObjcet:self.dataArray byFileName:NSStringFromClass([LBNHDiscoveryBookRequest class])];
            [self lb_reloadData];
        }else{
            [MBProgressHUD showHintText:@"请求失败，稍后再试" superView:self.view];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    LBNHDiscoveryBookCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LBBookCell];
    if (!cell) {
        cell = [[LBNHDiscoveryBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LBBookCell];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    LBNHDetailViewController *detailVC = [[LBNHDetailViewController alloc] init];
    [self pushToVc:detailVC];
}

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
