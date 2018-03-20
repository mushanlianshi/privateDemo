//
//  LBNHPersonalCenterController.h
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBBaseTableViewController.h"


/**
 * 栏目的分类
 */
typedef NS_ENUM(NSInteger, LBNHPersonalColumnType){
    LBNHPersonalColumnTypePublish = 0,  //投稿的
    LBNHPersonalColumnTypeCollection, //收藏的
    LBNHPersonalColumnTypeComment,  //评论的
};

@class LBNHUserInfoModel;

@interface LBNHPersonalCenterController : LBBaseTableViewController


/**
 * 根据用户信息  实例化一个个人信息页面
 */
-(instancetype)initWithUserInfo:(LBNHUserInfoModel *)userInfo;


/**
 * 根据用户id实例化一个用户信息界面
 */
-(instancetype)initWithUserID:(NSInteger )userID;

@end
