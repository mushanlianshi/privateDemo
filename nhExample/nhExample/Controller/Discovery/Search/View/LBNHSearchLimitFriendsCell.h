//
//  LBNHSearchLimitFriendsCell.h
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBNHSearchLimitFriendsCell;

@protocol LBNHSearchLimitFriendsCellDelegate <NSObject>

/** 前面好友点击了 */
-(void)searchLimitFriendsCell:(LBNHSearchLimitFriendsCell *)cell clickedIndex:(NSInteger)index;


/** 更多按钮点击了 */
-(void)searchLimitFriendsMoreClicked:(LBNHSearchLimitFriendsCell *)cell;

@end

/**
 * 缩略段友显示的cell
 */
@interface LBNHSearchLimitFriendsCell : UITableViewCell

@property (nonatomic, weak) id<LBNHSearchLimitFriendsCellDelegate> delegate;

/** 设置数据 以及要高亮的keywords */
-(void) setModelsArray:(NSArray *)modelsArray  keyWords:(NSString *)keyWords;

@end


/**
 * 封装了 图片在上面中间  文字在下面中间的button
 * 底部菜单栏的那种按钮
 */
@interface LBImageTitleLimitButton : UIButton


@end
