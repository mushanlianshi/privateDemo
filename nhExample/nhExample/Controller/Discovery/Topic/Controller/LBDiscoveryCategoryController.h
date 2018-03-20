//
//  LBDiscoveryCategoryControllerViewController.h
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBaseTableViewController.h"
@class LBNHDiscoveryCategoryElement;

/**
 * home页点击分类的controller 吐槽神剧、情感点滴类型
 */
@interface LBDiscoveryCategoryController : LBBaseTableViewController

/** 栏目的id */
-(instancetype)initWithCategoryId:(NSInteger)categoryId;

-(instancetype)initWithCategoryElement:(LBNHDiscoveryCategoryElement *)element;

@end
