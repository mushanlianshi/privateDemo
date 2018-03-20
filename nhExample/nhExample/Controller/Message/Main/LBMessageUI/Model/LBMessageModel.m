//
//  LBMessageModel.m
//  LBSamples
//
//  Created by liubin on 16/11/29.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "LBMessageModel.h"

@implementation LBMessageModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
