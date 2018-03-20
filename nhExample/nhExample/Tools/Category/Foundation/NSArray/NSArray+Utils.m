//
//  NSArray+Utils.m
//  nhExample
//
//  Created by baletu on 2018/1/30.
//  Copyright © 2018年 liubin. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)

/**
 * 归档的方式实现的深层深拷贝，如果数组里的是对象，是需要里面的对象实现归解档
 */
- (NSArray *)deeplyFullCopyArchive{
    //1.归档
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    //2.从新解档
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}



/**
 * 利用系统的方法实现深层深拷贝
 * 如果数组里是对象的话 需要这个对象实现copyWithZone方法
 */
- (NSArray *)deeplyFullCopySystem{
    NSArray *array = [[NSArray alloc] initWithArray:self copyItems:YES];
    return array;
}
@end
