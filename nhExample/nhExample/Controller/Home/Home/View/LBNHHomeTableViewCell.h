//
//  LBNHHomeTableViewCell.h
//  nhExample
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

//点赞一栏的类别
typedef NS_ENUM(NSInteger, LBThumBottomClickItemType){
    LBThumBottomClickItemTypeThum = 10, //点赞
    LBThumBottomClickItemTypeStep, //踩
    LBThumBottomClickItemTypeComment, //评论
    LBThumBottomClickItemTypeShare, //分享
};

@class LBNHHomeCellFrame,LBNHHomeTableViewCell,LBNHUserInfoModel,LBNHBaseImageView,LBCustomGifImageView,LBCustomLongImageView;


/**
 * cell的一些事件回调
 */
@protocol LBNHHomeTableViewCellDelegate <NSObject>

/** 热门分类的点击回调 */
-(void)homeTableViewCellCategoryClicked:(LBNHHomeTableViewCell *)cell;

/** 点击个人头像 去个人中心的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell goToPersonalCenterWithUserInfo:(LBNHUserInfoModel *)userInfo;


/** 点赞一栏的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell thumBottonItemClicked:(LBThumBottomClickItemType)itemType;


/** 点浏览大图的回调  点击的索引  以及urls */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell didClickedImageView:(LBCustomLongImageView *)imageView currentIndex:(NSInteger)currentIndex urls:(NSArray <NSURL *>*)urls;


/** 点浏览gif的回调  点击的索引  以及urls */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell didClickedGifView:(LBCustomGifImageView *)gifView currentIndex:(NSInteger)currentIndex urls:(NSArray <NSURL *>*)urls;

/** 点播放视频的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell didClickedVideo:(NSString *)videoUrl videoCoverImage:(LBNHBaseImageView *)coverImageView;

/** 关注的回调 */
-(void)homeTableViewCell:(LBNHHomeTableViewCell *)cell careButtonClicked:(UIButton *)careButton;
@end

/**
 home界面的cell
 */
@interface LBNHHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) LBNHHomeCellFrame *cellFrame;

@property (nonatomic, weak) id <LBNHHomeTableViewCellDelegate> delegate;

/** 搜索界面用的方法 */
-(void)setCellFrame:(LBNHHomeCellFrame *)cellFrame keyWords:(NSString *)keyWords;

/** 设置赞按钮的动画 */
-(void)didDigg;


/** 设置踩按钮的动画 */
-(void)didBury;

@end
