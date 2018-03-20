//
//  NSArray+LBRuntime.m
//  tableNaviSample
//
//  Created by liubin on 17/3/6.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "NSArray+LBRuntime.h"
#import <objc/runtime.h>

@implementation NSArray (LBRuntime)

/**
 类或则分类在第一次加载内存的时候调用的   我们在这里实现方法的交换
 * 这里我们没实现  实在mutableArray的分类的load中实现了  不然分类调用super load会这次交换这个方法里的方法
 */
+(void)load{
//    [super load];
//    //如果用字符串的方法  请注意使用__NSArrayI 不是__NSArray也不是__NSArrayM 看崩溃信息就可以看出来
//    Method originalObjectAt = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:));
//    Method lbObjectAt = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(lbObjectAtIndex:));
//    method_exchangeImplementations(originalObjectAt, lbObjectAt);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //这里交换的才是NSArray的方法 __NSArrayI 而他的交换方法实现在NSArray中  必须实现  不然交换找不到方法
        Method originalArrayObjectAt = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:));
        Method lbArrayObjectAt = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(lbObjectAtIndex:));
        method_exchangeImplementations(originalArrayObjectAt, lbArrayObjectAt);
        
        //这里交换NSArray的类簇__NSSingleObjectArrayI的方法  创建方式NSArray *array3 = @[@"11"] 创建出来的是__NSSingleObjectArrayI
        Method singleOrignalObjectAt = class_getInstanceMethod(NSClassFromString(@"__NSSingleObjectArrayI"), @selector(objectAtIndex:));
        Method singleLBObjectAt = class_getInstanceMethod(NSClassFromString(@"__NSSingleObjectArrayI"), @selector(lbSingalObjectAtIndex:));
        method_exchangeImplementations(singleOrignalObjectAt, singleLBObjectAt);
        
        
        //这里交换NSArray的类簇__NSArray0的方法  创建方式NSArray *arrarOut = [NSArray new];
        Method zoreOrignalObjectAt = class_getInstanceMethod(NSClassFromString(@"__NSArray0"), @selector(objectAtIndex:));
        Method zoreLBObjectAt = class_getInstanceMethod(NSClassFromString(@"__NSArray0"), @selector(lbZoreObjectAtIndex:));
        method_exchangeImplementations(zoreOrignalObjectAt, zoreLBObjectAt);
        
        
        
    });
}



/**
 不管mutableArray中的这个方法是否实现了  这里都需要实现  不然NSArray的数组越界还是存在  因为那个是__NSArrayM的方法 这里才是__NSArrayI 的方法
 * 用来交换的方法
 */
-(id)lbObjectAtIndex:(NSInteger)index{
    if (index < self.count ) {
        return [self lbObjectAtIndex:index];
    }else{
#ifdef DEBUG
        NSAssert(0, @"LBLog objectAtIndex out of array bounds ========");
#endif
        NSLog(@"LBLog objectAtIndex out of array bounds ======== %@ ",self);
        return nil;
    }
}


/**
 * 为类簇__NSSingalObjectArrayI 准备的交换方法
 */
-(id)lbSingalObjectAtIndex:(NSInteger)index{
    if (index < self.count ) {
        return [self lbSingalObjectAtIndex:index];
    }else{
#ifdef DEBUG
        NSAssert(0, @"LBLog objectAtIndex out of array bounds ========");
#endif
        NSLog(@"LBLog objectAtIndex out of array bounds ======== %@ ",self);
        return nil;
    }
}

/**
 * 为类簇__NSArray0 准备的交换方法
 */
-(id)lbZoreObjectAtIndex:(NSInteger)index{
    if (index < self.count) {
        return [self lbZoreObjectAtIndex:index];
    }else{
#ifdef DEBUG
        NSAssert(0, @"LBLog objectAtIndex out of array bounds ========");
#endif
        NSLog(@"LBLog objectAtIndex out of array bounds ======== %@ ",self);
        return nil;
    }
}


@end
