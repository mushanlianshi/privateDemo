//
//  LunarSolarConverter.h
//  testPush
//
//  Created by baletu on 2017/7/19.
//  Copyright © 2017年 baletu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
 *
 * 日历转换工具
 *
 */

@interface Lunar : NSObject
/**
 *是否闰月
 */
@property(assign) BOOL isleap;
/**
 *农历 日
 */
@property(assign) int lunarDay;
/**
 *农历 月
 */
@property(assign) int lunarMonth;
/**
 *农历 年
 */
@property(assign) int lunarYear;

@end

@interface Solar : NSObject
/**
 *公历 日
 */
@property(assign) int solarDay;
/**
 *公历 月
 */
@property(assign) int solarMonth;
/**
 *公历 年
 */
@property(assign) int solarYear;
@end


@interface LunarSolarConverter : NSObject
/**
 *农历转公历
 */
+ (Solar *)lunarToSolar:(Lunar *)lunar;

/**
 *公历转农历 例 2022-1-26 --> 2021-12-24
 */
+ (Lunar *)solarToLunar:(Solar *)solar;

/** 农历年月日转成 腊月初几这种形式的 2021-12-24  --> 2021年腊月二十四 */
+ (NSString *)formatlunarWithYear:(int)year AndMonth:(int)month AndDay:(int)day;

+ (NSString *)getXingzuoFromDate:(NSDate *)date;
@end

