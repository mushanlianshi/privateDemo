//
//  LBAppStoreCheckManager.h
//  nhExample
//
//  Created by liubin on 17/4/25.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBAppStoreInfoModel.h"

/** 不使用默认设置 获取到信息的回调 */
typedef void(^LBCheckNewInfoHandler)(LBAppStoreInfoModel *infoModel);


/**
 * 检测有没有新版本的工具类
 */
@interface LBAppStoreCheckManager : NSObject

/** 使用默认的alertController展示获取到的信息 处理逻辑*/
+(void)checkNewVersionAppId:(NSString *)appId currentController:(UIViewController *)currentController;

/** 不展示获取到的信息  只是把消息给传出去   UI自定义用 */
+(void)checkNewVersionAppInfoByID:(NSString *)appID appInfoHandler:(LBCheckNewInfoHandler)appInfoHandler;

@end
