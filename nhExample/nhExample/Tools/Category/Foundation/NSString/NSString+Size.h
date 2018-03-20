//
//  NSString+Size.h
//  nhExample
//
//  Created by liubin on 17/3/18.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 封装了  获取字符串宽高的方法
 */
@interface NSString (Size)


/** 获取高 */
-(CGFloat)heightWithLimitWidth:(CGFloat)width fontSize:(NSInteger)fontSize;

-(CGFloat)widhtWithLimitHeight:(CGFloat)height fontSize:(NSInteger)fontSize;

@end
