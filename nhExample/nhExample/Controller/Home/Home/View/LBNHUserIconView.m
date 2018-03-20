//
//  LBNHUserIconView.m
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHUserIconView.h"
#import "UIView+LBTap.h"
#import "LBNHBaseImageView.h"

@interface LBNHUserIconView ()

@property (nonatomic, strong) LBNHBaseImageView *imageView;

@end

@implementation LBNHUserIconView

-(instancetype)init{
    self=[super init];
    if (self) {
        [self initUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

-(void)setIconUrl:(NSString *)iconUrl{
    [self.imageView setImagePath:iconUrl placeHolder:nil];
}

-(void)initUI{
    self.userInteractionEnabled = YES;
    WS(weakSelf);
    [self.imageView addTapBlock:^{
        if (weakSelf.tapHandler) {
            weakSelf.tapHandler(weakSelf);
        }
    }];
}

-(LBNHBaseImageView *)imageView{
    if (!_imageView) {
        _imageView = [[LBNHBaseImageView alloc] init];
        _imageView.layer.cornerRadius = 17.5;
//        _imageView.backgroundColor = [UIColor redColor];
//        _imageView.frame = CGRectMake(0, 0, 35, 35);
        _imageView.clipsToBounds = YES;
        _imageView.contentMode  =UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
            make.left.equalTo(self).offset(-10);
            make.top.bottom.equalTo(self);
            make.width.equalTo(self);
        }];
    }
    return _imageView;
}

@end
