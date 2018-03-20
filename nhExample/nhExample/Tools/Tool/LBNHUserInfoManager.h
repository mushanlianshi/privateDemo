//
//  LBNHUserInfoManager.h
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBNHUserInfoModel;

/**
 * 管理用户登录 账号的管理类
 */
@interface LBNHUserInfoManager : NSObject

/** 用户的id */
@property (nonatomic, assign, readonly) NSInteger userID;

/**
 * 登录成功  保存用户信息
 */
-(void)didLoginInWithUserInfo:(LBNHUserInfoModel *)userInfo;

/**
 * 登录成功  保存用户信息 根据字典数据保存
 */
-(void)didLoginInWithUserInfoDic:(NSDictionary *)userInfoDic;

/**
 * 退出账号
 */
-(void)didLogout;


/**
 * 获取当前登录的用户信息
 */
-(LBNHUserInfoModel *)currentLoginUserInfo;

/**
 * 更新当前用户信息
 */
-(void)refreshUserInfoWithUserInfo:(LBNHUserInfoModel *)userInfo;


/**
 * 当前账号是否登录
 */
@property (nonatomic, assign) BOOL isLogin;

single_interface(LBNHUserInfoManager)

@end
