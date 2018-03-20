//
//  UIWebView+LBExtenstion.h
//  nhExample
//
//  Created by liubin on 17/5/2.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * UIWebView 的分类  主要是为了判断是否加载完   重定向的问题
 */
@interface UIWebView (LBExtenstion)


/**
 * 是否加载完成
 @return 加载完成结果
 */
-(BOOL)isFinishLoading;

@end
