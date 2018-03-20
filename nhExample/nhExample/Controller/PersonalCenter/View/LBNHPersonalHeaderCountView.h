//
//  LBNHPersonalHeaderCountView.h
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBNHPersonalHeaderCountView;
typedef void(^LBNHPersonalHeaderCountViewHandler)(LBNHPersonalHeaderCountView *countView,NSInteger index);

/**
 * 关注  粉丝 积分的view
 */
@interface LBNHPersonalHeaderCountView : UIView


/**
 * 通过titles 和counts来自动创建显示布局
 */
-(instancetype)initWithTitles:(NSArray<NSString *>*)titles counts:(NSArray<NSNumber *>*)counts;

-(void)setTitles:(NSArray<NSString *>*)titles counts:(NSArray<NSNumber *>*)counts;


@property (nonatomic, copy) LBNHPersonalHeaderCountViewHandler clickedHandler;

@end
