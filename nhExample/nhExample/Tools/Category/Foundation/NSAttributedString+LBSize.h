//
//  NSAttributedString+LBSize.h
//  nhExample
//
//  Created by liubin on 17/4/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 根据约束计算富文本的高度
 */
@interface NSAttributedString (LBSize)

- (CGFloat)heightWithLimitWidth:(CGFloat)limitWidth;

@end
