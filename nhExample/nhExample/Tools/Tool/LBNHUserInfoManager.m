//
//  LBNHUserInfoManager.m
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHUserInfoManager.h"
#import "LBNHUserInfoModel.h"
#import "LBNHFileCacheManager.h"

 

@implementation LBNHUserInfoManager


-(NSInteger)userID{
    return [self currentLoginUserInfo].user_id;
}

/**
 * 登录成功  保存用户信息
 */
-(void)didLoginInWithUserInfo:(LBNHUserInfoModel *)userInfo{
    [userInfo archive];
    [LBNHFileCacheManager saveUserData:@(YES) forKey:KNHIsLoginFlag];
}

/**
 * 登录成功  保存用户信息 根据字典数据保存
 */
-(void)didLoginInWithUserInfoDic:(NSDictionary *)userInfoDic{
    LBNHUserInfoModel *userInfo = [LBNHUserInfoModel modelWithDictionary:userInfoDic];
    [self didLoginInWithUserInfo:userInfo];
}


/**
 * 退出账号
 */
-(void)didLogout{
    [LBNHFileCacheManager removeObjectByFileName:NSStringFromClass([LBNHUserInfoModel class])];
    [LBNHFileCacheManager saveUserData:@(NO) forKey:KNHIsLoginFlag];
}


/**
 * 获取当前登录的用户信息
 */
-(LBNHUserInfoModel *)currentLoginUserInfo{
    return [LBNHFileCacheManager getObjectByFileName:NSStringFromClass([LBNHUserInfoModel class])];
}

/**
 * 更新当前用户信息
 */
-(void)refreshUserInfoWithUserInfo:(LBNHUserInfoModel *)userInfo{
    [userInfo archive];
}

-(BOOL)isLogin{
    return [[LBNHFileCacheManager readUserDataForKey:KNHIsLoginFlag] boolValue];
}

single_implementation(LBNHUserInfoManager)

@end
