//
//  LBRaceLampView.m
//  testPush
//
//  Created by baletu on 2017/7/25.
//  Copyright © 2017年 baletu. All rights reserved.
//

#import "LBRaceLampView.h"
/** 每秒显示多长的  */
static CGFloat const kShowWidthPerS = 30;

/** 左右显示的margin */
static CGFloat const kSideMargin = 5;


@interface LBRaceLampView() <CAAnimationDelegate>

@property (nonatomic,strong) UILabel *titleLabel;

@end


@implementation LBRaceLampView
@synthesize titleFont = _titleFont;
@synthesize titleColor = _titleColor;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.titleLabel.frame = CGRectMake(kSideMargin, 0, frame.size.width - 2 * kSideMargin, frame.size.height);
        self.titleLabel.text = title;
        [self.titleLabel sizeToFit];
        
        [self animationShow];
    }
    return self;
}

-(void)animationShow{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = @(kSideMargin);
    animation.toValue = @(-_titleLabel.frame.size.width);
    animation.duration = _titleLabel.frame.size.width / kShowWidthPerS;
    animation.delegate = self;
    [_titleLabel.layer addAnimation:animation forKey:nil];
}



#pragma mark animation delegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_titleLabel.layer removeAllAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationShow];
    });
}


-(void)setTitleColor:(UIColor *)titleColor{
    if (_titleColor == titleColor) return;
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

-(UIColor *)titleColor{
    return self.titleLabel.textColor;
}

-(void)setTitleFont:(UIFont *)titleFont{
    if (_titleFont == titleFont) return;
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

-(UIFont *)titleFont{
    return  self.titleLabel.font;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


@end
