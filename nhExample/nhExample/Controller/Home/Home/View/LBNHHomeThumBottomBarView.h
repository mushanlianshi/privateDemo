//
//  LBNHHomeThumBottomBarView.h
//  nhExample
//
//  Created by liubin on 17/3/17.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 *底部菜单栏点击的类型
 */
typedef NS_ENUM(NSInteger, LBNHThumBottomClickedType){
    LBNHThumBottomClickedTypeThum = 1 , //赞
    LBNHThumBottomClickedTypeStep  ,    //踩
    LBNHThumBottomClickedTypeComment , //评论
    LBNHThumBottomClickedTypeShare,   //分享
};

typedef void(^LBNHThumBottomClickTypeHandler)(LBNHThumBottomClickedType type, NSInteger numbers, UIButton *button);

/**
 * 封装底部赞 、分享等按钮的view
 */
@interface LBNHHomeThumBottomBarView : UIView

-(instancetype)initWithThums:(NSString *)thums steps:(NSString *)steps comments:(NSString *)comments share:(NSString *)shares;

-(void)setThums:(NSString *)thums steps:(NSString *)steps comments:(NSString *)comments share:(NSString *)shares;


-(void)setThums:(NSInteger)thums steps:(NSInteger)steps comments:(NSInteger)comments;

/**
 * 底部点击的block回调
 */
@property (nonatomic, copy) LBNHThumBottomClickTypeHandler bottomHandler;

@end
