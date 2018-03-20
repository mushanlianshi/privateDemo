//
//  LBNHAttetionListModel.h
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseModel.h"


/**
 * 关注与粉丝数据的model
 */
@interface LBNHAttetionListModel : LBNHBaseModel
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger create_time;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *last_update;
@property (nonatomic, copy) NSString *screen_name;

@property (nonatomic, assign) BOOL is_following;
@property (nonatomic, assign) BOOL is_followed;
@property (nonatomic, assign) BOOL user_verified;
@end
