//
//  LBTabBar.h
//  nhExample
//
//  Created by liubin on 17/5/12.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBTabBar;

typedef void(^LBTabBarCenterClick)(LBTabBar *tabbar);


/**
 * 自定义中间凸起的tabbar  继承自tabbar是为了用kvc设置tabbarController的tabbar 不影响系统的tabbar的响应链
 * kvc可以用来修改一些没暴露的属性
 */
@interface LBTabBar : UITabBar

@property (nonatomic, copy) LBTabBarCenterClick centerClick;

/** tabbar中间显示的文字 */
@property (nonatomic, copy) NSString *centerTitle;

@end

/** 用来计算中间凸起文字的地方的 */
@interface LBTabbarCenterButton : UIButton

@end
