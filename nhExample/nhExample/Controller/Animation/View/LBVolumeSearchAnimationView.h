//
//  LBVolumeSearchAnimationView.h
//  nhExample
//
//  Created by baletu on 2017/8/29.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LBVolumeStateType){
    LBVolumeStateTypeSearch,
    LBVolumeStateTypeRecoginize,
};

/**
 * 仿动画搜索的view
 */
@interface LBVolumeSearchAnimationView : UIView

/** 动画的类型  是搜索还是识别的动画 */
@property (nonatomic,assign) LBVolumeStateType animationState;

/** 音量的大小 0-100 填充动画用的 */
@property (nonatomic,assign) NSInteger volume;

-(void)startAnimating;

-(void)stopAnimating;

@end
