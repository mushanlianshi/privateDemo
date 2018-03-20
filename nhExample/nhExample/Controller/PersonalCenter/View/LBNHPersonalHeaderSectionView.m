//
//  LBNHPersonalHeaderSectionView.m
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHPersonalHeaderSectionView.h"

const NSInteger startTag = 200;

@interface LBNHPersonalHeaderSectionView()

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, strong) UIButton *selectedButton;


/**
 * 下面滚动的线
 */
@property (nonatomic, strong) CALayer *runningLineLayer;
@end

@implementation LBNHPersonalHeaderSectionView

-(instancetype)initWithTitles:(NSArray<NSString *> *)titles{
    self=[super init];
    if (self) {
        self.titles = titles;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    if (!_titles) return;
    for (int i=0; i<_titles.count; i++) {
        UIButton *button  = [[UIButton alloc] init];
        button.tag = startTag+i;
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = kFont(14);
        [button setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
        [button setTitleColor:kCommonHighLightRedColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)itemClicked:(UIButton *)button{
    self.selectedButton.selected = NO;
    
    button.selected = YES;
    self.selectedButton = button;
    NSInteger index = button.tag - startTag;
    if ([self.delegate respondsToSelector:@selector(personalSectionView:clickedIndex:)]) {
        [self.delegate personalSectionView:self clickedIndex:index];
    }
    
    //做底部选中条的动画
    [UIView animateWithDuration:0.5 animations:^{
        self.runningLineLayer.frame = CGRectMake(self.selectedButton.x+(self.selectedButton.width-80)/2, self.runningLineLayer.frame.origin.y, self.runningLineLayer.frame.size.width, self.runningLineLayer.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)defaultClickedIndex:(NSInteger)index{
    UIButton *button = [self viewWithTag:startTag+index];
    [self itemClicked:button];
}

-(CALayer *)runningLineLayer{
    if (!_runningLineLayer) {
        _runningLineLayer = [[CALayer alloc] init];
        [self.layer addSublayer:_runningLineLayer];
        _runningLineLayer.backgroundColor = kCommonHighLightRedColor.CGColor;
    }
    return _runningLineLayer;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.width/_titles.count;
    for (int i=0; i<_titles.count; i++) {
        UIButton *button  = [self viewWithTag:startTag+i];
        button.frame = CGRectMake(i*width, 0, width, self.height);
    }
}


/**
 * 重新计算layer的位置
 */
-(void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    if (self.selectedButton==nil) {
        self.selectedButton = [self viewWithTag:startTag];
    }
    self.runningLineLayer.frame = CGRectMake((self.selectedButton.width-80)/2, self.selectedButton.height-2, 80, 2);
}

@end
