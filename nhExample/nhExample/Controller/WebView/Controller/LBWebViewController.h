//
//  LBWebViewController.h
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBaseViewController.h"

@interface LBWebViewController : LBBaseViewController

-(instancetype)initWithURLString:(NSString *)urlString title:(NSString *)title;

-(instancetype)initWithURL:(NSURL *)url title:(NSString *)title;

@end
