//
//  LBHttpUtil.h
//  nhExample
//
//  Created by liubin on 17/4/27.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LBNetworkState){
    LBNetworkStateUnknow,   //位置网络
    LBNetworkStateNone,     //没有网络
    LBNetworkStateWiFi,     //wifi
    LBNetworkStateIphone,  //手机自带网络 4G/3G/2G
};

UIKIT_EXTERN NSString *const LBNetWorkStateChangedNofication;

/**
 *获取网络状态的工具类
 */
@interface LBHttpUtil : NSObject

/** 网络状态 */
@property (nonatomic, assign) LBNetworkState netState;

/** 开始监控网络状态的方法   在这里发通知  需要监控的接收到通知处理  也在这里面改变网络状态 */
+(void)startObervserNetWork;

single_interface(LBHttpUtil)

@end
