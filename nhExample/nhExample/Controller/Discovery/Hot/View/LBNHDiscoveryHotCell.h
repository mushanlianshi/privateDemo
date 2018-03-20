//
//  LBNHDiscoveryHotCell.h
//  nhExample
//
//  Created by liubin on 17/4/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBNHDiscoveryCategoryElement,LBNHDiscoveryHotCell;

typedef void(^LBNHDiscoveryCareBtnHanler)(LBNHDiscoveryHotCell *cell,UIButton *button);

/**  热吧页下面的cell */
@interface LBNHDiscoveryHotCell : UITableViewCell

@property (nonatomic, strong) LBNHDiscoveryCategoryElement *model;

@property (nonatomic, copy) LBNHDiscoveryCareBtnHanler careBtnHandler;

/** 移除动画 */
-(void)removeAnimation;

@end
