//
//  NSArray+Utils.h
//  nhExample
//
//  Created by baletu on 2018/1/30.
//  Copyright © 2018年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * NSArray的copy是浅copy   mutableCopy是深拷贝（单层深拷贝），数组里的内容对象还是原来的，只是copy出一个新地址指向的数组
 * NSMutableArray 的copy和mutableCopy都是深拷贝（单层深拷贝），数组里的对象的内容还是原来的，没有拷贝新的
 * 但mutableCopy不管是对NSArray还是NSMutableArray都是拷贝出来可变的对象，copy拷贝出来的对象是不可变的
 *
 * 此工具实现数组的深拷贝
 */
@interface NSArray (Utils)


/**
 * 归档的方式实现的深层深拷贝，如果数组里的是对象，是需要里面的对象实现归解档
 * encodeWithCoder initWithCoder
 */
- (NSArray *)deeplyFullCopyArchive;



/**
 * 利用系统的方法实现深层深拷贝
 * 如果数组里是对象的话 需要这个对象实现copyWithZone方法
 */
- (NSArray *)deeplyFullCopySystem;

@end


//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    //一般的归档
//    //    [aCoder encodeObject:_name forKey:@"name"];
//    //    [aCoder encodeInteger:_age forKey:@"age"];
//
//    //利用runtime进行归档
//    unsigned int count=0;
//    Ivar *ivars = class_copyIvarList([self class], &count);
//    for (int i=0 ; i<count; i++) {
//        //取出对应的成员变量
//        Ivar ivar=ivars[i];
//        //查看成员变量
//        const char *name=ivar_getName(ivar);
//        NSString *key=[NSString stringWithUTF8String:name];
//        NSLog(@"属性的名称是 %@ ",key);
//        //kvc 获取
//        [aCoder encodeObject:[self valueForKey:key] forKey:key];
//    }
//    free(ivars);
//}
//
//-(instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self=[super init];
//    if (self) {
//        //一般的接档
//        //        [aDecoder decodeObjectForKey:@"name"];
//        //        [aDecoder decodeIntegerForKey:@"age"];
//
//        //2.runtime接档
//        //利用runtime进行归档
//        unsigned int count=0;
//        Ivar *ivars = class_copyIvarList([self class], &count);
//        for (int i=0 ; i<count; i++) {
//            //取出对应的成员变量
//            Ivar ivar=ivars[i];
//            //查看成员变量
//            const char *name=ivar_getName(ivar);
//            NSString *key=[NSString stringWithUTF8String:name];
//            NSLog(@"属性的名称是 %@ ",key);
//            id value=[aDecoder decodeObjectForKey:key];
//            //kvc 设置value
//            [self setValue:value forKey:key];
//        }
//        free(ivars);
//    }
//    return self;
//}
//
//
//- (id)copyWithZone:(NSZone *)zone{
//    LBTest *test = [[LBTest alloc] init];
//    unsigned int count=0;
//    Ivar *ivars = class_copyIvarList([self class], &count);
//    for (int i=0 ; i<count; i++) {
//        //取出对应的成员变量
//        Ivar ivar=ivars[i];
//        //查看成员变量
//        const char *name=ivar_getName(ivar);
//        NSString *key=[NSString stringWithUTF8String:name];
//        NSLog(@"属性的名称是 %@ ",key);
//        id value=[self valueForKey:key];
//        //kvc 设置value
//        [test setValue:value forKey:key];
//    }
//    free(ivars);
//    return test;
//}
