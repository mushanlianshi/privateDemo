//
//  LBNHCustomNoDataEmptyView.h
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 自定义没有数据提示的view
 */
@interface LBNHCustomNoDataEmptyView : UIView


/**
 * 上面显示的label
 */
@property (nonatomic, strong) UILabel *topLabel;


/**
 * 显示的图片
 */
@property (nonatomic, strong) UIImageView *imageView;


/**
 *下面显示的文字
 */
@property (nonatomic, strong) UILabel *bottomLabel;

-(instancetype)initWithTitle:(NSString *)title image:(UIImage *)image desc:(NSString *)desc;

@end
