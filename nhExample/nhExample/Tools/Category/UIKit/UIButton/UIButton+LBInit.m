//
//  UIButton+LBInit.m
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "UIButton+LBInit.h"

@implementation UIButton (LBInit)
-(instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target selector:(SEL)selector{
    return [self initWithTitle:title titleColor:titleColor titleFont:nil backGroundColor:nil target:target selector:selector];
}

-(instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)font backGroundColor:(UIColor *)backGroundColor target:(id)target selector:(SEL)selector{
    self = [super init];
    if (self) {
        [self setTitle:title titleColor:UIControlStateNormal];
        if (font) {
            self.titleLabel.font = font;
        }
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = backGroundColor ? backGroundColor : [UIColor whiteColor];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

/** 默认设置normal状态 */
-(void)setTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}

/** 默认设置normal状态 */
-(void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

-(void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor state:(UIControlState)state{
    [self setTitle:title forState:state];
    [self setTitleColor:titleColor forState:state];
}
@end
