//
//  LBNHBaseModel.h
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 基础模型类  可以归档保存  接档获取对象的基类  以及字典转对象   字典数组转模型数组 的
 * 主要保存用户信息  只保存一份在本地的信息的
 */
@interface LBNHBaseModel : NSObject


/**
 归档
 */
-(void)archive;

/**
 解档
 */
-(id)unArchive;


/**
 移除缓存中的数据
 */
-(void)remove;

/** 把一个模型转成字典类型 */
-(NSDictionary *)lbkeyValues;

/**
 字典数组 转模型数组的
 */
+(NSMutableArray *)modelArrayWithArray:(NSArray *)response;


/**
 字典转模型的
 */
+(id)modelWithDictionary:(NSDictionary *)dictionary;


/**
 *  模型包含模型数组
 */
+ (void)setUpModelClassInArrayWithContainDict:(NSDictionary *)dict;

@end
