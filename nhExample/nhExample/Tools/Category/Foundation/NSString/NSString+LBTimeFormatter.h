//
//  NSString+LBTimeFormatter.h
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 字符串与时间格式相关的分类
 */
@interface NSString (LBTimeFormatter)

/** 根据字符串格式格式化字符串 */
-(NSString *)convertTimeWithFormatterString:(NSString *)formatterString;




@end
