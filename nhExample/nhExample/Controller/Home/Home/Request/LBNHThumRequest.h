//
//  LBNHThumRequest.h
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseRequest.h"

/**
 * 点赞等请求
 */
@interface LBNHThumRequest : LBNHBaseRequest

/**
 * 动作类型
 */
@property (nonatomic, copy) NSString *actionName;


/**
 * group的id
 */
@property (nonatomic, assign) NSInteger group_id;
@end
