//
//  LBScanViewStyle.m
//  nhExample
//
//  Created by liubin on 17/5/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBScanViewStyle.h"

@implementation LBScanViewStyle

-(instancetype)init{
    self = [super init];
    if (self) {
        _isNeedShowScanViewBorder = NO;
        _whScale = 1;
        _offsetCenterUp = 20;
        _offsetSideMargin = 20;
        _noRecoginzeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
        _cornerColor = [UIColor colorWithRed:0. green:167./255. blue:231./255. alpha:1.0];
        _borderColor = [UIColor colorWithRed:0. green:167./255. blue:231./255. alpha:1.0];
        _animationStyle = LBScanAnimationStyleGrid;
        _cornerStyle = LBScanFrameCornerStyleInner;
        _cornerLineH = 16;
        _cornerLineW = 16;
        _cornerLineBorderWidth = 2;
    }
    return self;
}


+(LBScanViewStyle *)alipayStyle{
    LBScanViewStyle *style = [[LBScanViewStyle alloc] init];
    style.offsetCenterUp = 60 + 30 ;
    style.offsetSideMargin = 30;
    if ([UIScreen mainScreen].bounds.size.height <= 480) {
        style.offsetCenterUp = 40 + 30 ;//注意有导航栏的情况会下移
        style.offsetSideMargin = 20;
    }
    style.cornerLineH = 16.f;
    style.cornerLineW = 16.f;
    style.cornerLineBorderWidth = 2.f;
    style.animationStyle = LBScanAnimationStyleGrid;
    style.animationImage = ImageNamed(@"CodeScan.bundle/qrcode_scan_full_net");
    
    return style;
}

+(LBScanViewStyle *)QQStyle{
    LBScanViewStyle *style = [[LBScanViewStyle alloc] init];
    style.offsetCenterUp = 44;
    style.offsetSideMargin = 30;
    style.cornerLineBorderWidth = 6;
    style.cornerLineW = 24;
    style.cornerLineH = 24;
    style.cornerStyle = LBScanFrameCornerStyleOutter;
    style.animationStyle = LBScanAnimationStyleLine;
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    return style;
}


@end
