//
//  LBNHHomeTitleModel.h
//  nhExample
//
//  Created by liubin on 17/3/23.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseModel.h"


/**
 * 推荐 视频等标题的model
 */
@interface LBNHHomeTitleModel : LBNHBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger refresh_interval;

@end
