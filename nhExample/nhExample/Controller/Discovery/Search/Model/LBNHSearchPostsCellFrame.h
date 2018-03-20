//
//  LBNHSearchPostsCellFrame.h
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomeCellFrame.h"
@class LBNHHomeServiceDataElementGroup;

/** 继承home界面的cellFrame  集成他的属性 search界面的帖子的cellFrame  */
@interface LBNHSearchPostsCellFrame : LBNHHomeCellFrame

@property (nonatomic, strong) LBNHHomeServiceDataElementGroup *group;

@end
