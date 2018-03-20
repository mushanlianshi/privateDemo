//
//  LBSDImageCache.h
//  LBSamples
//
//  Created by liubin on 17/2/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,LBSDDowloadImageOptions){
    LBSDDowloadImageLowPriority = 1 << 0,
    LBSDDowloadImageProgressiveDownload = 1 << 1,
    LBSDDowloadImageUseNSURLCache = 1 << 2,
    LBSDDowloadImageIgnoreCachedResponse = 1 << 3,
    LBSDDowloadImageContinueInBackground = 1 << 4,
    LBSDDowloadImageHandleCookies = 1 << 5,
    LBSDDowloadImageAllowInvalidSSLCertificates = 1 << 6,
    LBSDDowloadImageHighPriority = 1 << 7,
    LBSDDowloadImageScaleDownLargeImages = 1 << 8,
};

/**
 封装图片缓存的接口  剥离第三方框架
 */
@interface LBSDImageCache : NSObject

/**
  根据图片路径在缓存中查找图片

 @param imageUrl imageUrl
 @return 查找到的图片
 */
+(UIImage *)imageFromDiskCacheForKey:(NSString *)imageUrl;



/**
 下载图片 用url、缓存路径

 @param imageUrl 图片的url
 @param progress 下载进度
 @param completed 完成的回调
 */
+(void)downLoadImageWithUrl:(NSString *)imageUrl options:(LBSDDowloadImageOptions)options progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress completed:(void (^)(UIImage *image, NSData *data, NSError *error, BOOL finished))completed;
single_interface(LBSDImageCache)
@end
