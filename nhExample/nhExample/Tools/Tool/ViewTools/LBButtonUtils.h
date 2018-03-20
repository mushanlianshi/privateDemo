//
//  LBButtonUtils.h
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBButtonUtils : NSObject

+(UIButton *)creatButtonImage:(NSString *)imageName title:(NSString *)title addTarget:(id)target selector:(SEL)selector FontSize:(CGFloat)fontSize;

@end
