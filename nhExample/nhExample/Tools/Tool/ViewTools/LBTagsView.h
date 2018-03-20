//
//  LBTagsView.h
//  nhExample
//
//  Created by baletu on 2017/7/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBTagsView;
typedef void(^TagsItemClickedBlock)(NSInteger index,LBTagsView *tagView);

/**
 * 自定义标签的view
 */
@interface LBTagsView : UIView

-(instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor tagBackgroundColor:(UIColor *)tagBackgroundColor;

-(instancetype)initWithFrame:(CGRect)frame tagsTitle:(NSArray *)tagsTitle titleColor:(UIColor *)titleColor tagBackgroundColor:(UIColor *)tagBackgroundColor;

@property (nonatomic,copy) TagsItemClickedBlock itemBlock;

@property (nonatomic,copy) NSArray *tagsTitle;

//@property (nonatomic,copy) void(^ TagsViewItemHandler) (NSInteger index);

@end



/** 
*
 * UIWindow * window = [UIApplication sharedApplication].keyWindow;
 LBTagsView *tagsView = [[LBTagsView alloc] initWithFrame:CGRectMake(20, 20, window.width - 40, 0) titleColor:[UIColor redColor] tagBackgroundColor:[UIColor lightGrayColor]];
 tagsView.tagsTitle = @[@"00后",@"我就是我不一样的烟火",@"小二",@"开朗活泼",@"非主流",@"处女座",@"犯二",@"文艺青年",@"杀马特",@"klslkskk",@"劳动力看得开",@"iimd",@"冷冷的开口道"];
 tagsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
 [window addSubview:tagsView];
*/
