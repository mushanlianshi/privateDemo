//
//  LBAppStoreInfoModel.h
//  nhExample
//
//  Created by liubin on 17/4/25.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MJExtension.h"

/**
 * 封装了在appStore的信息
 */
@interface LBAppStoreInfoModel : NSObject

/** 版本号 */
@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *desc;

/** 更新日志 */
@property (nonatomic, copy) NSString *releaseNotes;

/** 更新时间 */
@property (nonatomic, copy) NSString *lastPublishTime;

/** AppId */
@property (nonatomic, copy) NSString *AppId;

/** bundleId */
@property (nonatomic, copy) NSString *bundleId;

/** 售价 */
@property (nonatomic, assign) CGFloat price;

/** 发布公司 */
@property (nonatomic, copy) NSString *publishCompany;

/** appstore上的连接地址 */
@property (nonatomic, copy) NSString *trackViewUrl;

/** 字典转模型 */
//+(id)modelWithDictionary:(NSDictionary *)dictionary;

@end
