//
//  LBRaceLampView.h
//  testPush
//
//  Created by baletu on 2017/7/25.
//  Copyright © 2017年 baletu. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 竖直方向的跑马灯view
 */
@interface LBRaceLampView : UIView


-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,strong) UIFont *titleFont;

@end
