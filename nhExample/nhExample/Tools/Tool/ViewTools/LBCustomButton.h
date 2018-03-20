//
//  LBCustomButton.h
//  nhExample
//
//  Created by baletu on 2017/12/25.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 按钮的类型  按钮默认是图片在左  文字在右 */
typedef NS_ENUM(NSUInteger, LBButtonLayoutType){
    LBButtonLayoutTypeImageTop = 0, // 图片上面文字下面的按钮
    LBButtonLayoutTypeImageLeft,    //图片在左文字在右的按钮
    LBButtonLayoutTypeImageBottom,  //图片下文字在上的按钮
    LBButtonLayoutTypeImageRight,   //图片在右文字在左的按钮
};


/**
 * 自定义按钮  图片文字文字调整的
 * UIEdgeInsetsMake 负数向外 正数向内
 */
@interface LBCustomButton : UIButton

/** 按钮和文字布局的类型 */
@property (nonatomic, assign) LBButtonLayoutType layoutType;

/** 上下布局类型竖直方向的间距 */
@property (nonatomic, assign) CGFloat layoutVerticalMargin;

/** 左右布局类型水平方向的间距 */
@property (nonatomic, assign) CGFloat layoutHoriMargin;

@end
