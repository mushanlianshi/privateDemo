//
//  LBCustomAlertView.h
//  nhExample
//
//  Created by liubin on 17/4/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 自定义对话框
 */
@interface LBCustomAlertView : UIView




- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel sure:(NSString *)sure;

- (void)setCancelBlock:(dispatch_block_t)cancelBlock;

- (void)setSureBlock:(dispatch_block_t)sureBlock;

- (void)showInSuperView:(UIView *)superView;

@end
