//
//  LBTips.h
//  LBSamples
//
//  Created by liubin on 16/11/18.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBTips : NSObject
+(void)showTips:(NSString *)message;
-(void)showTips:(NSString *)message;
-(void)showCancelAlert:(NSString *)message;
@end
