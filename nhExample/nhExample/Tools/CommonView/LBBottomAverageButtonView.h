//
//  LBBottomAverageButtonView.h
//  nhExample
//
//  Created by liubin on 17/5/4.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LBItemClickIndex)(NSInteger index, BOOL isSelected);


/**
 * 底部按钮平均分的view
 */
@interface LBBottomAverageButtonView : UIView
-(instancetype)initImages:(NSArray *)images highImages:(NSArray *)highImages titles:(NSArray *)titles;
-(instancetype)initImages:(NSArray *)images titles:(NSArray *)titles;

@property (nonatomic, copy) LBItemClickIndex clickHandler;

@end

@interface LBBottomButton : UIButton

@end
