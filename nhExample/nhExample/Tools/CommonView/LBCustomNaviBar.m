//
//  LBCustomNaviBar.m
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomNaviBar.h"
#import "NSString+Size.h"

@interface LBCustomNaviBar()

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIButton *leftItemButton;

@property (nonatomic, strong) UIButton *rightItemButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) dispatch_block_t leftBlock;

@property (nonatomic, copy) dispatch_block_t rightBlock;

@end

@implementation LBCustomNaviBar
-(instancetype)initNaviBarLeftImage:(UIImage *)leftImage leftBlock:(dispatch_block_t)leftBlock title:(NSString *)title rightImage:(UIImage *)rightImage rightBlock:(dispatch_block_t)rightBlock{
    return [self initNaviBarTintColor:nil backgroundColor:nil leftImage:leftImage leftBlock:leftBlock title:title rightImage:rightImage rightBlock:rightBlock];
}
-(instancetype)initNaviBarTintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor leftImage:(UIImage *)leftImage leftBlock:(dispatch_block_t)leftBlock title:(NSString *)title rightImage:(UIImage *)rightImage rightBlock:(dispatch_block_t)rightBlock{
    self = [super init];
    if (self) {
        self.backgroundColor = backgroundColor ? backgroundColor : kCommonBgColor;
        self.tintColor = tintColor ? tintColor : kCommonTintColor;
        self.leftBlock = leftBlock;
        self.rightBlock = rightBlock;
        if (title && title.length) {
            self.titleLabel.frame = CGRectMake(0, 20, kScreenWidth, 44);
            self.titleLabel.text = title;
        }
        
        if (leftImage) {
            self.leftItemButton.frame = CGRectMake(10, 25, 35, 35);
            [self.leftItemButton setImage:leftImage forState:UIControlStateNormal];
            self.leftItemButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.leftItemButton.layerCornerRadius = 35/2;
        }
        
        if (rightImage) {
            self.rightItemButton.frame = CGRectMake(kScreenWidth - 35 -10, 25, 35, 35);
            [self.rightItemButton setImage:rightImage forState:UIControlStateNormal];
            self.rightItemButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.rightItemButton.layerCornerRadius = 35/2;
        }
        
        
    }
    return self;
}




-(instancetype)initNaviBarLeftString:(NSString *)LeftString leftBlock:(dispatch_block_t)leftBlock title:(NSString *)title rightString:(NSString *)rightString rightBlock:(dispatch_block_t)rightBlock{
    return [self initNaviBarTintColor:nil backgroundColor:nil LeftString:LeftString leftBlock:leftBlock title:title rightString:rightString rightBlock:rightBlock];
}
-(instancetype)initNaviBarTintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor LeftString:(NSString *)LeftString leftBlock:(dispatch_block_t)leftBlock title:(NSString *)title rightString:(NSString *)rightString rightBlock:(dispatch_block_t)rightBlock{
    self = [super init];
    if (self) {
        self.backgroundColor = backgroundColor ? backgroundColor : kCommonBgColor;
        self.tintColor = tintColor ? tintColor : kCommonTintColor;
        self.leftBlock = leftBlock;
        self.rightBlock = rightBlock;
        if (title && title.length) {
            self.titleLabel.frame = CGRectMake(0, 20, kScreenWidth, 44);
            self.titleLabel.text = title;
            self.titleLabel.textColor = self.tintColor ? self.tintColor : kCommonTintColor;
        }
        
        if (LeftString && LeftString.length) {
            CGFloat width = [LeftString widhtWithLimitHeight:35 fontSize:self.leftItemButton.titleLabel.font.pointSize];
            self.leftItemButton.frame = CGRectMake(10, 25, width, 35);
            [self.leftItemButton setTitle:LeftString forState:UIControlStateNormal];
            [self.leftItemButton setTitleColor:self.tintColor ? self.tintColor : kCommonTintColor forState:UIControlStateNormal];
        }
        
        if (rightString && rightString.length) {
            CGFloat width = [rightString widhtWithLimitHeight:35 fontSize:self.rightItemButton.titleLabel.font.pointSize];
            self.rightItemButton.frame = CGRectMake(kScreenWidth - width -10, 25, width, 35);
            [self.rightItemButton setTitle:rightString forState:UIControlStateNormal];
            [self.rightItemButton setTitleColor:self.tintColor ? self.tintColor : kCommonTintColor forState:UIControlStateNormal];
        }
    }
    return self;
}


#pragma mark 设置属性
-(void)setTitleFont:(UIFont *)titleFont{
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        self.titleLabel.font = titleFont;
    }
}



-(UIButton *)leftItemButton{
    if (!_leftItemButton) {
        _leftItemButton = [[UIButton alloc] init];
        [_leftItemButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftItemButton];
    }
    return _leftItemButton;
}


-(UIButton *)rightItemButton{
    if (!_rightItemButton) {
        _rightItemButton = [[UIButton alloc] init];
        [_rightItemButton addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightItemButton];
    }
    return _rightItemButton;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = self.tintColor ? self.tintColor : kCommonTintColor;
        [self addSubview:_titleLabel];
        
    }
    return _titleLabel;
}


-(void)layoutSubviews{
    self.frame = CGRectMake(0, 0, kScreenWidth, kNavibarHeight);
}


-(void)leftItemClicked:(UIButton *)button{
    MyLog(@"LBLog custon leftBarItemClicked ============");
    if (self.leftBlock) {
        self.leftBlock();
    }
}

-(void)rightItemClicked:(UIButton *)button{
    MyLog(@"LBLog custon rightBarItemClicked ============");
    if (self.rightBlock) {
        self.rightBlock();
    }
}

@end
