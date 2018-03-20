//
//  LBPublishPictureViewCell.h
//  nhExample
//
//  Created by liubin on 17/3/29.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBPublishPictureViewCell;
@protocol LBPublishPictureViewCellDelegate <NSObject>

/** cell的回调事件  ture是删除按钮的点击事件  false是图片的点击事件 */
-(void)pictureCell:(LBPublishPictureViewCell *)pictureCell isDeleteBtnClicked:(BOOL)isDeleteBtn;

@end

/**
 * 展示选择图片的cell
 */
@interface LBPublishPictureViewCell : UICollectionViewCell

/** 显示的图片 */
@property (nonatomic, strong) UIImage *image;
/** 移除删除按钮的方法 */
-(void)removeDeleteBtn;

@property (nonatomic, weak) id<LBPublishPictureViewCellDelegate> delegate;

@end
