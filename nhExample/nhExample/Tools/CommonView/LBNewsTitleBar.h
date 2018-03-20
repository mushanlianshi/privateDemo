//
//  LBNewsTitleBar.h
//  LBSamples
//
//  Created by liubin on 17/2/24.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LBNewsTitleBarItemBlock)(NSInteger tag);
/**
  封装了类似新闻的标题栏的scrollview
 */
@interface LBNewsTitleBar : UIView

/**
    要显示的titles数组
 */
-(instancetype)initWithTitles:(NSArray *)titles;

/**
 设置默认选中的索引

 @param index 默认选中0 如果不调用设置的话
 */
-(void)setSelectedIndex:(NSUInteger)index;
@property (nonatomic, copy) LBNewsTitleBarItemBlock itemBlock;
@end
