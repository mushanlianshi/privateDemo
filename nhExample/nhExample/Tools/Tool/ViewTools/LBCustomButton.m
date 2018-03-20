//
//  LBCustomButton.m
//  nhExample
//
//  Created by baletu on 2017/12/25.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomButton.h"
@interface LBCustomButton ()

@end

@implementation LBCustomButton

- (void)layoutSubviews{
    [super layoutSubviews];
    switch (self.layoutType) {
        case LBButtonLayoutTypeImageTop:
        {
            CGFloat contentHeight = self.currentImage.size.height + self.layoutHoriMargin + self.titleLabel.intrinsicContentSize.height;
            CGFloat contentWidth = self.currentImage.size.width + self.titleLabel.intrinsicContentSize.width;
            
            //计算图片中心上移的距离
            CGFloat imageYOffset = self.bounds.size.height / 2 - (self.bounds.size.height / 2 - contentHeight / 2 + self.currentImage.size.height / 2);
            //计算图片中心右移的位置
            CGFloat imageXOffset = self.bounds.size.width / 2 - (self.bounds.size.width /2 - contentWidth / 2 + self.currentImage.size.width / 2);
            
            //1.图片往上移计算的高度  底部也向上移计算的高度
            self.imageEdgeInsets = UIEdgeInsetsMake(- imageYOffset, imageXOffset, imageYOffset, -imageXOffset);
            //计算文字中心下移的距离
            CGFloat titleYOffset = (self.bounds.size.height / 2 - contentHeight / 2 + self.currentImage.size.height + self.layoutVerticalMargin + self.titleLabel.intrinsicContentSize.height / 2)   - self.bounds.size.height / 2;
            //计算文字中心左移的位置
            CGFloat titleXOffset = (self.bounds.size.width / 2 - contentWidth /2 + self.currentImage.size.width + self.titleLabel.intrinsicContentSize.width / 2) -self.bounds.size.width / 2 ;
            
            self.titleEdgeInsets = UIEdgeInsetsMake(titleYOffset, -titleXOffset, -titleYOffset, titleXOffset);
        }
            break;
        case LBButtonLayoutTypeImageLeft:
        {
            //1. 图片向左偏移margin的一半
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -self.layoutHoriMargin / 2, 0, 0);
            //2. 文字向右偏移maigin的一半
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.layoutHoriMargin / 2);
        }
            break;
        case LBButtonLayoutTypeImageBottom:
        {
            
            CGFloat contentHeight = self.currentImage.size.height + self.layoutHoriMargin + self.titleLabel.intrinsicContentSize.height;
            CGFloat contentWidth = self.currentImage.size.width + self.titleLabel.intrinsicContentSize.width;
            
            //计算图片中心下移的距离
            CGFloat imageYOffset = (self.bounds.size.height / 2 - contentHeight / 2 + self.titleLabel.intrinsicContentSize.height + self.layoutVerticalMargin + self.currentImage.size.height / 2) - self.bounds.size.height / 2;
            //计算图片中心右移的位置
            CGFloat imageXOffset = self.bounds.size.width / 2 - (self.bounds.size.width /2 - contentWidth / 2 + self.currentImage.size.width / 2);
            //1.图片往下移计算的高度  底部也向下移计算的高度
            self.imageEdgeInsets = UIEdgeInsetsMake(imageYOffset, imageXOffset, -imageYOffset, -imageXOffset);
            //计算文字中心上移的距离
            CGFloat titleYOffset = self.bounds.size.height / 2 - (self.bounds.size.height / 2 - contentHeight / 2 + self.titleLabel.intrinsicContentSize.height / 2);
            //计算文字中心左移的位置
            CGFloat titleXOffset = (self.bounds.size.width / 2 - contentWidth /2 + self.currentImage.size.width + self.titleLabel.intrinsicContentSize.width / 2) -self.bounds.size.width / 2 ;
            self.titleEdgeInsets = UIEdgeInsetsMake(-titleYOffset, -titleXOffset, titleYOffset, titleXOffset);
        }
            break;
        case LBButtonLayoutTypeImageRight:
        {
            CGFloat imageOffset = self.titleLabel.intrinsicContentSize.width + self.layoutHoriMargin / 2;
            //1. 图片向右偏移文字的宽度
            self.imageEdgeInsets = UIEdgeInsetsMake(0,  imageOffset, 0, -imageOffset);
            CGFloat titleOffset = self.currentImage.size.width + self.layoutHoriMargin / 2;
            //2. 文字向左偏移图片宽度
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
        }
            break;
            
        default:
            break;
    }
}

@end


