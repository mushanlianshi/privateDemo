//
//  LBNHSegmentView.m
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHSegmentView.h"
#import "UIView+LBLayer.h"

const NSInteger kStartTag = 100;

@interface LBNHSegmentView ()

@property (nonatomic, copy) NSArray *titlesArray;



/**
 记录上次选中的button的
 */
@property (nonatomic, strong) UIButton *lastButton;

@end

@implementation LBNHSegmentView

-(instancetype)initWithItemTitles:(NSArray *)titles{
    self=[super init];
    if (self) {
        self.titlesArray = titles;
        [self setLayerCornerRadius:3 borderWitdh:1 borderColor:kCommonTintColor];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    if (_titlesArray.count > 0) {
        for (int i =0; i<_titlesArray.count; i++) {
            if ([_titlesArray[i] isKindOfClass:[NSString class]]) {
                UIButton *button = [[UIButton alloc] init];
                button.tag = i + kStartTag;
                button.backgroundColor = kCommonBgColor;
                [button setTitle:_titlesArray[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [button setTitleColor:kCommonTintColor forState:UIControlStateNormal];
                [button addTarget:self action:@selector(segmentItemSelected:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
        }
    }
    
}



/**
  布局子button
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    if (self.titlesArray.count > 0) {
        for (int i = 0 ; i < _titlesArray.count; i++){
            UIButton *button = [self viewWithTag:i + kStartTag];
            button.frame = CGRectMake(i * width/_titlesArray.count, 0, width/_titlesArray.count, height);
            NSLog(@"segment button frame is %@ ",NSStringFromCGRect(button.frame));
        }
    }
}


-(void)segmentItemSelected:(UIButton *)button{
    if (self.lastButton) {
        self.lastButton.backgroundColor = kCommonBgColor;
        self.lastButton.selected = NO;
    }
    button.selected = YES;
    button.backgroundColor = kCommonTintColor;
    self.lastButton = button;
    
    //回调
    if (self.SegmentItemSelected) {
        self.SegmentItemSelected(self, button.tag-kStartTag, button.currentTitle);
    }
}

-(void)clickDefaultIndex:(NSInteger)index{
    UIButton *button = [self viewWithTag:index+kStartTag];
    [self segmentItemSelected:button];
}

@end
