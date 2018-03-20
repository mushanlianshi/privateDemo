//
//  LBFMDB.m
//  nhExample
//
//  Created by liubin on 17/4/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBFMDB.h"
#import "BGFMDB.h"

@implementation LBFMDB

//+ (void)isExistTableName:(NSString *)name complete:(void (^)(BOOL isExist))complete{
//    return [[BGFMDB intance] isExistWithTableName:name complete:^(BOOL isExist) {
//        if (complete) {
//            complete(isExist);
//        }
//    }];
//}
//+ (void)insertIntoTableName:(NSString *)name dict:(NSDictionary *)dict complete:(void (^)(BOOL isSuccess))complete{
//    [self isExistTableName:name complete:^(BOOL isExist) {
//        if (isExist) {
//            [[BGFMDB intance] insertIntoTableName:name Dict:dict complete:^(BOOL isSuccess) {
//                if (complete) {
//                    complete(isSuccess);
//                }
//            }];
//        }else{
//            //不存在创建
//            [[BGFMDB intance] createTableWithTableName:name keys:nil complete:^(BOOL isSuccess) {
//                
//            }];
//        }
//    }];
//}
//
//+ (void)quertTableName:(NSString *)name complete:(void (^)(BOOL isSuccess))complete{
//    
//}

@end
