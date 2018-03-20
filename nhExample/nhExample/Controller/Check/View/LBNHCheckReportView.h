//
//  LBNHCheckReportView.h
//  nhExample
//
//  Created by liubin on 17/3/23.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBNHCheckReportView;

typedef void(^LBNHReportItemClickHandler)(LBNHCheckReportView *reportView,UIButton *button,NSInteger index);

/**
 * 审核的举报的view
 */
@interface LBNHCheckReportView : UIView

/** 显示  */
-(void)showInSuperView:(UIView *)superView;

/** 消失  */
-(void)dismiss;


/** 根据内容初始化  */
-(instancetype)initWithContents:(NSArray *)contents;


/**
 *条目点击的事件
 */
@property (nonatomic, copy) LBNHReportItemClickHandler itemHandler;


@end
