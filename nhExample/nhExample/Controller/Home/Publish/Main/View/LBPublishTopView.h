//
//  LBPublishTopView.h
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LBTopicItemClicked)(UIButton *button);
// 默认高度60最好
@interface LBPublishTopView : UIView
/** 热门的名字 */
@property (nonatomic, copy) NSString *topicName;

@property (nonatomic, copy) LBTopicItemClicked topicHandler;
@end
