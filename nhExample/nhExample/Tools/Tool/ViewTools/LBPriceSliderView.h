//
//  LBPriceSliderView.h
//  testPush
//
//  Created by baletu on 2018/1/17.
//  Copyright © 2018年 baletu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PriceSliderBlock)(NSUInteger startPrice, NSUInteger endPrice);



/**
 * 注意左右slider的划过的颜色是反的 以及位置让一个thumb的大小 价格一百为单位变动
 */
@interface LBPriceSliderView : UIView

- (instancetype)initWithFrame:(CGRect)frame priceRange:(NSUInteger)priceRange;

@property (nonatomic, copy) PriceSliderBlock sliderBlock;

@property (nonatomic, strong) UIColor * minimumTrackTintColor;

@property (nonatomic, strong) UIColor * maximumTrackTintColor;

@property (nonatomic, strong) UIColor * thumbTintColor;

@property (nonatomic, strong) UIImage * thumbImage;

@end
