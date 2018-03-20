//
//  NSMutableDictionary+LBRutime.m
//  LBSamples
//
//  Created by liubin on 17/4/26.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "NSMutableDictionary+LBRutime.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (LBRutime)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:));
        Method lbMenthod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(lbSetObject:forKey:));
        method_exchangeImplementations(originalMethod, lbMenthod);
    });
}

-(void)lbSetObject:(id)object forKey:(NSString *)key{
    //1.存在  直接调交换后的方法 也就是最初的系统的方法
    if (object) {
        [self lbSetObject:object forKey:key];
    }else{
#ifdef DEBUG
        NSAssert(0, @"LBLog NSDictionary setobject:forKey the object cannot be nil =======");
#endif
        NSLog(@"LBLog NSDictionary setobject:forKey the object cannot be nil %@",self);
    }
}
@end
