//
//  UIImageView+LBCornerRaduis.h
//  nhExample
//
//  Created by baletu on 2018/3/9.
//  Copyright © 2018年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDImageCache.h";


/**
 * 页面圆角图片多才使用   只是几个图片没必要
 * 结合SDWebImage 来处理图片圆角
 * 根据原URL生成一个带圆角缓存的路径cornerRaduisPath  每次设置圆角路径显示的时候   先去本地缓存查带圆角的图片是否存在
 * 1.有显示
 * 2.没有  去下载  下载成功，转成圆角的图片，保存成cornerRaduisPath
 * 3.移除原路径缓存的图片  避免缓存图片过多
 */
@interface UIImageView (LBCornerRaduis)


/**
 * 设置图片圆角
 */
- (void)lb_sdImageUrl:(NSString *)imageUrl cornerRaduis:(CGFloat)cornerRaduis placeholderImage:(UIImage *)placeholder completedBlock:(void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL))completedBlock;

@end
