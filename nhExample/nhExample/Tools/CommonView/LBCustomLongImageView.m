//
//  LBCustomLongImageView.m
//  nhExample
//
//  Created by liubin on 17/4/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomLongImageView.h"

NSInteger const kMaxHeight = 500; //图片大于500 就是长图  下面加载一个label显示点击查看长图
NSInteger const kLongLabelTag = 501; //显示长图标签的label的tag

@interface LBCustomLongImageView ()

{
    CGFloat orginalHeight;
}

@end

@implementation LBCustomLongImageView



-(void)setFrame:(CGRect)frame{
    orginalHeight = frame.size.height;
    frame.size.height = frame.size.height > kMaxHeight ? kMaxHeight : frame.size.height;
    [super setFrame:frame];
    [self showLongPictureLabel:orginalHeight > kMaxHeight ? YES : NO];
}

-(void)showLongPictureLabel:(BOOL)isShow{
    //先判断是否有显示的  先移除  这样下面只用判断是否显示即可
    UILabel *isExistLabel = [self viewWithTag:kLongLabelTag];
    [isExistLabel removeFromSuperview];
    if (isShow) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, orginalHeight - 30, self.width, 30);
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        label.textAlignment = NSTextAlignmentCenter;
//        [label showRedBorder];
        label.tag = kLongLabelTag;
        label.textColor = [UIColor whiteColor];
        label.font = kFont(14);
        label.text = @"点击查看长图";
        [self addSubview:label];
    }
}

@end
