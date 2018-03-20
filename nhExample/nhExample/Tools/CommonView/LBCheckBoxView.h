//
//  LBCheckBoxView.h
//  testPush
//
//  Created by baletu on 2017/7/27.
//  Copyright © 2017年 baletu. All rights reserved.
//

/** *
 * 使用示例
 * LBCheckBoxView *checkBox = [[LBCheckBoxView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
 //    checkBox.isAnimating = YES;
 [self.view addSubview:checkBox];
 [checkBox addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
 
 -(void)checkBoxClicked:(UIButton *)button{
 button.selected =!button.isSelected;
 NSLog(@"LBlog selected is %zd ",button.isSelected);
 }
 */

#import <UIKit/UIKit.h>


/**
 * 自定义checkBox  
 */
@interface LBCheckBoxView : UIButton

@property (nonatomic,strong) UIColor *fillColor;

@property (nonatomic,strong) UIColor *duiColor;

@property (nonatomic,strong) UIColor *circleColor;

@property (nonatomic,assign) BOOL isAnimating;

@end
