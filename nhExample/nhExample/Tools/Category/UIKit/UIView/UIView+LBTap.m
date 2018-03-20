//
//  UIView+LBTap.m
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "UIView+LBTap.h"
#import <objc/runtime.h>

/** 添加点击的block属性 */
static const char *ActionHandlerTapGestureKey ;

@implementation UIView (LBTap)

-(void)addTapBlock:(dispatch_block_t)tapBlock{
    self.userInteractionEnabled = YES;
//    //1.获取点击的手势  
//    UITapGestureRecognizer  *tapGesture= objc_getAssociatedObject(self, &ActionHandlerTapGestureKey);
//    //2.如果手势不存在   就创建手势
//    if (!tapGesture) {
//        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionFroTapGesture:)];
//        [self addGestureRecognizer:tapGesture];
//        //3.
////        objc_setAssociatedObject(self, &ActionHandlerTapGestureKey, tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    }
//    //3.copy传进来的block
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionFroTapGesture:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    if (tapBlock) {
        objc_setAssociatedObject(self, &ActionHandlerTapGestureKey, tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
}



-(void)handleActionFroTapGesture:(UITapGestureRecognizer *)tapGesture{
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
         dispatch_block_t block = objc_getAssociatedObject(self, &ActionHandlerTapGestureKey);
        if (block) {
            block();
        }
    }
   
}

@end
