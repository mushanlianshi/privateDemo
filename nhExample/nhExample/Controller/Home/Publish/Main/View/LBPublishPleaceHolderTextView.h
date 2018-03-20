//
//  LBPublishPleaceHolderTextView.h
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBPublishPleaceHolderTextView;
@protocol LBPublishPleaceHolderDelegate <NSObject>

-(void)pleaceHolderTextChanged:(LBPublishPleaceHolderTextView *)pleaceTextView;

@end

/**
 * 一个自定义pleaceHolder的textView
 */

@interface LBPublishPleaceHolderTextView : UITextView

@property (nonatomic, weak) id<LBPublishPleaceHolderDelegate> delegate;

/** 提示的文字 */
@property (nonatomic, copy) NSString *pleaceHolder;

/** 提示的文字颜色 */
@property (nonatomic, strong) UIColor *pleaceHolderColor;

/** 提示的文字左边的间距 */
@property (nonatomic, assign) CGFloat pleaceHolderLeftMargin;

/** 提示的文字top的间距 */
@property (nonatomic, assign) CGFloat pleaceHolderTopMargin;

/** 提示的文字的字体 */
@property (nonatomic, strong) UIFont *pleaceHolderFont;
@end
