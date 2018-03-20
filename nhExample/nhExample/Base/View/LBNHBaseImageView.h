//
//  LBNHBaseImageView.h
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//


/**
 图片的进度  0-1
 */
typedef void(^ImageProgressHandler)(CGFloat progress);

#import <UIKit/UIKit.h>
#import "YYAnimatedImageView.h"
#import "FLAnimatedImageView.h"

/**
 网络基础类的imageView  继承YYAnimatedImageView  主要为了处理gif动画
 * //        _gifPicture.autoPlayAnimatedImage = NO;  设置不自动播放gif图  需要的时候在调用startAnimating 来播放
 [self.gifPicture startAnimating];
 */
@interface LBNHBaseImageView : YYAnimatedImageView
//@interface LBNHBaseImageView : UIImageView
//@interface LBNHBaseImageView : FLAnimatedImageView


/**
 * 专门设置是不是长图片的
 */
//@property (nonatomic, assign) BOOL isLongPicture;

/**
 设置图片
 */
-(void)setImagePath:(NSString *)imagePath;
-(void)setImageURL:(NSURL *)imageURL;


/**
 设置图片   带占位图的
 */
-(void)setImagePath:(NSString *)imagePath placeHolder:(UIImage *)image;
-(void)setImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image;


/**
 设置图片 带占位图的  带结束回调的
 */
-(void)setImagePath:(NSString *)imagePath placeHolder:(UIImage *)image finishHandler:(void(^)(NSError *error, UIImage *image))finishHandler;
-(void)setImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image finishHandler:(void(^)(NSError *error, UIImage *image))finishHandler;


/**
 
设置图片 带占位图的  带进度的 带结束回调的
 */
-(void)setImagePath:(NSString *)imagePath placeHolder:(UIImage *)image progressHandler:(ImageProgressHandler)progressHandler finishHandler:(void (^)(NSError * error, UIImage *image))finishHandler;
-(void)setImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image progressHandler:(ImageProgressHandler)progressHandler finishHandler:(void (^)(NSError *error, UIImage *image))finishHandler;


//-(void)setGifImagePath:(NSString *)imagePath placeHolder:(UIImage *)image progressHandler:(ImageProgressHandler)progressHandler finishHandler:(void (^)(NSError *error, UIImage *image))finishHandler;
//-(void)setGifImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image progressHandler:(ImageProgressHandler)progressHandler finishHandler:(void (^)(NSError *error, UIImage *image))finishHandler;

@end
