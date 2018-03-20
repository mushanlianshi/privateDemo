//
//  LBNHBaseImageView.m
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseImageView.h"
#import "YYWebImage.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"

//add for gif sdwebimage
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface LBNHBaseImageView ()

@end


@implementation LBNHBaseImageView


//-(void)setIsLongPicture:(BOOL)isLongPicture{
//    _isLongPicture = isLongPicture;
//    if (isLongPicture) {
//        
//    }
//}

/**
 设置图片
 */
-(void)setImagePath:(NSString *)imagePath{
    
    [self setImagePath:imagePath placeHolder:nil];
}
-(void)setImageURL:(NSURL *)imageURL{
    [self setImageURL:imageURL placeHolder:nil];
}


/**
 设置图片   带占位图的
 */
-(void)setImagePath:(NSString *)imagePath placeHolder:(UIImage *)image{
    [self setImagePath:imagePath placeHolder:image finishHandler:nil];
}
-(void)setImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image{
    [self setImageURL:imageURL placeHolder:image finishHandler:nil];
}


/**
 设置图片 带占位图的  带结束回调的
 */
-(void)setImagePath:(NSString *)imagePath placeHolder:(UIImage *)image finishHandler:(void(^)(NSError *error, UIImage *image))finishHandler{
    [self setImagePath:imagePath placeHolder:image progressHandler:nil finishHandler:finishHandler];
}
-(void)setImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image finishHandler:(void(^)(NSError *error, UIImage *image))finishHandler{
    [self setImageURL:imageURL placeHolder:image progressHandler:nil finishHandler:finishHandler];
}



-(void)setImagePath:(NSString *)imagePath placeHolder:(UIImage *)image progressHandler:(ImageProgressHandler)progressHandler finishHandler:(void (^)(NSError *error, UIImage *image))finishHandler{
    
    [self setImageURL:[NSURL URLWithString:imagePath] placeHolder:image progressHandler:progressHandler finishHandler:finishHandler];
    
//    [self sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        if (progressHandler) {
//            progressHandler(receivedSize * 1.0f/expectedSize);
//        }
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (finishHandler) {
//            finishHandler(error, image);
//        }
//    }];
}
-(void)setImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image progressHandler:(ImageProgressHandler)progressHandler finishHandler:(void (^)(NSError *error, UIImage *image))finishHandler{
    
    //YYimage
//    [self yy_setImageWithURL:imageURL placeholder:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        if (progressHandler) {
//            progressHandler(receivedSize * 1.0 / expectedSize);
//        }
//    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        if (finishHandler) {
//            finishHandler(error, image);
//        }
//    }];
    
    
//    [self sd_setShowActivityIndicatorView :YES];
    
    
    //sdwebimage
    [self sd_setImageWithURL:imageURL placeholderImage:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize,NSURL *target) {
        if (progressHandler) {
            progressHandler(receivedSize * 1.0f/expectedSize);
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (finishHandler) {
            finishHandler(error, image);
        }
    }];
    
//    [self sd_setImageWithURL:imageURL placeholderImage:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        if (progressHandler) {
//            progressHandler(receivedSize * 1.0f/expectedSize);
//        }
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (finishHandler) {
//            finishHandler(error, image);
//        }
//    }];
    
//    [self sd_setImageWithURL:imageURL placeholderImage:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        if (progressHandler) {
//            progressHandler(receivedSize * 1.0f/expectedSize);
//        }
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (finishHandler) {
//            finishHandler(error, image);
//        }
//    }];
}

-(void)setGifImagePath:(NSString *)imagePath placeHolder:(UIImage *)image progressHandler:(ImageProgressHandler)progressHandler finishHandler:(void (^)(NSError *error, UIImage *image))finishHandler{
    
    [self setGifImageURL:[NSURL URLWithString:imagePath] placeHolder:image progressHandler:progressHandler finishHandler:finishHandler];

}

-(void)setGifImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image progressHandler:(ImageProgressHandler)progressHandler finishHandler:(void (^)(NSError *error, UIImage *image))finishHandler{
    
    //    [self yy_setImageWithURL:imageURL placeholder:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //        if (progressHandler) {
    //            progressHandler(receivedSize * 1.0 / expectedSize);
    //        }
    //    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    //        if (finishHandler) {
    //            finishHandler(error, image);
    //        }
    //    }];
    
//    FLAnimatedImage *animationImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:imageURL]];
//    self.animatedImage = animationImage;
//    WS(weakSelf);
//    [self sd_setImageWithURL:imageURL placeholderImage:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        if (progressHandler) {
//            progressHandler(receivedSize * 1.0f/expectedSize);
//        }
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        FLAnimatedImage *animationImage = [FLAnimatedImage animatedImageWithGIFData:UIImageJPEGRepresentation(image, 1.f)];
////        weakSelf.image = nil;
////        weakSelf.animatedImage = animationImage;
//        if (finishHandler) {
//            finishHandler(error, image);
//        }
//    }];

}

@end
