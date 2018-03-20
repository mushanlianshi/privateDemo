//
//  LBNHAttentionAndFansView.m
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHAttentionAndFansView.h"

#define NormalColor kCommonBlackColor

#define HighLightColor [UIColor colorWithRed:0.88f green:0.54f blue:0.65f alpha:1.00f]

const NSInteger kAttentionStartTag = 200;

@interface LBNHAttentionAndFansView ()

@property (nonatomic, copy) NSArray *titlesArray;

@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation LBNHAttentionAndFansView

-(instancetype)initWithTitles:(NSArray *)titles{
    self=[super init];
    if (self) {
        self.titlesArray = titles;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    if (!_titlesArray) return;
    for (int i =0; i<_titlesArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:_titlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:NormalColor forState:UIControlStateNormal];
        [button setTitleColor:HighLightColor forState:UIControlStateSelected];
        button.tag = kAttentionStartTag +i;
        [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_titlesArray.count == 0) return;
    CGFloat width =self.width / _titlesArray.count;
    for (int i =0; i<_titlesArray.count; i++) {
        UIButton *button = [self viewWithTag:i+kAttentionStartTag];
        if (_normalTextColor) {
            [button setTitleColor:_normalTextColor forState:UIControlStateNormal];
        }
        if (_highLightTextColor) {
            [button setTitleColor:_highLightTextColor forState:UIControlStateSelected];
        }
        button.frame = CGRectMake(width*i, 0, width, self.height);
    }
}

-(void)setNormalTextColor:(UIColor *)normalTextColor{
    
    _normalTextColor = normalTextColor;
}

-(void)setHighLightTextColor:(UIColor *)highLightTextColor{
    _highLightTextColor = highLightTextColor;
}

-(void)itemClicked:(UIButton *)button{
    self.selectedButton.selected = NO;
    button.selected= YES;
    self.selectedButton = button;
    
    
    NSInteger index = button.tag - kAttentionStartTag;
    if (self.itemHandler) {
        self.itemHandler(button,index);
    }
}

-(void)defaultClickedIndex:(NSInteger)index{
    UIButton *button = [self viewWithTag:index + kAttentionStartTag];
    [self itemClicked:button];
}

@end
