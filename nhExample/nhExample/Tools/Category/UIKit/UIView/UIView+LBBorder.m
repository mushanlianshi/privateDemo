//
//  UIView+LBBorder.m
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "UIView+LBBorder.h"

@implementation UIView (LBBorder)

-(void)showRedBorder{
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
}

-(void)showBlueBorder{
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
}
@end
