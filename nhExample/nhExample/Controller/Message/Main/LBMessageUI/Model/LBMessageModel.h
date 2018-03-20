//
//  LBMessageModel.h
//  LBSamples
//
//  Created by liubin on 16/11/29.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBMessageModel : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isSelecting;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end
