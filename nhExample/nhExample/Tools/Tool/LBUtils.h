//
//  LBUtils.h
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBUtils : NSObject


/**
 * 判断是否是当前登录的用户
 */
+(BOOL)isCurrentLoginUserInfo:(NSInteger)userID;


/**
 * 禁止SDwebImage解压缩图片 高清图片解压缩会相当消耗内存  小图片解压缩
 */
+(void)forBiddenSDWebImageDecode:(BOOL)isForbidden;



#pragma mark 时间格式化相关的
/** 根据格式化字符串 时间戳转时间 */
+(NSString *)convertTime:(NSTimeInterval)time WithFormatterString:(NSString *)formatterString;

/** 把时间戳转成几天 几分钟 刚刚的方法 */
+(NSString *)converTimeToMinutesAgo:(NSTimeInterval)time;

// 获取当前设备可用内存(单位：MB）
+ (NSInteger )availableMemory;

// 获取总内存（单位：MB）
+ (NSInteger)totalMemory;

/** 截屏 */
+ (UIImage *)screenshot;


/**
 * 获取一个富文本
 @param string 总文字
 @param keyWords 需要高亮的文字
 @param font 默认字体大小
 @param highLightColor 高亮的颜色
 @param textColor 默认的颜色
 @param lineSpace 字间距
 */
+ (NSAttributedString *)attributeWithString:(NSString *)string keyWords:(NSString *)keyWords font:(UIFont *)font highLightColor:(UIColor *)highLightColor textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace;


/**
 * 获取广告标示
 @return 广告标示
 */
+ (NSString *)idfa;


/**
 * 替代UDID的 同一个设备 同一个应用的idfv是一样的
 */
+ (NSString *)idfv;

//,翻译过来就是通用唯一标识符。是一个32位的十六进制序列  每秒都不一样的
+ (NSString *)uuid;

/**
 * 颜色转成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  判断字符串是否为空
 */
+ (BOOL)isBlankString:(NSString *)string;

/** 获取某路径下文件的大小 */
+(float)folderSizeAtPath:(NSString *)path;

/** 清楚某路径下的文件 */
+(void)clearCache:(NSString *)path;

/** 每次启动调用保存app启动时间的方法 用来判断两次启动时间间隔的 */
+(void)saveLastLaunchAPPTime;

/** 获取上次启动app的时间  距离1970 */
+(long)lastLaunchAPPTime;

/** 获取两次启动的时间差 */
+(long)lastLauchAPPToNow;

/** 获取系统版本号 */
+(NSString *)appVersion;

/** 获取IP地址 不是mac地址 mac地址在IOS7以后就获取不到了
 *IP地址是指使用TCP/IP协议指定给主机的32位地址，由用点分隔开的4个8八位组构成，如192.168.1.101就是一个
 * MAC地址一般长度为48位，通常表示为12个16进制数，每2个16进制数之间会用冒号隔开，比如03:03:30:3A:3B:3C就是一个MAC地址 保证世界上每个以太网设备都具有唯一的MAC地址。
 */
+ (NSString *)getCurrentLocalIP;

/** 无线网名称 */
+ (NSString *)getCurreWiFiSsid;



/**
 * 将一个view转换成image图片  一般用来做动画或则保存用的

 @param view 要转成图片的view
 @return 一张图片
 */
+(UIImage *)snapImageForView:(UIView *)view;

/** 
 * 获取富文本的高度
 */
+(CGFloat )heightForAttributeString:(NSAttributedString *)attributeString LimitWidth:(CGFloat)limitWidth;

/** 把一个view保存成pdf的文件 */
+(void)saveView:(UIView *)view pdfFile:(NSString *)filePath;



/**
 * 打印字典模型所需的属性   copy到模型中用的

 @param dict 字典的数据
 */
+ (void)MApropertyModelWithDictionary:(NSDictionary *)dict;


/**
 *判断是否越狱

 @return 是否越狱
 */
+(BOOL)isHasJailBroken;


/** 获取当前时间的0点的日期 */
+ (NSDate *)zeroOfDate;


/**
 * 把characters字符集里的字符换成replaceString的字符串从originalString
 * param characters：需要被替换的字符集 集成一个字符串的方式
 * param replaceString ： 需要替换成的字符串 例如：把敏感词汇characters替换成* 也可以替换成空 那就是删除特殊字符了
 * param originalString ： 把这个字符串里的特殊字符进行替换
 */
-(NSString *)replaceCharacter:(NSString *)characters  replaceCharacters :(NSString *)replaceString fromString : (NSString *)originalString;

@end
