//
//  LBScanNative.h
//  nhExample
//
//  Created by liubin on 17/5/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBScanResult;


/**
 * 生成带logo二维码的图片
 - LBQRCodeLogoTypeCenter: 居中
 - LBQRCodeLogoTypeRightBottom: 右下角
 */
typedef NS_ENUM(NSInteger, LBQRCodeLogoType){
    LBQRCodeLogoTypeCenter,
    LBQRCodeLogoTypeRightBottom,
};


/**
 * 扫描的工具类
 */
@interface LBScanNative : NSObject


/**
 * 初始化扫描工具
 @param superView 父控件  用来把扫描区域的layer添加上用的
 @param scanRect 扫描的真实区域
 @param scanTypes 扫描二维码的类型
 @param success 扫描结果回调
 */
-(instancetype)initWithSuperView:(UIView *)superView scanRect:(CGRect)scanRect scanTypes:(NSArray *)scanTypes success:(void(^)(NSArray<LBScanResult *> *array))success;


/**
 * 是否需要捕获到的图片
 */
@property (nonatomic, assign) BOOL isNeedCaptureImage;

/** 开始扫描 */
-(void)startScan;

-(void)stopScan;


/**
 * 设置闪光灯是否开启
 @param isOn YES 打开 NO 关闭
 */
-(void)setFlashState:(BOOL)isOn;

-(BOOL)isFlashAvalible;

////////////////////////////////////////

/** 识别图片中的二维码 */
+(void)recognizeImage:(UIImage *)image success:(void(^)(NSArray <LBScanResult *> *array))success;

/** 根据字符串创建一个二维码 二维码的大小 */
+(UIImage *)createQRCodeString:(NSString *)string QRSize:(CGSize)qrSize;


/**
 创建生成带logo的二维码
 
 @param string 二维码内容
 @param qrSize 二维码大小
 @param logoImage logo图片
 @param logoType logo的位置
 @return 图片
 */
+(UIImage *)createQRCodeString:(NSString *)string QRSize:(CGSize)qrSize logoImage:(UIImage *)logoImage logoType:(LBQRCodeLogoType)logoType;

+(UIImage *)createQRCodeString:(NSString *)string QRSize:(CGSize)qrSize logoImage:(UIImage *)logoImage logoSize:(CGSize)logoSize logoType:(LBQRCodeLogoType)logoType;

/**
 生成QR二维码
 
 @param text 字符串
 @param size 大小
 @param qrColor 二维码前景色
 @param bkColor 二维码背景色
 @return 二维码图像
 */
+ (UIImage*)createQRWithString:(NSString*)text QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor;


/**
 生成条形码
 
 @param text 字符串
 @param size 大小
 @return 返回条码图像
 */
+ (UIImage*)createBarCodeWithString:(NSString*)text QRSize:(CGSize)size;

@end
