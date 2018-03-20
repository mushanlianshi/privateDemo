//
//  LBNHDynamicRequest.h
//  nhExample
//
//  Created by liubin on 17/3/23.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseRequest.h"


/**
 * 赞  踩的request
 */
@interface LBNHDynamicRequest : LBNHBaseRequest

/** bury 踩 是 6 digg 顶 是 5 */
@property (nonatomic, copy) NSString *action;

@property (nonatomic, assign) NSInteger group_id;

@end
