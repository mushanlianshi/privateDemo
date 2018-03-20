//
//  LBNHHomeBaseViewController.h
//  nhExample
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//


/**
 请求结束的回调
 */
typedef void(^LBNHHomeRequestFinishHandler)(NSInteger dataCount);

#import "LBNHBaseModel.h"
#import "LBBaseTableViewController.h"
@class LBNHBaseRequest;

/**
 home界面的baseController  用来给子类集成用的
 */
@interface LBNHHomeBaseViewController : LBBaseTableViewController



-(instancetype)initWithUrl:(NSString *)url;

-(instancetype)initWithRequest:(LBNHBaseRequest *)request;

@property (nonatomic, copy)LBNHHomeRequestFinishHandler requestFinishHandler;

/** 是不是人们话题加载的  如果是点击就不在进去相同的界面 */
@property (nonatomic, assign) BOOL isCategory;

@end
