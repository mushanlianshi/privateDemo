//
//  LBDrawView.h
//  testPush
//
//  Created by baletu on 2017/8/31.
//  Copyright © 2017年 baletu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 可以画的view
 */
@interface LBDrawView : UIView


/** 画笔的颜色 */
@property (nonatomic,strong) UIColor *strokeColor;

/** 线的宽 */
@property (nonatomic,assign) CGFloat lineWidth;

/** 是否支持触摸画线 */
@property (nonatomic,assign) BOOL isTouchAble;

/** 是否清除view上的划线 */
@property (nonatomic,assign) BOOL isClearDrawLine;


/** 画完自后获取照片 */
-(UIImage *)imageForDrawLine;


@end
