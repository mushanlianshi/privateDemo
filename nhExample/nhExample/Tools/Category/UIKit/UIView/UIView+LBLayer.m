//
//  UIView+LBLayer.m
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "UIView+LBLayer.h"
#import <objc/message.h>
@implementation UIView (LBLayer)

-(void)setLayerName:(NSString *)layerName{
    objc_setAssociatedObject(self, "layerName", layerName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)layerName{
    return objc_getAssociatedObject(self, "layerName");
}

-(void)setLayerBorderColor:(UIColor *)layerBorderColor{
    self.layer.borderColor = layerBorderColor.CGColor;
    [self _config];
}
-(void)setLayerBorderWidth:(CGFloat)layerBorderWidth{
    self.layer.borderWidth = layerBorderWidth;
    [self _config];
}
-(void)setLayerCornerRadius:(CGFloat)layerCornerRadius{
    self.layer.cornerRadius = layerCornerRadius;
    [self _config];
}
-(UIColor *)layerBorderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(CGFloat)layerBorderWidth{
    return self.layer.borderWidth;
}

-(CGFloat)layerCornerRadius{
    return self.layer.cornerRadius;
}

-(void)setLayerCornerRadius:(CGFloat)layerCornerRadius borderWitdh:(CGFloat)borderWitdh borderColor:(UIColor *)borderColor{
    self.layer.cornerRadius = layerCornerRadius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWitdh;
    [self _config];
}


- (void)_config {
    
    self.layer.masksToBounds = YES;
    // 栅格化 - 提高性能
    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}



- (void)setCornerType:(UIRectCorner)cornerType cornerRaduis:(CGFloat)cornerRaduis{
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:cornerType cornerRadii:CGSizeMake(cornerRaduis, cornerRaduis)];
    shapLayer.path = path.CGPath;
    self.layer.mask = shapLayer;
}

- (void)setCircle{
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.frame = self.bounds;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.height / 2];
    shapLayer.path = bezierPath.CGPath;
    //设置蒙板 形状
    self.layer.mask = shapLayer;
    
}


@end
