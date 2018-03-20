//
//  LBNHUserInfoModel.h
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseModel.h"


/**
 用户信息的类  继承基类可以归解档保存
 */
@interface LBNHUserInfoModel : LBNHBaseModel
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger create_time;
@property (nonatomic, assign) NSInteger repin_count;
@property (nonatomic, assign) NSInteger new_followers;
@property (nonatomic, assign) BOOL user_verified;
@property (nonatomic, assign) NSInteger notification_count;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger point;
@property (nonatomic, assign) NSInteger ugc_count;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *large_avatar_url;
@property (nonatomic, assign) NSInteger subscribe_count;
@property (nonatomic, assign) NSInteger followers;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, assign) NSInteger followings;
@property (nonatomic, assign) BOOL is_following;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, copy) NSString *desc;
@end
