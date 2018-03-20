//
//  LBNHFileManager.h
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 文件路径 
 */
@interface NSFileManager (LBPath)



+(NSString *)cachesPath;
+(NSURL *)cachesURL;

+(NSString *)libraryPath;
+(NSURL *)libraryURL;

+(NSString *)documentsPath;
+(NSURL *)documentsURL;

/**
 可用空间
 */
+(double)availableDiskSpace;
@end
