//
//  LBSDImageCache.m
//  LBSamples
//
//  Created by liubin on 17/2/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBSDImageCache.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
@implementation LBSDImageCache

+(UIImage *)imageFromDiskCacheForKey:(NSString *)imageUrl{
    UIImage *image=[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    return image;
}

+(void)downLoadImageWithUrl:(NSString *)imageUrl options:(LBSDDowloadImageOptions)options progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress completed:(void (^)(UIImage *image, NSData *data, NSError *error, BOOL finished))completed{
    //SDWebImageDownloaderUseNSURLCache 默认不适用url路径缓存图片  我们制定使用url路径来缓存图片//, NSURL * _Nullable targetURL
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progress) {
            progress(receivedSize, expectedSize);
        }
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        //缓存图片
        [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl toDisk:YES completion:nil];
//        [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl toDisk:YES];
        if (completed) {
            completed(image,data,error,finished);
        }
    }];
    
    //老版本
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        NSLog(@"LBLog 图片下载的进度 %ld %ld ",receivedSize,expectedSize);
//        if (progress) {
//            progress(receivedSize, expectedSize);
//        }
//    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        //缓存图片
//        [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl toDisk:YES];
//        completed(image,data,error,finished);
//    }];
}

single_implementation(LBSDImageCache)
@end
