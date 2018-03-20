//
//  UIImageView+LBCornerRaduis.m
//  nhExample
//
//  Created by baletu on 2018/3/9.
//  Copyright © 2018年 liubin. All rights reserved.
//

static NSString * const kCornerPath = @"cornerRaduisCachePath";

#import "UIImageView+LBCornerRaduis.h"
#import "UIImageView+WebCache.h"
#import "NSString+LBConvert.h"

@implementation UIImageView (LBCornerRaduis)

- (void)lb_sdImageUrl:(NSString *)imageUrl cornerRaduis:(CGFloat)cornerRaduis placeholderImage:(UIImage *)placeholder completedBlock:(void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL))completedBlock{
    
    cornerRaduis = cornerRaduis == CGFLOAT_MIN ? self.bounds.size.width / 2 : cornerRaduis;
    
    placeholder = placeholder ? : ImageNamed(@"zhanweitu");
    
    //1.查找有没有圆角这个尺寸的占位图  没有生成保存
    NSString *cacheCornerPlaceKey = [NSString stringWithFormat:@"%zd%zdCornerPlaceImage",CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)];
    UIImage *cornerPlaceholderImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheCornerPlaceKey];
    if (!cornerPlaceholderImg) {
        cornerPlaceholderImg = [UIImageView createRoundedRectImage:placeholder size:self.bounds.size radius:cornerRaduis];
        [[SDImageCache sharedImageCache] storeImage:cornerPlaceholderImg forKey:cacheCornerPlaceKey completion:nil];
    }

    
    if (!imageUrl  || ![NSURL URLWithString:imageUrl]) {
        self.image = placeholder;
        return;
    }
    
    
    if (cornerRaduis != 0) {
        NSString *cachePath = [imageUrl stringByAppendingString:kCornerPath];
        //1.base64路径  混淆真实路径
        NSString *cache64Path = [cachePath base64String];
        UIImage *cacheCornerImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cache64Path];
        
        if (cacheCornerImage) {
            self.image = cacheCornerImage;
        }else{
            [self sd_setImageWithURL:nil placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                //2.下载成功
                if (!error) {
                    UIImage *cornerImage = [UIImageView createRoundedRectImage:image size:self.bounds.size radius:cornerRaduis];
                    self.image = cornerImage;
                    [[SDImageCache sharedImageCache] storeImage:cornerImage forKey:cache64Path completion:nil];
                    //3.移除不需要显示的缓存的正常图片
                    [[SDImageCache sharedImageCache] removeImageForKey:imageUrl withCompletion:nil];
                }
                if (completedBlock) {
                    completedBlock(image, error, cacheType ,imageURL);
                }
            }];
        }
    }else{
        [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder completed:completedBlock];
    }
    
    
}


#pragma mark - 处理圆角图片
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    //根据圆角路径绘制
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    //CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}


@end
