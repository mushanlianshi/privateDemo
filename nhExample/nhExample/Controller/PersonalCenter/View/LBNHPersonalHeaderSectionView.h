//
//  LBNHPersonalHeaderSectionView.h
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBNHPersonalHeaderSectionView;

@protocol LBNHPersonalHeaderSectionViewDelegate<NSObject>

-(void)personalSectionView:(LBNHPersonalHeaderSectionView *)sectionView clickedIndex:(NSInteger)index;

@end

/**
 * 投稿收藏评论的view
 */
@interface LBNHPersonalHeaderSectionView : UIView


/**
 * 初始化方法 
 */
-(instancetype)initWithTitles:(NSArray<NSString *>*)titles;

/**
 * 默认选中第几个
 */
-(void)defaultClickedIndex:(NSInteger)index;

@property (nonatomic, weak) id<LBNHPersonalHeaderSectionViewDelegate> delegate;

@end
