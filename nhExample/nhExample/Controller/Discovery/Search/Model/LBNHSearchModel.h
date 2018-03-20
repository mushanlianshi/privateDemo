//
//  LBNHSearchModel.h
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 用来存在数据库的model
 */
@interface LBNHSearchModel : NSObject
/** 搜索的内容 */
@property (nonatomic, copy) NSString *content;
/** 搜索的时间戳 */
@property (nonatomic, assign) NSTimeInterval timeStap;

@end
