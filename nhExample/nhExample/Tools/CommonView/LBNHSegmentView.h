//
//  LBNHSegmentView.h
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 封装的选项卡的view
 */
@interface LBNHSegmentView : UIView



-(instancetype)initWithItemTitles:(NSArray *)titles;

/**
 item的点击事件
 */
@property (nonatomic, copy)  void(^SegmentItemSelected)(LBNHSegmentView *segmentView, NSInteger index, NSString *title);
/**
 默认选中第几个
 */
-(void)clickDefaultIndex:(NSInteger )index;

@end
