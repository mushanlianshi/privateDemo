//
//  LBPublishPictureView.h
//  nhExample
//
//  Created by liubin on 17/3/29.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 显示选择图片的view
 */
@interface LBPublishPictureView : UIView

@property (nonatomic, strong) NSMutableArray<UIImage *> *imagesArray;


-(void)addImages:(NSArray<UIImage *> *)images;

@end
