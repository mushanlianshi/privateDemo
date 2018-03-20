//
//  LBPayTextField.h
//  nhExample
//
//  Created by liubin on 17/4/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBPayTextField;
typedef void(^LBInputMaxLength)(LBPayTextField *textField);

/**
 * 六位支付密码的输入框
 * 分隔的竖线用layer做
 * 黑点用shaper和berizerPath来做
 * 注意不要显示光标
 */
@interface LBPayTextField : UITextField

@property (nonatomic, strong) UIView *view;

/** 分割线和边框颜色 */
@property (nonatomic, strong) UIColor *lineColor;

/** 圆圈的颜色 */
@property (nonatomic, strong) UIColor *circleColor;

/** 密码输入完的回调 */
@property (nonatomic, copy) LBInputMaxLength inputMaxHandler;

/** 清除输入内容的接口 */
-(void)clearText;

@end

@interface CATagLayer : CALayer

@property (nonatomic, assign) NSInteger tag;



@end
