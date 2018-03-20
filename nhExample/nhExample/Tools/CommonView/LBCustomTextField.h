//
//  LBCustomTextField.h
//  nhExample
//
//  Created by liubin on 17/4/6.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBCustomTextField;
typedef void(^LBTextFieldRightHandler)(LBCustomTextField *textField);

/** 是否符合筛选规则的block */
typedef BOOL(^LBStringFilter)(NSString *filterString);

/**
 * 自定义的textField
 */
@interface LBCustomTextField : UITextField
/**
 初始化textField
 
 @param frame 位置frame
 @param pleaceHolder 提示的字
 @param holderColor  提示字体的颜色
 @param textColor 输入字体的颜色
 @param leftImage 左边显示的图片
 @param rightImage 右边显示的图片
 @param leftMargin 左边显示的距离
 */
-(instancetype)initWithFrame:(CGRect)frame pleaceHolder:(NSString *)pleaceHolder pleaceHolderColor:(UIColor *)holderColor textColor:(UIColor *)textColor leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage leftMargin:(CGFloat)leftMargin;



/**
 带imageSize控制的初始化

 @param frame 位置frame
 @param pleaceHolder 提示的字
 @param holderColor  提示字体的颜色
 @param textColor 输入字体的颜色
 @param leftImage 左边显示的图片
 @param rightImage 右边显示的图片
 @param leftMargin 左边显示的距离
 @return 初始化的对象
 */
-(instancetype)initWithFrame:(CGRect)frame pleaceHolder:(NSString *)pleaceHolder pleaceHolderColor:(UIColor *)holderColor textColor:(UIColor *)textColor leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage ImageSize:(CGSize)imageSize leftMargin:(CGFloat)leftMargin;

/**
 *
 * 是否显示右边的图片  默认不显示  是删除按钮  
 */
@property (nonatomic, assign) BOOL showRightImage;


@property (nonatomic, strong) UIColor *pleaceHolderColor;

/** 左侧默认高亮的图片 */
@property (nonatomic, strong) UIImage *leftHightImage;

//@property (nonatomic, strong) UIFont *font;

/** 有些需求更新右边显示图片的 */
@property (nonatomic, strong) UIImage *rightImage;

/** 右边图片点击block */
@property (nonatomic, copy) LBTextFieldRightHandler rightTapHandler;

/** 是否是密文 */
@property (nonatomic, assign) BOOL isSecurity;

/** 是否不能出现中文  默认为NO 可以有中文 */
@property (nonatomic, assign) BOOL isNoChinese;

/** 最大的长度 默认为无穷大 */
@property (nonatomic, assign) NSInteger maxLength;

@end
