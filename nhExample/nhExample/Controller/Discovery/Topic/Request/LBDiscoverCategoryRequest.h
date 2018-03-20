//
//  LBDiscoverCategoryRequest.h
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseRequest.h"

/** 热门分类的请求 */
@interface LBDiscoverCategoryRequest : LBNHBaseRequest
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger mpic;;
@property (nonatomic, assign) NSInteger message_cursor;
@end
