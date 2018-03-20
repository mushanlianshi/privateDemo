//
//  LBNHPublishSelectColumnController.m
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHPublishSelectColumnController.h"
#import "LBNHBaseTableView.h"
#import "LBNHPublishSelectColumnRequest.h"
#import "LBNHPublishSelectColumnModel.h"
#import "MBProgressHUD+LBAddtion.h"
#import "LBNHPublishSelectColumnCell.h"
#import "LBNHFileCacheManager.h"

NSString *selectColumnCellID = @"LBNHPublishSelectColumnCell";

@interface LBNHPublishSelectColumnController()


@end

@implementation LBNHPublishSelectColumnController

-(void)viewDidLoad{
    [self setUPNaviItems];
    [self loadData];
}

-(void)setUPNaviItems{
    self.navItemTitle = @"投稿选吧";
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

-(void)loadData{
    self.dataArray = [LBNHFileCacheManager getObjectByFileName:NSStringFromClass([LBNHPublishSelectColumnRequest class])];
    [self lb_reloadData];
    if (!self.dataArray) {
        [MBProgressHUD showLoading:self.view];
    }
    LBNHPublishSelectColumnRequest *request = [LBNHPublishSelectColumnRequest lb_request];
    request.lb_url = kNHUserPublishSelectDraftListAPI;
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        if (success) {
            NSArray *array;
            if ([response isKindOfClass:[NSArray class]]) {
                array = (NSArray *)response;
            }
            self.dataArray = [LBNHPublishSelectColumnModel modelArrayWithArray:array];
            [LBNHFileCacheManager saveObjcet:self.dataArray byFileName:NSStringFromClass([LBNHPublishSelectColumnRequest class])];
            [self lb_reloadData];
        }else{
            [MBProgressHUD showHintText:@"请求失败，稍后再试" superView:self.view];
        }
        [MBProgressHUD hidAllHudsInSuperView:self.view];
    }];
}

-(NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    LBNHPublishSelectColumnCell *cell = [self.tableView dequeueReusableCellWithIdentifier:selectColumnCellID];
    if (!cell) {
        cell = [[LBNHPublishSelectColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectColumnCellID];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    if (self.selectedHandler) {
        LBNHPublishSelectColumnModel *model = self.dataArray[indexPath.row];
        NSString *title = model.name;
        self.selectedHandler(self, title, model.ID);
        [self pop];
    }
}

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

@end
