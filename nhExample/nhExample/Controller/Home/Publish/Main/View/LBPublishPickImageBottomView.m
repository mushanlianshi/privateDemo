//
//  LBPublishPickImageBottomView.m
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBPublishPickImageBottomView.h"
#import "LBButtonUtils.h"
#import "LBImageTitleButton.h"

@interface LBPublishPickImageBottomView()

/** 图片 */
@property (nonatomic, strong) LBImageTitleButton *pictureButton;

/** 匿名 */
@property (nonatomic, strong) UIButton *checkButton;

@end

@implementation LBPublishPickImageBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = kFont(14);
        _tipLabel.textColor = kCommonBlackColor;
        _tipLabel.text = @"还可以输入300字";
        _tipLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

-(void)setHintNumber:(NSInteger)hintNumber{
    _hintNumber = hintNumber;
    self.tipLabel.text = [NSString stringWithFormat:@"还可以输入%ld字",hintNumber];
}

-(LBImageTitleButton *)pictureButton{
    if (!_pictureButton) {
        _pictureButton = [[LBImageTitleButton alloc] init];
        [_pictureButton setImage:ImageNamed(@"publish_picture") forState:UIControlStateNormal];
        _pictureButton.titleLabel.font = kFont(14);
        [_pictureButton addTarget:self action:@selector(pictureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_pictureButton setTitle:@"图片" forState:UIControlStateNormal];
        [_pictureButton setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
        [_pictureButton setImage:ImageNamed(@"publish_picture_press") forState:UIControlStateHighlighted];
        [self addSubview:_pictureButton];
    }
    return _pictureButton;
}

-(UIButton *)checkButton{
    if (!_checkButton) {
        _checkButton = [LBButtonUtils creatButtonImage:@"anonymous" title:@"匿名" addTarget:self selector:@selector(checkButtonClicked:) FontSize:14];
        [_checkButton setImage:ImageNamed(@"anonymous_press") forState:UIControlStateSelected];
        _checkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_checkButton setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
        [_checkButton setTitleColor:kCommonHighLightRedColor forState:UIControlStateSelected];
        _checkButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
        [self addSubview:_checkButton];
    }
    return _checkButton;
    
}

-(void)layoutSubviews{
    self.tipLabel.frame = CGRectMake(0, 0, self.width-5, 15);
    self.pictureButton.frame = CGRectMake(0, 15, self.height-15, self.height-15);
    self.checkButton.frame = CGRectMake(self.width-60-5, (self.height-15 - 30)/2 +15, 60, 30);
}

-(void)checkButtonClicked:(UIButton *)button{
    button.selected = !button.isSelected;
    if ([self.delegate respondsToSelector:@selector(publishPickImage:isWithOutName:)]) {
        [self.delegate publishPickImage:self isWithOutName:button.isSelected];
    }
}

-(void)pictureButtonClicked:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(publishPickImageSelected:)]) {
        [self.delegate publishPickImageSelected:self];
    }
}


@end
