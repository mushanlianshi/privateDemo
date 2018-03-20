//
//  LBNHAttetionListRequest.h
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseRequest.h"


/**
 * 请求关注  或则  粉丝数据的请求
 */
@interface LBNHAttetionListRequest : LBNHBaseRequest


@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, assign) NSInteger homepage_user_id;

@end
