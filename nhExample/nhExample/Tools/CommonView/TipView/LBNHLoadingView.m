//
//  LBNHLoadingView.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHLoadingView.h"

@interface LBNHLoadingView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation LBNHLoadingView

-(instancetype)init{
    if (self=[super init]) {
        self.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    }
    return self;
}

-(void)showInSuperview:(UIView *)superView{
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    [superView addSubview:self.imageView];
    self.imageView.center = superView.center;
    self.imageView.bounds = CGRectMake(0, 0, 80, 120);
    [self.imageView startAnimating];
}

-(void)dismiss{
    [self.imageView stopAnimating];
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    [self.imagesArray removeAllObjects];
    self.imagesArray = nil;
    [self removeFromSuperview];
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        for (int i =0 ; i < 17; i++) {
            NSString *imageName = [NSString stringWithFormat:@"refreshjoke_loading_%d",i];
            UIImage *image = ImageNamed(imageName);
            [self.imagesArray addObject:image];
        }
        _imageView.animationImages = self.imagesArray;
        _imageView.animationDuration = 1.0f;
        _imageView.animationRepeatCount = 0;
    }
    return _imageView;
}

-(NSMutableArray *)imagesArray{
    if (!_imagesArray) {
        _imagesArray = [[NSMutableArray alloc] initWithCapacity:17];
    }
    return _imagesArray;
}

@end
