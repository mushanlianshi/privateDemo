//
//  NSMutableArray+LBRuntime.m
//  tableNaviSample
//
//  Created by liubin on 17/3/6.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "NSMutableArray+LBRuntime.h"
#import <objc/runtime.h>
@implementation NSMutableArray (LBRuntime)


/**
 类或则分类在第一次加载内存的时候调用的   我们在这里实现方法的交换
 * 注意类簇的问题    __NSArrayM
 * NSArray 类簇 __NSArrayI  __NSSingleObjectArrayI  __NSArray0
 */
+(void)load{
    [super load]; //注意这里不要在super 以免array也实现了交换  这一super 又交换了一遍 和没交换一样
    //或则直接在这里交换__NSArrayI的方法
    
    //1.获取原来的方法  注意是__NSArrayM [self class]不行 圆形是__NSArrayM  看崩溃日志可以看出
    Method originalAdd = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    //2.获取现在的方法
    Method nowAdd = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(lbAddObject:));
    //3.交换方法
    method_exchangeImplementations(originalAdd, nowAdd);
    
    //交换的是NSMutableArray 的方法  __NSArrayM   NSArray的方法也需要交换 在下面
    Method originalObjectAt = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:));
    Method lbObjectAt = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(lbObjectAtIndex:));
    method_exchangeImplementations(originalObjectAt, lbObjectAt);
    
    
    
    
    
//    [objc_getClass("") swizz]
    
}




/**
  自己实现的方法   来替换原来的方法的
 * 注意这里已经交换方法了   所以方法里我们调用的是自己的方法也就是交换后的原生的方法
 */
-(void)lbAddObject:(id)object{
    //注意   因为addObject方法已经替换了  如果调用addObject会出现死循环
    if (object !=nil) {
        [self lbAddObject:object];
    }else{
//#ifdef DEBUG
        NSAssert(0, @"LBLog 添加空的数组了====");
//#endif
        NSLog(@"LBLog error add object is nil ================ %@ ",self);
        return;
    }
    
}

-(id)lbObjectAtIndex:(NSInteger)index{
    if (index < self.count ) {
        return [self lbObjectAtIndex:index];
    }else{
//#ifdef DEBUG
        NSAssert(0, @"LBLog error index out of array====");
//#endif
        NSLog(@"LBLog error index out of array ================ %@ ",self);
        return nil;
    }
}

@end
