//
//  LBNHDiscoverHotHeaderView.h
//  nhExample
//
//  Created by liubin on 17/4/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBNHDiscoverHotHeaderView, LBNHDiscoveryRotate_bannerElement, LBNHDiscoveryRotate_bannerElement_urlModel;
/** item 的点击回调 */
typedef void(^LBNHDiscoverHotHeaderViewItemHandler)(LBNHDiscoverHotHeaderView *panoramaView, NSInteger index);

@interface LBNHDiscoverHotHeaderView : UIView

@property (nonatomic, copy) NSArray *modelsArray;

@property (nonatomic, copy) LBNHDiscoverHotHeaderViewItemHandler itemHandler;

@end
