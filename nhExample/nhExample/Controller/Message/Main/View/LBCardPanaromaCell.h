//
//  LBCardPanaromaCell.h
//  nhExample
//
//  Created by liubin on 17/4/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAdView.h"

/**
 * 卡片式轮播图的cell  遵守设置model协议  主要是为了设置cell的内容的
 */
@interface LBCardPanaromaCell : UICollectionViewCell<SCAdViewRenderDelegate>

@end
