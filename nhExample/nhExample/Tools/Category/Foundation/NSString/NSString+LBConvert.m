//
//  NSString+LBConvert.m
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "NSString+LBConvert.h"

@implementation NSString (LBConvert)
-(NSString *)reverseString{
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:self.length];
    //倒叙获取字符
    for (NSInteger i = self.length-1; i>=0; i--) {
        unichar ch = [self characterAtIndex:i];
        [newString appendFormat:@"%c",ch];
    }
    return  [NSString stringWithString:newString];
}

-(NSString *)reverseStringByOC{
    NSMutableString *reverseString = [[NSMutableString alloc] initWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationReverse|NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        [reverseString appendString:substring];
    }];
    return reverseString;
}


-(NSString *)transformToPinYin{
    NSMutableString *pinyin = [self mutableCopy];
    //1.将汉字转拼音
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"带音标的字符串 %@ ",pinyin);
    //2.去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"汉字转换的结果 %@ ",pinyin);
    return pinyin;
}

-(NSArray *)separateByString:(NSString *)separateString{
    //获取分隔的字符集
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:separateString];
    return [self componentsSeparatedByCharactersInSet:set];
}

-(NSString *)arebicTranslation
{
//    NSString *self = self;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < self.length; i ++) {
        NSString *substr = [self substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[self.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@",self);
    NSLog(@"%@",chinese);
    return chinese;
}

-(int)convertToIntLenght{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p)
        {
            p++;
            strlength++;
        }
        else
        {
            p++;
        }
        
    }
    return strlength;
}

//方法二：
-(NSUInteger) unicodeLengthOfString;
{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++)
    {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}


/**
 * 去除出现的字符串中内容
 
 @param appearString 要删除的出现的字符串
 @return 返回处理过的内容
 */
- (NSString *)deleteAppearString:(NSString *)appearString{
    //1.根据要删除的字符串生成charact集合
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:appearString];
    
    //获取charact集合里没有包含的剩下的字符集合
//    NSCharacterSet *invertedSet = [set invertedSet];
    
    //2.根据charact集合里的内容吧字符串分成去掉后的数组
    NSArray *array = [self componentsSeparatedByCharactersInSet:set];
    //3.根据处理后的数组用空字符分开拼成字符串返回
    NSString *result = [array componentsJoinedByString:@""];
    return result;
}

- (NSString *)base64String{
    if (!self) return  nil;
    NSData* originData = [self dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return encodeResult;
}

@end
