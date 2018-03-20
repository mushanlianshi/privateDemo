//
//  LBPublishPickImageBottomView.h
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBPublishPickImageBottomView;

@protocol LBPublishPickImageBottomViewDelegate <NSObject>

/** 是否是匿名的回调 */
-(void)publishPickImage:(LBPublishPickImageBottomView *)publishImageView isWithOutName:(BOOL)withOutName;

/** 选择图片的回调 */
-(void)publishPickImageSelected:(LBPublishPickImageBottomView *)publishImageView;

@end

/**
 * 底部选择图片的view 高度80最好
 */
@interface LBPublishPickImageBottomView : UIView

@property (nonatomic, assign) NSInteger hintNumber;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, weak) id<LBPublishPickImageBottomViewDelegate> delegate;

@end
