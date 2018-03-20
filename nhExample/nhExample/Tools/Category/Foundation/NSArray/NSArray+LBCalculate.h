//
//  NSArray+LBCalculate.h
//  nhExample
//
//  Created by liubin on 17/3/24.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * array数组的一些计算值的分类
 */
@interface NSArray (LBCalculate)

/** 数组求和 */
-(CGFloat)lb_sum;

/** 数组求平均值 */
-(CGFloat)lb_avg;

/** 数组最大值 */
-(CGFloat)lb_max;


/** 数组最小值 */
-(CGFloat)lb_min;

@end
