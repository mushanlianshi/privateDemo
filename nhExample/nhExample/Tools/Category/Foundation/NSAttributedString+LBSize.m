//
//  NSAttributedString+LBSize.m
//  nhExample
//
//  Created by liubin on 17/4/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "NSAttributedString+LBSize.h"

@implementation NSAttributedString (LBSize)


- (CGFloat)heightWithLimitWidth:(CGFloat)limitWidth{
    if (!self || ![self isKindOfClass:[NSAttributedString class]]) {
        return 0;
    }
    
    return [self boundingRectWithSize:CGSizeMake(limitWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 3;
}

@end
