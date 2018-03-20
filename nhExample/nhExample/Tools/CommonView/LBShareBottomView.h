//
//  LBShareBottomView.h
//  nhExample
//
//  Created by liubin on 17/4/1.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBShareBottomView;

//isShare 用来判断是分享还是操作的
typedef void(^LBShareItemClickHandler)(LBShareBottomView *shareView, BOOL isShare, NSInteger index);

/**
 * 分享的地步菜单栏
 */
@interface LBShareBottomView : UIView

@property (nonatomic, copy) LBShareItemClickHandler itemHandler;

/** 初始化分享的内容 */
-(instancetype)initWithTitle:(NSArray *)titlesArray imagesArray:(NSArray *)imagesArray;


/** 初始化分享下面的复制等的内容 */
-(void)setCopyItems:(NSArray *)copyTitles copyImages:(NSArray *)copyImages;

/** 默认显示的样式 */
-(void)showDefault;
/** 显示 */
-(void)show;

/** 关闭显示 */
-(void)dismiss;

@end


@interface LBShareButton : UIButton

@end
