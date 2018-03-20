//
//  LBNHCheckCell.h
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBNHHomeServiceDataElement;
@class LBNHCheckCellFrame;
@class LBNHCheckCell;

@protocol LBNHCheckCellDelegate <NSObject>


/** 喜欢和不喜欢的点击事件  当动画做完了  才给回调 发请求处理*/
-(void)checkCell:(LBNHCheckCell *)checkCell didFinishLoadingWithFlag:(BOOL)isLikeFlag;

/** 举报的点击事件 */
-(void)checkCell:(LBNHCheckCell *)checkCell reportClicked:(BOOL)reportClicked;

/** 点击查看大图的回调 */
-(void)checkCell:(LBNHCheckCell *)checkCell imageView:(UIImageView *)imageView currentIndex:(NSInteger)currentIndex urls:(NSArray<NSURL *>*)urls;

@end
/**
 * 审查的cell
 */
@interface LBNHCheckCell : UICollectionViewCell

@property (nonatomic, strong) LBNHHomeServiceDataElement *element;

@property (nonatomic, strong) LBNHCheckCellFrame *cellFrame;

@property (nonatomic, weak) id<LBNHCheckCellDelegate> delegate;

@end
