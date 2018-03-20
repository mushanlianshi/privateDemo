//
//  UIImageView+LBGIF.m
//  nhExample
//
//  Created by liubin on 17/4/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "UIImageView+LBGIF.h"
#import <ImageIO/ImageIO.h>
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UIImage+SubImage.h"


@implementation UIImageView (LBGIF)
//解析gif文件数据的方法 block中会将解析的数据传递出来
-(void)getGifImageWithUrk:(NSURL *)url returnData:(void(^)(NSArray<UIImage *> * imageArray, NSArray<NSNumber *>*timeArray,CGFloat totalTime, NSArray<NSNumber *>* widths,NSArray<NSNumber *>* heights))dataBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //通过文件的url来将gif文件读取为图片数据引用
        CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
        //获取gif文件中图片的个数
        size_t count = CGImageSourceGetCount(source);
        //定义一个变量记录gif播放一轮的时间
        float allTime=0;
        //存放所有图片
        NSMutableArray * imageArray = [[NSMutableArray alloc]init];
        //存放每一帧播放的时间
        NSMutableArray * timeArray = [[NSMutableArray alloc]init];
        //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
        NSMutableArray * widthArray = [[NSMutableArray alloc]init];
        //存放每张图片的高度
        NSMutableArray * heightArray = [[NSMutableArray alloc]init];
        //遍历
        for (size_t i=0; i<count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            [imageArray addObject:[UIImage imageWithCGImage:image]];
            CGImageRelease(image);
            //获取图片信息
            NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
            CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
            CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
            [widthArray addObject:[NSNumber numberWithFloat:width]];
            [heightArray addObject:[NSNumber numberWithFloat:height]];
            NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
            CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
            allTime+=time;
            [timeArray addObject:[NSNumber numberWithFloat:time]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
        });
        
    });
    
}

//为UIImageView添加一个设置gif图内容的方法：
-(void)lb_setGifImage:(NSURL *)imageUrl firstImageBlock:(LBGIFFristImageHandler)firstImageBlock{
    __weak typeof (self) __self = self;
    [self getGifImageWithUrk:imageUrl returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, CGFloat totalTime, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights) {
        if(firstImageBlock && imageArray.count){
            firstImageBlock(imageArray[0]);
        }
        //添加帧动画
//        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
//        NSMutableArray * times = [[NSMutableArray alloc]init];
//        float currentTime = 0;
//        //设置每一帧的时间占比
//        for (int i=0; i<imageArray.count; i++) {
//            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
//            currentTime+=[timeArray[i] floatValue];
//        }
//        [animation setKeyTimes:times];
//        [animation setValues:imageArray];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        //设置循环
//        animation.repeatCount= MAXFLOAT;
//        //设置播放总时长
//        animation.duration = totalTime;
//        //Layer层添加
//        [[(UIImageView *)__self layer] addAnimation:animation forKey:@"gifAnimation"];
        __self.animationImages = imageArray;
        __self.animationDuration = totalTime;
        __self.animationRepeatCount = NSIntegerMax;
        [__self startAnimating];
    }];
}




- (void)setRoundImageWithURL:(NSURL *)url placeHoder:(UIImage *)placeHoder
{
    NSString *urlStirng = [url absoluteString];
    NSString *imagenName = [NSString stringWithFormat:@"%@%@",urlStirng,@"roundImage"];
    __block NSString *path = [self base64String:imagenName];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:path];
    if (image)
    {
        [self setImage:image];
        return;
    }
    else if (placeHoder)
    {
        [self setImage:placeHoder];
    }
    __weak typeof(self)weakSelf = self;
    if (url)
    {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageRetryFailed|SDWebImageLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            __strong typeof(weakSelf)stongSelf = weakSelf;
            if (!finished) return;
            if (!image) return;
            @synchronized(self) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    UIImage *cirleImage =  [image cirleImage];
                    [[SDImageCache sharedImageCache] storeImage:cirleImage forKey:path completion:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [stongSelf performSelector:@selector(reloadImageData:) withObject:cirleImage afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
                        });
                    }];
                    //                    [[SDImageCache sharedImageCache]storeImage:cirleImage forKey:path];
                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    //                        [stongSelf performSelector:@selector(reloadImageData:) withObject:cirleImage afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
                    //                    });
                });
            }
        }];
    }
}

- (NSString*)base64String:(NSString*)str
{
    NSData* originData = [str dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return [NSString stringWithFormat:@"%@.png",encodeResult];
}

- (void)reloadImageData:(UIImage*)image
{
    [self setImage:image];
}





@end
