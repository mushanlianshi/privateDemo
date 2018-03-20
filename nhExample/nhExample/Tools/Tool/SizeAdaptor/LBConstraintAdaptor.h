//
//  LBConstraintAdaptor.h
//  nhExample
//
//  Created by liubin on 17/5/9.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LBDeviceType){
    LBDeviceTypeIphone4s, // 320*480
    LBDeviceTypeIphone5s, // 320*568
    LBDeviceTypeIphone6s, // 375*667
    LBDeviceTypeIphone6p, // 414*736
};


//根据比例设置约束
#define LBLayoutValue(constraint) [LBConstraintAdaptor constraintWithValue:constraint]

//根据字体算出自动的字体
#define LBAdjustFont(fontSize) [LBConstraintAdaptor adjustFontWithSize:fontSize]

/**
 * 屏幕尺寸适配  以及字体大小适配
 * 适配用的工具
 */
@interface LBConstraintAdaptor : NSObject


/**
 * 根据传进去的值获取一个计算过得宽高值  以6s尺寸为准

 @param value 需要传的值
 @return 计算后的值
 */
+(CGFloat)constraintWithValue:(CGFloat)value;


/**
 根据传进去的size 不同屏幕返回不同尺寸大小的size

 @param fontSize 字体大小
 @return font
 */
+(UIFont *)adjustFontWithSize:(CGFloat)fontSize;


/**
 字体大小根据屏幕大小 计算出一个字体大小

 @param fontSize 字体大小
 @return 计算后的字体大小
 */
+(CGFloat)getAdjustFontSize:(CGFloat)fontSize;

+(id)sharedInstance;

@property (nonatomic, assign) LBDeviceType deviceType;

@end
