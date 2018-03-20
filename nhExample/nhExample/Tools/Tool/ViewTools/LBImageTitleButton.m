//
//  LBImageTitleButton.m
//  LBSamples
//
//  Created by liubin on 17/2/6.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBImageTitleButton.h"

@implementation LBImageTitleButton

-(instancetype)init{
    self=[super init];
    if (self) {
        self.imageView.contentMode=UIViewContentModeCenter;
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
