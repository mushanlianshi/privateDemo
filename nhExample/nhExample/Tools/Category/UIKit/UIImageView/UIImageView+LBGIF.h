//
//  UIImageView+LBGIF.h
//  nhExample
//
//  Created by liubin on 17/4/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 用来获取第一张图片  主要加载本地的GIF图片的  可以知道图片的宽高比 */
typedef void(^LBGIFFristImageHandler)(UIImage *image);

/**
 *为imageView添加一个设置GIF的方法
 */
@interface UIImageView (LBGIF)

/**
 * 设置imageView的GIF图片的方法
 */
-(void)lb_setGifImage:(NSURL *)imageUrl firstImageBlock:(LBGIFFristImageHandler)firstImageBlock;


/**
 * 设置圆角的时候的方法

 @param url 图片的URL
 @param placeHoder 占位图
 @param radius 圆角的半径
 */
- (void)setRoundImageWithURL:(NSURL *)url placeHoder:(UIImage *)placeHoder;
@end
