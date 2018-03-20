//
//  LBPublishTopView.m
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBPublishTopView.h"
#import "NSString+Size.h"

@interface LBPublishTopView()

/** 投稿至的label */
@property (nonatomic, strong) UILabel *label;

/** 吧名的button */
@property (nonatomic, strong) UIButton *topicButton;

/** 更换吧名的button */
@property (nonatomic, strong) UIButton *hintButton;
@end


@implementation LBPublishTopView

-(instancetype)init{
    self=[super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    
}

-(void)layoutSubviews{
    self.label.frame = CGRectMake(0, 0, 55, 20);
    self.label.centerY = self.centerY;
    
    CGFloat width = [self.topicButton.currentTitle widhtWithLimitHeight:30 fontSize:15];
    self.topicButton.frame = CGRectMake(55, 0, width+20, 30);
    self.topicButton.centerY = self.centerY;
    
    self.hintButton.frame = CGRectMake(CGRectGetMaxX(self.topicButton.frame)+10, 0, kScreenWidth-125, 25);
    self.hintButton.centerY = self.centerY;
}

/** 设置topicName  重新设置位置 */
-(void)setTopicName:(NSString *)topicName{
    [self.topicButton setTitle:topicName forState:UIControlStateNormal];
    CGFloat width  = [topicName widhtWithLimitHeight:30 fontSize:15];
    self.topicButton.width = width+20;
    self.hintButton.x = CGRectGetMaxX(self.topicButton.frame)+10;
}


-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = kFont(13);
        _label.text = @"投稿至";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = kCommonBlackColor;
        [self addSubview:_label];
    }
    return _label;
}

-(UIButton *)topicButton{
    if (!_topicButton) {
        _topicButton = [[UIButton alloc] init];
        _topicButton.layerCornerRadius = 5;
        _topicButton.layerBorderWidth = 1;
        _topicButton.layerBorderColor = kCommonHighLightRedColor;
        [_topicButton setTitle:@"聊电影" forState:UIControlStateNormal];
        [_topicButton setTitleColor:kCommonHighLightRedColor forState:UIControlStateNormal];
        _topicButton.titleLabel.font = kFont(15);
//        NSLog(@"button font size is %f ",[UIFont buttonFontSize]);
//        NSLog(@"button font size is %f ",[UIFont labelFontSize]);
        [_topicButton addTarget:self action:@selector(topicClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_topicButton];
    }
    return _topicButton;
}

-(UIButton *)hintButton{
    if (!_hintButton) {
        _hintButton = [[UIButton alloc] init];
        [_hintButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _hintButton.userInteractionEnabled = NO;
        _hintButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_hintButton setImage:ImageNamed(@"instructions") forState:UIControlStateNormal];
        [_hintButton setTitle:@"点击更换吧" forState:UIControlStateNormal];
        _hintButton.titleLabel.font = kFont(14);
        _hintButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        [self addSubview:_hintButton];
    }
    return _hintButton;
}


-(void)topicClicked:(UIButton *)button{
    if (self.topicHandler) {
        self.topicHandler(button);
    }
}

@end
