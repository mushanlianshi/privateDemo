//
//  LBNHFileCacheManager.h
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 缓存文件管理类  一些模型保存的文件管理类的分类
 */
@interface LBNHFileCacheManager : NSObject

/**
 根据文件名把对象归档保存在沙盒路径    到沙盒里Cache
 */
+(BOOL)saveObjcet:(id)object byFileName:(NSString *)fileName;



/**
 根据文件名把归档保存的对象从沙盒中解档出来
 */
+(id)getObjectByFileName:(NSString *)fileName;

/** 获取字典  这样的对象的方法 */
+(NSDictionary *)getDictionaryByFilePath:(NSString *)filePath;

/**
 根据文件名移除cache中保存的文件
 */
+(void)removeObjectByFileName:(NSString *)fileName;


/**
 * NSUserDefault 保存信息
 */
+(void)saveUserData:(id)object forKey:(NSString *)key;

/**
 * NSUserDefault 获取保存的值
 */
+(id)readUserDataForKey:(NSString *)key;

@end
