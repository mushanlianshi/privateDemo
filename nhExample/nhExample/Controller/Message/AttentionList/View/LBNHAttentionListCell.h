//
//  LBNHAttetiionListCell.h
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBNHAttetionListModel;
@class LBNHAttentionListCell;

@protocol LBNHAttentionListCellDelegate <NSObject>

-(void)attentionListCell:(LBNHAttentionListCell *)attentionCell userIconTapped:(UIImageView *)iconView;

-(void)attentionListCell:(LBNHAttentionListCell *)attentionCell careUserClicked:(UIButton *)careButton;

@end



/**
 * 关注  粉丝的cell
 */
@interface LBNHAttentionListCell : UITableViewCell

@property (nonatomic, strong) LBNHAttetionListModel *attentionModel;

@property (nonatomic, weak) id<LBNHAttentionListCellDelegate> delegate;


/**
 * 设置按钮是关注还是已关注
 */
-(void)setCareButtonIsCare:(BOOL)isCare;

@end
