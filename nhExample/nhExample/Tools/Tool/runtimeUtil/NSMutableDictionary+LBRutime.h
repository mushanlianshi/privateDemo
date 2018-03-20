//
//  NSMutableDictionary+LBRutime.h
//  LBSamples
//
//  Created by liubin on 17/4/26.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 交换setObject的工具类  防止崩溃用的
 * NSMutableDictionary类簇有 __NSDictionaryM
 * NSDictionary类簇有 __NSSingleEntryDictionaryI  __NSDictionary0
 */
@interface NSMutableDictionary (LBRutime)

@end
