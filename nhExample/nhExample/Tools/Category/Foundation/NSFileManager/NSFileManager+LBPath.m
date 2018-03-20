//
//  LBNHFileManager.m
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "NSFileManager+LBPath.h"

@implementation NSFileManager (LBPath)




+(NSString *)cachesPath{
    return [self pathForDirectory:NSCachesDirectory];
}

+(NSURL *)cachesURL{
    return [self URLForDirectory:NSCachesDirectory];
}

+(NSString *)libraryPath{
    return [self pathForDirectory:NSLibraryDirectory];
}

+(NSURL *)libraryURL{
    return [self URLForDirectory:NSLibraryDirectory];
}

+(NSString *)documentsPath{
    return [self pathForDirectory:NSDocumentDirectory];
}

+(NSURL *)documentsURL{
    return [self URLForDirectory:NSDocumentDirectory];
}




+(NSURL *)URLForDirectory:(NSSearchPathDirectory)pathDirectory{
    return [self.defaultManager URLsForDirectory:pathDirectory inDomains:NSUserDomainMask].firstObject;
}

+(NSString *)pathForDirectory:(NSSearchPathDirectory)pathDirectory{
    NSArray *array = NSSearchPathForDirectoriesInDomains(pathDirectory, NSUserDomainMask, YES);
    return [array firstObject];
}

#pragma mark 获取可用空间
+(double)availableDiskSpace{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.documentsPath error:nil];
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}
@end
