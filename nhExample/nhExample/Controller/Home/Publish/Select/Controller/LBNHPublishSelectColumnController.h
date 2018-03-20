//
//  LBNHPublishSelectColumnController.h
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//


#import "LBBaseTableViewController.h"
@class LBNHPublishSelectColumnController;

typedef void(^LBNHPublishSelectColumnSelecteddHandler)(LBNHPublishSelectColumnController *controller, NSString *title, NSInteger categoryId);

/**
 * 发布选择栏目的controller
 */
@interface LBNHPublishSelectColumnController : LBBaseTableViewController

@property (nonatomic, copy) LBNHPublishSelectColumnSelecteddHandler selectedHandler;

@end
