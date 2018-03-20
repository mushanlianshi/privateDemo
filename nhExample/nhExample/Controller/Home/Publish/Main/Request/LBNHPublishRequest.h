//
//  LBNHPublishRequest.h
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseRequest.h"


/**
 * 发表内容的请求
 */
@interface LBNHPublishRequest : LBNHBaseRequest

@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) BOOL is_anonymous;
@property (nonatomic, assign) NSString *text;
@property (nonatomic, assign) NSInteger user_id;

@end
