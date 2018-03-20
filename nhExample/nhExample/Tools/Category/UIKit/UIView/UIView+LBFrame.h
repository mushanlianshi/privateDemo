//
//  UIView+LBFrame.h
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 封装Viewframe的方法  获取width height x y方便
 */
@interface UIView (LBFrame)

/** 宽度 */
@property (nonatomic, assign) CGFloat width;

/** 高度 */
@property (nonatomic, assign) CGFloat height;

/** 起始值X */
@property (nonatomic, assign) CGFloat x;

/** 起始值Y */
@property (nonatomic, assign) CGFloat y;

/** 中心点X */
@property (nonatomic, assign) CGFloat centerX;

/** 中心点Y */
@property (nonatomic, assign) CGFloat centerY;

/** size大小 */
@property (nonatomic, assign) CGSize size;

/** 上边的值 */
@property (nonatomic, assign) CGFloat top;

/** 下边的值 */
@property (nonatomic, assign) CGFloat bottom;

/** 左边的值 */
@property (nonatomic, assign) CGFloat left;

/** 右边的值 */
@property (nonatomic, assign) CGFloat right;

/** 起始位置 */
@property (nonatomic, assign) CGPoint origin;

@end
