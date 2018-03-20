//
//  LBNHAttetionListViewController.h
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBaseTableViewController.h"
@class LBNHBaseRequest;


/**
 * 展现关注粉丝列表的Controller
 */
@interface LBNHAttetionListViewController : LBBaseTableViewController


/**
 * 根据请求初始化一个Controller
 */
-(instancetype)initWithRequest:(LBNHBaseRequest *)request;

@end
