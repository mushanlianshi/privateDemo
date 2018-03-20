//
//  LBNHDetailCommentRequest.h
//  nhExample
//
//  Created by liubin on 17/3/25.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseRequest.h"


/**
 * 详情页 评论的请求接口
 */
@interface LBNHDetailCommentRequest : LBNHBaseRequest

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSString *sort;
@property (nonatomic, assign) NSInteger group_id;

@end
