//
//  LBAppStoreInfoModel.m
//  nhExample
//
//  Created by liubin on 17/4/25.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBAppStoreInfoModel.h"

@implementation LBAppStoreInfoModel




//不使用MJExtenstion  
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"currentVersionReleaseDate"]) {
        [self setValue:value forKey:@"lastPublishTime"];
    }else if ([key isEqualToString:@"description"]){
        [self setValue:value forKey:@"desc"];
    }else if ([key isEqualToString:@"artistName"]){
        [self setValue:value forKey:@"publishCompany"];
    }
}


//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{
//             @"lastPublishTime":@"currentVersionReleaseDate",
//             @"publishCompany":@"artistName"
//             };
//}
//
//+(id)modelWithDictionary:(NSDictionary *)dictionary{
//    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
//        return [self mj_objectWithKeyValues:dictionary];
//    }
//    return [[self alloc] init];
//}

-(void)dealloc{
    MyLog(@"LBLog appstoreInfoModel dealloc =======");
}

@end
