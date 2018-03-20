//
//  LBScanViewStyle.h
//  nhExample
//
//  Created by liubin on 17/5/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 扫描动画的类型
 */
typedef NS_ENUM(NSInteger, LBScanAnimationStyle){
    LBScanAnimationStyleLine, //线条在上下移动的动画
    LBScanAnimationStyleGrid, //网格图片的动画
};

typedef NS_ENUM(NSInteger, LBScanFrameCornerStyle){
    LBScanFrameCornerStyleInner, //四个角内嵌在扫描区域
    LBScanFrameCornerStyleOutter, //四个角外嵌在扫描区域
};

/**
 * 自定义扫描的风格  包括扫描的样式
 */
@interface LBScanViewStyle : NSObject


/**
 * 是否需要显示扫描区域的边框  默认是不显示
 */
@property (nonatomic, assign) BOOL  isNeedShowScanViewBorder;


/**
 * 扫描区域的宽高比  默认是1 正方形
 */
@property (nonatomic, assign) BOOL whScale;


/**
 * 默认距离屏幕中心点的上移位置  用来显示扫描区域的
 */
@property (nonatomic, assign) CGFloat offsetCenterUp;


/**
 * 两边距离左右显示的便宜量  默认为左右各偏移30
 */
@property (nonatomic, assign) CGFloat offsetSideMargin;


/**
 * 不是扫描区域的背景颜色
 */
@property (nonatomic, strong) UIColor *noRecoginzeColor;


/**
 * 边角区域的颜色  4个角的颜色
 */
@property (nonatomic, strong) UIColor *cornerColor;



/**
 * 4个角的默认border的宽度
 */
@property (nonatomic, assign) CGFloat cornerLineBorderWidth;


/**
 * 四个角的默认宽长 16
 */
@property (nonatomic, assign) CGFloat cornerLineW;


/**
 * 四个角的默认高长 16
 */
@property (nonatomic, assign) CGFloat cornerLineH;

/**
 * 扫描边框的颜色 默认白色
 */
@property (nonatomic, strong) UIColor *borderColor;


/**
 * 扫描动画的类型
 */
@property (nonatomic, assign) LBScanAnimationStyle animationStyle;


/**
 * 扫描动画的图片 线和网格 为nil没有动画
 */
@property (nonatomic, strong) UIImage *animationImage;

/**
 * 边角的样式
 */
@property (nonatomic, assign) LBScanFrameCornerStyle cornerStyle;


/**
 * 快速获取封装好的style类型  支付宝的类型
 */
+(LBScanViewStyle *)alipayStyle;
/**
 * 快速获取封装好的style类型  QQ的类型
 */
+(LBScanViewStyle *)QQStyle;

@end
