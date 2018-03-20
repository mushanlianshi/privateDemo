//
//  NSObject+LBUnknowSelector.m
//  nhExample
//
//  Created by liubin on 17/4/26.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "NSObject+LBUnknowSelector.h"

@implementation NSObject (LBUnknowSelector)


-(id)forwardingTargetForSelector:(SEL)aSelector{
    if ([self respondsToSelector:aSelector]) {
        return self;
    }
    return nil;
}

@end
