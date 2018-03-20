//
//  LBNHCommonConstant.h
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 一些常量的标示头文件
 */
@interface LBNHCommonConstant : NSObject

/** 是否登录的标示 */
UIKIT_EXTERN NSString *const KNHIsLoginFlag;

/** 应用启动时间的标示 */
UIKIT_EXTERN NSString *const KAPPLaunchTime;


/** 两次应用启动时间差  用来判断是否清楚SDWebimage的缓存 */
extern NSInteger const KAPPLaunchTimeOffset;

extern NSString *const KAPPADInfoKey;

/** 定义的一周时间 */
UIKIT_EXTERN NSInteger const KOneWeek;
/** 是否阅读了导览图 */
UIKIT_EXTERN NSString *const kAPPReadGuide;

/** 上次启动的应用版本号 */
UIKIT_EXTERN NSString *const kAPPLastVersion;

@end
