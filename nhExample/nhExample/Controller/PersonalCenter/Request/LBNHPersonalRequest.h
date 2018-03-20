//
//  LBNHPersonalRequest.h
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseRequest.h"


/**
 * 个人信息请求的类
 */
@interface LBNHPersonalRequest : LBNHBaseRequest

@property (nonatomic, assign) NSInteger user_id;

@end
