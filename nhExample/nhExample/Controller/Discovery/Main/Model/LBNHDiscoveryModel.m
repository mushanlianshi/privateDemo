//
//  LBNHDiscoveryModel.m
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHDiscoveryModel.h"
#import "MJExtension.h"

@implementation LBNHDiscoveryModel

@end

@implementation LBNHDiscoveryGodComment



@end

@implementation LBNHDiscoveryCategories
+(NSDictionary *)mj_objectClassInArray{
    return @{@"category_list":NSStringFromClass([LBNHDiscoveryCategoryElement class])};
}
@end

@implementation LBNHDiscoveryCategoryElement


@end

@implementation LBNHDiscoveryRotate_banner

+(NSDictionary *)mj_objectClassInArray{
    return @{@"banners":NSStringFromClass([LBNHDiscoveryRotate_bannerElement class])};
}

@end

@implementation LBNHDiscoveryRotate_bannerElement



@end


@implementation LBNHDiscoveryRotate_bannerElement_urlModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"url_list":NSStringFromClass([LBNHDiscoveryRotate_bannerElement_urlModel_Url class])};
}

@end

@implementation LBNHDiscoveryRotate_bannerElement_urlModel_Url


@end


