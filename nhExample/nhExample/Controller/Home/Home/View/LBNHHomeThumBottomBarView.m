//
//  LBNHHomeThumBottomBarView.m
//  nhExample
//
//  Created by liubin on 17/3/17.
//  Copyright © 2017年 liubin. All rights reserved.
//

#define  KLittleFont [UIFont systemFontOfSize:13]
#define  KDefaultColor [UIColor lightGrayColor]

#define margin 10

#define kIconWidth 20

#define kLabelWidth 50

#import "LBNHHomeThumBottomBarView.h"

@interface LBNHHomeThumBottomBarView ()

@property (nonatomic, strong) UIButton *thumButton;

@property (nonatomic, strong) UILabel *thumLabel;

@property (nonatomic, strong) UIButton *stepButton;

@property (nonatomic, strong) UILabel *stepLabel;

@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UILabel *shareLabel;

@end

@implementation LBNHHomeThumBottomBarView

-(instancetype)initWithThums:(NSString *)thums steps:(NSString *)steps comments:(NSString *)comments share:(NSString *)shares{
    self=[super init];
    if (self) {
        self.thumLabel.text = thums;
        self.stepLabel.text = steps;
        self.commentLabel.text = comments;
        self.shareLabel.text = shares;
        [self setConstraints];
        
    }
    return self;
}

-(void)setThums:(NSString *)thums steps:(NSString *)steps comments:(NSString *)comments share:(NSString *)shares{
    self.thumLabel.text = thums;
    self.stepLabel.text = steps;
    self.commentLabel.text = comments;
    self.shareLabel.text = shares;
    [self setConstraints];
}

-(void)setThums:(NSInteger)thums steps:(NSInteger)steps comments:(NSInteger)comments{
    self.thumLabel.text = [self dealCountWithForrmater:thums];
    self.stepLabel.text = [self dealCountWithForrmater:steps];
    self.commentLabel.text = [self dealCountWithForrmater:comments];
    [self setConstraints];
}


/**
 * 处理数子显示的格式
 */
-(NSString *)dealCountWithForrmater:(NSInteger)count{
    if (count>10000) {
        CGFloat number=count/10000.0f;
        NSString *title=[NSString stringWithFormat:@"%.1f万",number];
        title=[title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        return title;
    }
    return [NSString stringWithFormat:@"%ld",count];
}

-(void)setConstraints{
    [self.thumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(margin);
        make.top.offset(margin);
        make.width.height.mas_equalTo(kIconWidth);
    }];
    
    [self.thumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumButton.mas_right).offset(margin);
//        make.top.bottom.equalTo(self.thumButton);
        make.centerY.equalTo(self.thumButton);
        make.width.mas_equalTo(kLabelWidth);
    }];
    
    [self.stepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumLabel.mas_right).offset(margin);
        make.top.equalTo(self.thumButton);
        make.width.height.mas_equalTo(kIconWidth);
    }];
    
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stepButton.mas_right).offset(margin);
        make.centerY.equalTo(self.stepButton);
        make.width.mas_equalTo(kLabelWidth);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stepLabel.mas_right).offset(margin);
        make.top.equalTo(self.thumButton);
        make.height.width.mas_equalTo(kIconWidth);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentButton.mas_right).offset(margin);
        make.centerY.equalTo(self.commentButton);
        make.width.mas_equalTo(kLabelWidth);
    }];
    
    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-margin);
        make.centerY.equalTo(self.commentLabel);
        make.width.mas_equalTo(kLabelWidth);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentLabel.mas_left).offset(-margin);
        make.top.equalTo(self.thumButton);
        make.width.height.mas_equalTo(kIconWidth);
    }];
}


-(UIButton *)thumButton{
    if (!_thumButton) {
        _thumButton = [[UIButton alloc] init];
        [_thumButton addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
        _thumButton.tag = LBNHThumBottomClickedTypeThum;
        [_thumButton setImage:ImageNamed(@"digupicon_comment") forState:UIControlStateNormal];
        [_thumButton setImage:ImageNamed(@"digupicon_comment_press") forState:UIControlStateSelected];
        [self addSubview:_thumButton];
    }
    return _thumButton;
}

-(UIButton *)stepButton{
    if (!_stepButton) {
        _stepButton = [[UIButton alloc] init];
        [_stepButton addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
        _stepButton.tag = LBNHThumBottomClickedTypeStep;
        [_stepButton setImage:ImageNamed(@"digdownicon_textpage") forState:UIControlStateNormal];
        [_stepButton setImage:ImageNamed(@"digdownicon_textpage_press") forState:UIControlStateSelected];
        [self addSubview:_stepButton];
    }
    return _stepButton;
}


-(UIButton *)commentButton{
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] init];
        [_commentButton addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
        _commentButton.tag = LBNHThumBottomClickedTypeComment;
        [_commentButton setImage:ImageNamed(@"commenticon_textpage") forState:UIControlStateNormal];
        [self addSubview:_commentButton];
    }
    return _commentButton;
}

-(UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        [_shareButton addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.tag = LBNHThumBottomClickedTypeShare;
        [_shareButton setImage:ImageNamed(@"moreicon_textpage") forState:UIControlStateNormal];
        [self addSubview:_shareButton];
    }
    return _shareButton;
}

-(UILabel *)thumLabel{
    if (!_thumLabel) {
        _thumLabel = [[UILabel alloc] init];
        _thumLabel.font = KLittleFont;
        _thumLabel.textColor = KDefaultColor;
        [self addSubview:_thumLabel];
    }
    return _thumLabel;
}

-(UILabel *)stepLabel{
    if (!_stepLabel) {
        _stepLabel = [[UILabel alloc] init];
        _stepLabel.font = KLittleFont;
        _stepLabel.textColor = KDefaultColor;
        [self addSubview:_stepLabel];
    }
    return _stepLabel;
}

-(UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = KLittleFont;
        _commentLabel.textColor = KDefaultColor;
        [self addSubview:_commentLabel];
    }
    return _commentLabel;
}

-(UILabel *)shareLabel{
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.font = KLittleFont;
        _shareLabel.textColor = KDefaultColor;
        [self addSubview:_shareLabel];
    }
    return _shareLabel;
}


-(void)bottomClicked:(UIButton *)button{
    NSInteger count = button.currentTitle.integerValue;
    if (self.bottomHandler) {
        self.bottomHandler(button.tag, count, button);
    }
}

@end
