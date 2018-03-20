//
//  LBNHUserIconView.h
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBNHUserIconView;

typedef void(^IconViewTapGestureHandler)(LBNHUserIconView *iconView);

/**
  首页左上角个人中心的头像view
 */
@interface LBNHUserIconView : UIView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) IconViewTapGestureHandler tapHandler;
@end
