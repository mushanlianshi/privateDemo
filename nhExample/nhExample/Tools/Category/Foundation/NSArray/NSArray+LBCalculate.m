//
//  NSArray+LBCalculate.m
//  nhExample
//
//  Created by liubin on 17/3/24.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "NSArray+LBCalculate.h"



@implementation NSArray (LBCalculate)

/** 数组求和 */
-(CGFloat)lb_sum{
    return [[self valueForKeyPath:@"@sum.floatValue"] floatValue];
}

/** 数组求平均值 */
-(CGFloat)lb_avg{
    return [[self valueForKeyPath:@"@avg.floatValue"] floatValue];
}

/** 数组最大值 */
-(CGFloat)lb_max{
    return [[self valueForKeyPath:@"@max.floatValue"] floatValue];
}


/** 数组最小值 */
-(CGFloat)lb_min{
    return [[self valueForKeyPath:@"@min.floatValue"] floatValue];
}


@end
