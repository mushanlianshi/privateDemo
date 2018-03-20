//
//  LBNHDiscoveryModel.h
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseModel.h"
@class LBNHDiscoveryGodComment, LBNHDiscoveryCategories,LBNHDiscoveryCategoryElement,LBNHDiscoveryRotate_banner,LBNHDiscoveryRotate_bannerElement,LBNHDiscoveryRotate_bannerElement_urlModel ,LBNHDiscoveryRotate_bannerElement_urlModel_Url;

/**
 * 发现页面的model 数据模型
 */
@interface LBNHDiscoveryModel : LBNHBaseModel
@property (nonatomic, strong) NSMutableArray *my_top_category_list;
@property (nonatomic, strong) NSMutableArray *my_category_list;

@property (nonatomic, strong) LBNHDiscoveryRotate_banner *rotate_banner;
@property (nonatomic, strong) LBNHDiscoveryCategories *categories;
@property (nonatomic, strong) LBNHDiscoveryGodComment *god_comment;
@end

/** 神评论 */
@interface LBNHDiscoveryGodComment : LBNHBaseModel
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger count;
@end


@interface LBNHDiscoveryCategories : LBNHBaseModel
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger category_count;

@property (nonatomic, strong) NSMutableArray <LBNHDiscoveryCategoryElement *>*category_list;
@end


@interface LBNHDiscoveryCategoryElement : LBNHBaseModel
@property (nonatomic, assign) BOOL is_recommend;
@property (nonatomic, assign) BOOL is_top;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL has_timeliness;
@property (nonatomic, assign) BOOL is_risk;

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *small_icon_url;
@property (nonatomic, copy) NSString *buttons;
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *small_icon;
@property (nonatomic, copy) NSString *channels;
@property (nonatomic, copy) NSString *share_url;
@property (nonatomic, copy) NSString *placeholder;


@property (nonatomic, assign) NSInteger share_type;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger total_updates;
@property (nonatomic, assign) NSInteger big_category_id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger allow_text;
@property (nonatomic, assign) NSInteger post_rule_id;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger subscribe_count;
@property (nonatomic, assign) NSInteger allow_multi_image;
@property (nonatomic, assign) NSInteger today_updates;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger allow_gif;
@property (nonatomic, assign) NSInteger allow_text_and_pic;
@property (nonatomic, assign) NSInteger allow_video;
@property (nonatomic, assign) NSInteger dedup;
@property (nonatomic, strong) NSArray *material_bar;
@end


@interface LBNHDiscoveryRotate_banner : LBNHBaseModel
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray <LBNHDiscoveryRotate_bannerElement*>*banners;
@end



@interface LBNHDiscoveryRotate_bannerElement : LBNHBaseModel
@property (nonatomic, copy) NSString *schema_url;
@property (nonatomic, strong) LBNHDiscoveryRotate_bannerElement_urlModel *banner_url;
@end

@interface LBNHDiscoveryRotate_bannerElement_urlModel : LBNHBaseModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *uri;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSMutableArray <LBNHDiscoveryRotate_bannerElement_urlModel_Url *>*url_list;
@end


@interface LBNHDiscoveryRotate_bannerElement_urlModel_Url : LBNHBaseModel
@property (nonatomic, copy) NSString *url;
@end
