//
//  UIView+LBTap.h
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 分类添加点击事件
 */
@interface UIView (LBTap)

/**
 view的点击事件
 由于分类中不能添加  属性   我们用runtime添加属性block给view
 @param tapBlock 点击的回调
 */
- (void)addTapBlock:(dispatch_block_t)tapBlock;
@end
