//
//  NSString+LBConvert.h
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 字符串的一些转换 处理的分类
 */
@interface NSString (LBConvert)

/**
 * 字符串翻转
 */
-(NSString *)reverseString;

/**
 * 字符串翻转  利用OC的迭代器来处理的
 */
-(NSString *)reverseStringByOC;


/**
 * 把汉字转换成拼音
 */
-(NSString *)transformToPinYin;


/**
 * 根据分隔字符串分隔字符串
 @param separateString 分隔的字符串样式 例：abc,vfr,
 @return 分隔号的数组
 */
-(NSArray *)separateByString:(NSString *)separateString;


/**
 * 去除出现的字符串中内容

 @param appearString 要删除的出现的字符串
 @return 返回处理过的内容
 */
- (NSString *)deleteAppearString:(NSString *)appearString;

/**
 * 把阿拉伯数字转成中文121
 @return 转换后的中文 一百二十一
 */
-(NSString *)arebicTranslation;


/**
 * 获取字符串的长度 一个汉字算2个
 @return 字符串的长度
 */
-(int)convertToIntLenght;


/**
 * 获取字符串的长度
 @return 字符串的长度
 */
-(NSUInteger) unicodeLengthOfString;

- (NSString *)base64String;
@end
