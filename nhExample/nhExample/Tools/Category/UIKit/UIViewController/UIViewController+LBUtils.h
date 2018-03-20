//
//  UIViewController+LBUtils.h
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 处理Controller的工具分类
 */
@interface UIViewController (LBUtils)


/**
 * 判断是不是push展示的
 @return YES push  NO present
 */
-(BOOL)isBePushed;

@end
