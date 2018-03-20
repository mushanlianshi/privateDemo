//
//  LBNHPublishSelectColumnModel.h
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseModel.h"


/**
 * 投稿栏目的model
 */
@interface LBNHPublishSelectColumnModel : LBNHBaseModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger subscribe_count;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) BOOL allow_gif;
@property (nonatomic, assign) BOOL allow_video;
@property (nonatomic, assign) BOOL allow_text;
@property (nonatomic, assign) BOOL allow_multi_image;
@end
