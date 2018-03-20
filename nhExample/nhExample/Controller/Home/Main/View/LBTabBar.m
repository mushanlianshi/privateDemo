//
//  LBTabBar.m
//  nhExample
//
//  Created by liubin on 17/5/12.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBTabBar.h"

const CGFloat kUpMargin = 20;

#define kTabBarFont [UIFont systemFontOfSize:13]
#define TabbarTextColor [UIColor colorWithRed:0.62f green:0.62f blue:0.63f alpha:1.00f]


@interface LBTabBar()

/** 中间凸起的button */
@property (nonatomic, strong) UIButton *centerButton;

/** 凸起按钮下面显示的文字 */
@property (nonatomic, strong) UILabel *centernLabel;

@end


@implementation LBTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.centerButton setImage:[UIImage imageNamed:@"tabbar_center"] forState:UIControlStateNormal];
        self.centerButton.adjustsImageWhenHighlighted = NO;
        [self.centerButton setTitle:@"发布" forState:UIControlStateNormal];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGSize imageSize = self.centerButton.imageView.image.size;
    //1.调整中间button的位置
    self.centerButton.size = imageSize;
    self.centerButton.center = CGPointMake(width/2, height/2 - kUpMargin-1);
    
    self.centernLabel.size = CGSizeMake(imageSize.width, 20);
    self.centernLabel.center = CGPointMake(width/2, CGRectGetMaxY(self.centerButton.frame)+kUpMargin/2);
    self.centernLabel.text = @"发现";

    //tabbar的子item的按钮的类型
    Class class = NSClassFromString(@"UITabBarButton");
    int i = 0;
    for (UIView *view in self.subviews) {
        //如果是tabbar的item  我们调整位置  这里按4个正常的一个凸起的算  毕竟总数要求是单数
        if ([view isKindOfClass:class]) {
            view.frame = CGRectMake((width/5)*i, 0, width/5, height);
            i++;
            //如果是正常第三个 在加一个 让他变成center后面的第四个
            if (i == 2) {
                i ++;
            }
        }
    }
}

-(void)setCenterTitle:(NSString *)centerTitle{
    if ([centerTitle isEqualToString:_centerTitle]) return;
    _centerTitle = centerTitle;
    self.centernLabel.text = centerTitle;
}

-(UIButton *)centerButton{
    
    if (!_centerButton) {
        _centerButton = [[UIButton alloc] init];
        [_centerButton addTarget:self action:@selector(centerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_centerButton];
    }
    return _centerButton;
}

-(UILabel *)centernLabel{
    if (!_centernLabel) {
        _centernLabel = [[UILabel alloc] init];
        _centernLabel.textAlignment = NSTextAlignmentCenter;
        _centernLabel.font = kTabBarFont;
        _centernLabel.textColor = TabbarTextColor;
        [self addSubview:_centernLabel];
    }
    return _centernLabel;
}

-(void)centerButtonClicked:(UIButton *)button{
    NSLog(@"LBLog tabbar center button clicked ==============");
    if (self.centerClick) {
        self.centerClick(self);
    }
}

/** 重写系统的hitTest分发事件 */
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.hidden == NO) {
        //1.把tabbar的触摸点转换到中间按钮的身上，判断是否在中间按钮里
        CGPoint newPoint=  [self convertPoint:point toView:self.centerButton];
        //如果点在中间按钮里 让中间按钮响应
        if ([self.centerButton pointInside:newPoint withEvent:event]) {
            return self.centerButton;
        }else{
            //不在  在分发给系统 处理
            return [super hitTest:point withEvent:event];
        }
    }else{
        //如果不可见 就直接让系统分发
        return [super hitTest:point withEvent:event];
    }
}

///** 重写pointInside事件 为了让他中间按钮的响应区域多点 和重写hitTest事件一样 比较麻烦 */
//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    NSLog(@"LBLog pointInside  %@ %@",NSStringFromCGPoint(point),NSStringFromCGRect(self.frame));
//    BOOL resut =CGRectContainsPoint(self.bounds, point);
//    NSLog(@"LBLog contatins %d ",resut);
//    return resut;
//}

@end
