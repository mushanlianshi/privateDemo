//
//  LBNHPersonalHeaderView.h
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBNHUserInfoModel;
@class LBNHPersonalHeaderView;
@protocol LBNHPersonalHeaderViewDelegate <NSObject>

-(void)personalHeaderView:(LBNHPersonalHeaderView *)headerView clickedIndex:(NSInteger)index;

@end
/**
 * 个人信息类的头view
 */
@interface LBNHPersonalHeaderView : UIView

@property (nonatomic, strong) LBNHUserInfoModel *userInfoModel;

@property (nonatomic, weak) id<LBNHPersonalHeaderViewDelegate> delegate;
@end
