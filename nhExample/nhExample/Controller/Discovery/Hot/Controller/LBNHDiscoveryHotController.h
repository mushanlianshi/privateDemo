//
//  LBNHDiscoveryHotController.h
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBaseTableViewController.h"


typedef void(^LBDiscoveryHotScrollviewOffsetPoint)(CGPoint point);

/**
 * 热吧的controller
 */
@interface LBNHDiscoveryHotController : LBBaseTableViewController

@property (nonatomic, copy) LBDiscoveryHotScrollviewOffsetPoint scrollOffsetPoint;

@end
