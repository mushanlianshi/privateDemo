//
//  LBCustomSearchHistoryView.h
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LBSearchHistoryContent)(NSString *content);

/**
 * 自定义搜索历史的view
 */
@interface LBCustomSearchHistoryView : UIView

@property (nonatomic, copy) NSArray *contentsArray;

@property (nonatomic, copy) LBSearchHistoryContent searchContent;


/**
 * 显示的方法
 @param height 显示的高度
 @param upView 在upView下面  一般upView都是搜索框
 */
-(void)showWithHeight:(CGFloat)height upView:(UIView *)upView;
/** 消失 */
-(void)dismiss;

@end
