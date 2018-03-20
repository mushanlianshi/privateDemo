//
//  LBNHSearchRequest.h
//  nhExample
//
//  Created by liubin on 17/4/6.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseRequest.h"


/**
 * 搜索的请求
 */
@interface LBNHSearchRequest : LBNHBaseRequest
/** 搜索的关键字 */
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) NSInteger offset;
@end
