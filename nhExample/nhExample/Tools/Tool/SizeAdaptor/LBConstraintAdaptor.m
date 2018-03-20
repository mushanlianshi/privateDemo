//
//  LBConstraintAdaptor.m
//  nhExample
//
//  Created by liubin on 17/5/9.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBConstraintAdaptor.h"

@implementation LBConstraintAdaptor

+(CGFloat)constraintWithValue:(CGFloat)value{
    CGFloat adaptorValue = 0;
    LBConstraintAdaptor *adaptor = [LBConstraintAdaptor sharedInstance];
    switch (adaptor.deviceType) {
        case LBDeviceTypeIphone6s:
            adaptorValue = value;
            break;
        case LBDeviceTypeIphone6p:
            adaptorValue = value * 1.103;
            break;
            
        default:
            adaptorValue = value * 0.851;
            break;
    }
    return adaptorValue;
}

+(UIFont *)adjustFontWithSize:(CGFloat)fontSize{
    return [UIFont systemFontOfSize:[self getAdjustFontSize:fontSize]];
}

+(CGFloat)getAdjustFontSize:(CGFloat)fontSize{
    CGFloat size = 0;
    LBConstraintAdaptor *adaptor = [LBConstraintAdaptor sharedInstance];
    switch (adaptor.deviceType) {
        case LBDeviceTypeIphone4s:
            size = fontSize * 0.851;
            break;
        case LBDeviceTypeIphone5s:
            size = fontSize * 0.851;
            break;
        case LBDeviceTypeIphone6s:
            size = fontSize ;
            break;
        case LBDeviceTypeIphone6p:
            size = fontSize * 1.103 ;
            break;
            
        default:
            size = fontSize;
            break;
    }
    return size;
}


static LBConstraintAdaptor *instance;
+(id)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
            instance.deviceType = [instance currentDeviceType];
        }
    });
    return instance;
}

/** 获取当前设备的类型 */
-(LBDeviceType)currentDeviceType{
    
    if (kScreenHeight == 480.f) {
        return LBDeviceTypeIphone4s;
    }else if (kScreenHeight == 568.f){
        return LBDeviceTypeIphone5s;
    }else if (kScreenHeight == 667.f){
        return LBDeviceTypeIphone6s;
    }
    return LBDeviceTypeIphone6p;
}

@end
