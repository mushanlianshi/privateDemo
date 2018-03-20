//
//  LBNHHomeServiceDataModel.m
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomeServiceDataModel.h"
#import "LBNHUserInfoModel.h"
#import "MJExtension.h"

@implementation LBNHHomeServiceDataModel

/**
 告诉MJExtension data数组对应的数据模型
 */
+(NSDictionary *)mj_objectClassInArray{
    return @{@"data":NSStringFromClass([LBNHHomeServiceDataElement class])};
}

@end

@implementation LBNHHomeServiceDataElement
/**
 告诉MJExtension comments数组对应的数据模型
 */
+(NSDictionary *)mj_objectClassInArray{
    return @{@"comments":NSStringFromClass([LBNHHomeServiceDataElementComment class])};
}

@end

@implementation LBNHHomeServiceDataElementGroup

+(NSDictionary *)mj_objectClassInArray{
    return @{@"dislike_reason" :NSStringFromClass([LBNHHomeServiceDataElementGroupDislike_reason class]),
        @"large_image_list" : NSStringFromClass([LBNHHomeServiceDataElementGroupLargeImage class]),
        @"thumb_image_list" : NSStringFromClass([LBNHHomeServiceDataElementGroupLargeImage class])
    };
}


/**
 将属性名video_360P换成其他值 去字典里取360p_video值
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"video_360P": @"360p_video",
             @"video_720P": @"720p_video" ,
             @"video_480P":@"480p_video",
             };
}

@end

@implementation LBNHHomeServiceDataElementComment

+(NSDictionary *)mj_objectClassInArray{
    return @{@"reply_comments":NSStringFromClass([LBNHHomeServiceDataElementComment class])};
}

@end


@implementation LBNHHomeServiceDataElementGroupLargeImage

+(NSDictionary *)mj_objectClassInArray{
    return @{@"url_list" : NSStringFromClass([LBNHHomeServiceDataElementGroupLargeImageUrl class])};
}

-(NSInteger)height{
    if (_height == 0) {
        return 1;
    }
    return _height;
}

-(NSInteger)width{
    if (_width == 0) {
        return 1;
    }
    return _width;
}

@end

@implementation LBNHHomeServiceDataElementGroupLargeImageUrl



@end

@implementation LBNHHomeServiceDataElementGroupDislike_reason


@end

@implementation LBNHHomeServiceDataElementGroupLarge_Image

+(NSDictionary *)mj_objectClassInArray{
    return @{@"url_list" : NSStringFromClass([LBNHHomeServiceDataElementGroupLargeImageUrl class])};
}

@end






