//
//  LBNHCheckCellViewProgressBar.h
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 封装了显示支持和不支持的动画view  用贝瑟尔曲线做的动画
 */
@interface LBNHCheckCellViewProgressBar : UIView
+(instancetype)bar;

/**
 * 左边占据的比例
 */
@property (nonatomic, assign) CGFloat leftScale;


/**
 * 右边占据的比例
 */
@property (nonatomic, assign) CGFloat rightScale;

@property (nonatomic, copy) dispatch_block_t finishAnimationBlock;

@end
