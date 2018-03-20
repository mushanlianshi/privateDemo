//
//  LBNHSearchPostsCell.h
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBNHHomeTableViewCell.h"
@class LBNHHomeServiceDataElementGroup;

/**
 * 搜索界面帖子的cell 
 */
@interface LBNHSearchPostsCell : UITableViewCell

@property (nonatomic, strong) LBNHHomeServiceDataElementGroup *group;

@end
