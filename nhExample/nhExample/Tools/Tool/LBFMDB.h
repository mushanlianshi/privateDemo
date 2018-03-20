//
//  LBFMDB.h
//  nhExample
//
//  Created by liubin on 17/4/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * FMDB 工具 隔离BGFMDB和FMDB工具
 */
@interface LBFMDB : NSObject
+ (void)isExistTableName:(NSString *)name complete:(void (^)(BOOL isExist))complete;
+ (void)insertIntoTableName:(NSString *)name dict:(NSDictionary *)dict complete:(void (^)(BOOL isSuccess))complete;
+ (void)quertTableName:(NSString *)name complete:(void (^)(BOOL isSuccess))complete;
@end
