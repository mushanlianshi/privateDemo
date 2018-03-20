//
//  LBNHAttentionAndFansView.h
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * item点击的block
 */
typedef void (^LBAttentionViewItemHandler)(UIButton *button,NSInteger index);

@interface LBNHAttentionAndFansView : UIView

@property (nonatomic, strong) UIColor *normalTextColor;

@property (nonatomic, strong) UIColor *highLightTextColor;

-(instancetype)initWithTitles:(NSArray *)titles;

-(void)defaultClickedIndex:(NSInteger)index;

@property (nonatomic, copy) LBAttentionViewItemHandler itemHandler;

@end
