//
//  LBCustomPageControl.h
//  nhExample
//
//  Created by liubin on 17/4/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 通过贝瑟尔曲线定义的pageControl
 */
@interface LBCustomPageControl : UIView

@property (nonatomic, assign) NSInteger numberOfItems;

/** 当前索引 */
@property (nonatomic, assign) NSInteger currentIndex;

/** item的宽 */
@property (nonatomic, assign) CGFloat pageWidth;

/** item的高 */
@property (nonatomic, assign) CGFloat pageHeight;

/** item的间隔 */
@property (nonatomic, assign) CGFloat pageSpace;

/** 选中颜色*/
@property (nonatomic, strong) UIColor *selectedItemColor;
/** 正常颜色*/
@property (nonatomic, strong) UIColor *normalItemColor;

+ (instancetype)pageControl;
@end
