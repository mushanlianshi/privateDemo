//
//  LBNHDetailCell.h
//  nhExample
//
//  Created by liubin on 17/3/24.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBNHHomeServiceDataModel.h"

@class LBNHDetailCell;
@class LBNHBaseImageView;

@protocol LBNHDetailCellDelegate <NSObject>
/** 头像点击的回调  去个人中心 */
-(void)detailCell:(LBNHDetailCell *)detailCell iconViewClicked:(LBNHBaseImageView *)iconView;

@end

/**
 * 详情的cell
 */
@interface LBNHDetailCell : UITableViewCell

@property (nonatomic, strong) LBNHHomeServiceDataElementComment *commentModel;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, weak) id<LBNHDetailCellDelegate> delegate;

@end
