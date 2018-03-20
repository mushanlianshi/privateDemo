//
//  LBCustomLongImageView.h
//  nhExample
//
//  Created by liubin on 17/4/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseImageView.h"


/**
 * 显示是否是长图的  根据设置frame的时候计算  
 */
@interface LBCustomLongImageView : LBNHBaseImageView

/** 原本的长度 */
@property (nonatomic, strong) UIImage *originalLongImage;

/** 裁剪后只显示固定高度的图片 */
@property (nonatomic, strong) UIImage *cutTopImage;

@end
