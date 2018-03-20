//
//  LBButtonUtils.m
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBButtonUtils.h"

@implementation LBButtonUtils
+(UIButton *)creatButtonImage:(NSString *)imageName title:(NSString *)title addTarget:(id)target selector:(SEL)selector FontSize:(CGFloat)fontSize;{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:ImageNamed(imageName) forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (fontSize) {
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    return button;
}
@end
