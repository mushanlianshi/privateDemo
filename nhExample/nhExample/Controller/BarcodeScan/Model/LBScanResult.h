//
//  LBScanResult.h
//  nhExample
//
//  Created by liubin on 17/5/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 扫描结果的模型类
 */
@interface LBScanResult : NSObject


/**
 * 扫描的结果
 */
@property (nonatomic, copy) NSString *resultString;


/**
 * 扫描识别的图片 可能为nil
 */
@property (nonatomic, strong) UIImage *image;


/**
 * 二维码的类型
 */
@property (nonatomic, copy) NSString *qrCodeType;

@end
