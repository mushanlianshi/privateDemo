//
//  LBCollectionPanoramaView.h
//  nhExample
//
//  Created by liubin on 17/4/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBCollectionPanoramaView;

/** item 的点击回调 */
typedef void(^LBCollectionPanaramaItemHandler)(LBCollectionPanoramaView *panoramaView, NSInteger index);


/**
 * 通过collectionView做的无线轮播图
 */
@interface LBCollectionPanoramaView : UIView

/** 这里为了封装通用的  传进来的是view的数组  不是model的数组  */
@property (nonatomic, copy) NSArray *viewsArray;

@property (nonatomic, copy) LBCollectionPanaramaItemHandler itemHandler;

@end
