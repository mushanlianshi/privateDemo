//
//  LBBottomAverageButtonView.m
//  nhExample
//
//  Created by liubin on 17/5/4.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBottomAverageButtonView.h"

static NSInteger kStartTag = 100;

@interface LBBottomAverageButtonView ()

@property (nonatomic, copy) NSArray *images;

@end

@implementation LBBottomAverageButtonView

-(instancetype)initImages:(NSArray *)images highImages:(NSArray *)highImages titles:(NSArray *)titles{
    self = [super init];
    if (self) {
        self.images = images;
        [self initUIImages:images highImages:highImages titles:titles];
    }
    return self;
}

-(instancetype)initImages:(NSArray *)images titles:(NSArray *)titles{
    return [self initImages:images highImages:nil titles:titles];
}

-(void)initUIImages:(NSArray *)images highImages:(NSArray *)highImages titles:(NSArray *)titles{
    for (int i = 0; i < images.count; i++) {
        UIButton *button = [[UIButton alloc] init];
//        [button setBackgroundImage:images[i] forState:UIControlStateNormal];
//        [button setBackgroundImage:highImages[i] forState:UIControlStateHighlighted];
        [button setImage:images[i] forState:UIControlStateNormal];
        if (highImages.count) {
            [button setImage:highImages[i] forState:UIControlStateHighlighted];
        }
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [button setTitle:titles[i] forState:UIControlStateNormal];
//        button.titleLabel.font = kFont(14);
        button.tag = kStartTag +i;
        [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)layoutSubviews{
    CGFloat itemW = self.bounds.size.width/self.images.count;
    CGFloat itemH = self.bounds.size.height;
    for (int i =0 ; i<self.images.count; i++) {
        LBBottomButton *button = [self viewWithTag:kStartTag+i];
        button.frame = CGRectMake(itemW * i, 0, itemW, itemH);
    }
    
}

-(void)itemClicked:(LBBottomButton *)button{
    NSInteger index = button.tag - kStartTag;
    button.selected = !button.isSelected;
    if (self.clickHandler) {
        self.clickHandler(index,button.isSelected);
    }
}

@end


@implementation LBBottomButton

-(instancetype)init{
    self=[super init];
    if (self) {
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    }
    return self;
}

#pragma  mark 重写button中的label的frame的方法
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return  CGRectMake(0, self.frame.size.height*0.6, self.frame.size.width, self.frame.size.height*0.35);
}
#pragma  mark 重写button中的imageView的frame的方法
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(self.frame.size.height*0.175, 0, self.frame.size.height*0.65, self.frame.size.height*0.6);
}
@end
