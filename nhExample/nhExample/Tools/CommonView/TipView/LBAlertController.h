//
//  LBAlertController.h
//  nhExample
//
//  Created by liubin on 17/4/24.
//  Copyright © 2017年 liubin. All rights reserved.
//

typedef NS_ENUM(NSInteger, LBAlertViewType){
    LBAlertViewTypeDefault,//默认一般的提示框
    LBAlertViewTypeInputTextField,//带输入框
};

typedef void(^LBAlertBlock)(UIAlertAction *alertAction);
typedef void(^LBAlertTextFieldBlock)(UITextField *textField);

#import <Foundation/Foundation.h>



/**
 * 两个alertAction是以前alertView的样式   多余两个就是竖排下来的样式
 * UIAlertActionStyleDestructive 警惕性红色的字体
 * UIAlertActionStyleCancel取消默认是蓝色加粗
 * UIAlertActionStyleDefault 默认蓝色
 */
@interface LBAlertController : NSObject

/**
 显示一个提示controller  默认确定的
 
 @param title 标题
 @param content 信息
 @param currentController 用来展示controller用的
 */
+(void)showAlertTitle:(NSString *)title content:(NSString *)content currentController:(UIViewController *)currentController;


/**
 显示一个带确定取消的controller
 
 @param title 标题
 @param content 信息
 @param currentController 当前用来presentController用的
 @param sureBlock 确定按钮的回调
 */
+(void)showAlertTitle:(NSString *)title content:(NSString *)content currentController:(UIViewController *)currentController sureBlock:(dispatch_block_t)sureBlock;


/**
 显示提示框 取消 确定都有的类型

 @param title 标题
 @param content 内容
 @param cancelString 取消按钮的标题
 @param cancelBlock 取消按钮的回调
 @param sureString 确定按钮的事件
 @param sureBlock 确定按钮的回调
 @param currentController 用来presentController用的
 */
+(void)showAlertTitle:(NSString *)title content:(NSString *)content cancelString:(NSString *)cancelString cancleBlock:(dispatch_block_t)cancelBlock sureString:(NSString *)sureString sureBlock:(dispatch_block_t)sureBlock currentController:(UIViewController *)currentController;



/**
 * 显示actionSheet的

 @param title 标题
 @param content 内容
 @param firstTitle 第一个item标题
 @param firstBlock 第一个item回调
 @param secondTitle 第二个item标题
 @param secondBlock 第二个item回调
 @param cancelString 取消的标题
 @param cancelBlock 取消的回调
 */
+(void)showSheetTitle:(NSString *)title content:(NSString *)content firstTitle:(NSString *)firstTitle firstBlock:(dispatch_block_t)firstBlock secondTitle:(NSString *)secondTitle secondBlock:(dispatch_block_t)secondBlock cancelString:(NSString *)cancelString cancelBlock:(dispatch_block_t)cancelBlock currentController:(UIViewController *)currentController;



+(void)showSureAlertView:(NSString *)title description:(NSString *)description surelTitle:(NSString *)surelTitle sureBlock:(LBAlertBlock)sureBlock currentController:(UIViewController *)currentController;

+(void)showSureAlertView:(NSString *)title description:(NSString *)description surelTitle:(NSString *)surelTitle sureBlock:(LBAlertBlock)sureBlock currentController:(UIViewController *)currentController type:(LBAlertViewType)type textFieldBlock:(LBAlertTextFieldBlock)textFieldBlock;

//+(void)showAlertView:(NSString *)title description:(NSString *)description cancelTitle:(NSString *)cancelString sureString:(NSString *)sureString  cancelBlock:(LBAlertBlock)cancelBlock sureBlock:(LBAlertBlock)sureBlock currentController:(UIViewController *)currentController;
//+(void)showAlertView:(NSString *)title description:(NSString *)description cancelTitle:(NSString *)cancelString sureString:(NSString *)sureString  cancelBlock:(LBAlertBlock)cancelBlock sureBlock:(LBAlertBlock)sureBlock currentController:(UIViewController *)currentController type:(LBAlertViewType)type textFieldBlock:(LBAlertTextFieldBlock)textFieldBlock;
@end
