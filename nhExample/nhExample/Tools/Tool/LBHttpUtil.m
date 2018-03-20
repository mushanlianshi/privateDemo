//
//  LBHttpUtil.m
//  nhExample
//
//  Created by liubin on 17/4/27.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBHttpUtil.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

NSString *const LBNetWorkStateChangedNofication = @"LBNetWorkStateChangedNofication";

@implementation LBHttpUtil

+(void)startObervserNetWork{
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [reachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                MyLog(@"LBLog 未知网络 ================");
                [LBHttpUtil sharedLBHttpUtil].netState = LBNetworkStateUnknow;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                MyLog(@"LBLog 没有网络 ================");
                [LBHttpUtil sharedLBHttpUtil].netState = LBNetworkStateNone;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                MyLog(@"LBLog WIFI网络 ================");
                [LBHttpUtil sharedLBHttpUtil].netState = LBNetworkStateWiFi;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                MyLog(@"LBLog 数据网络 ================");
                [LBHttpUtil sharedLBHttpUtil].netState = LBNetworkStateIphone;
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:LBNetWorkStateChangedNofication object:@([LBHttpUtil sharedLBHttpUtil].netState)];
    }];
    [reachManager startMonitoring];
}




single_implementation(LBHttpUtil)

@end
