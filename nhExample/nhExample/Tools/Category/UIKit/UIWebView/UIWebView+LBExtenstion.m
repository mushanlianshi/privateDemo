//
//  UIWebView+LBExtenstion.m
//  nhExample
//
//  Created by liubin on 17/5/2.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "UIWebView+LBExtenstion.h"

@implementation UIWebView (LBExtenstion)

- (BOOL)isFinishLoading{
    NSString *readState = [self stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    BOOL complete = [readState isEqualToString:@"complete"];
    if (complete && !self.isLoading) {
        return YES;
    }else{
        return NO;
    }
}

@end
