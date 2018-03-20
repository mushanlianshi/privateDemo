//
//  LBPublishPleaceHolderTextView.m
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBPublishPleaceHolderTextView.h"
#import "NSString+Size.h"

@interface LBPublishPleaceHolderTextView()

@property (nonatomic, strong) UILabel *pleaceLabel;

@end

@implementation LBPublishPleaceHolderTextView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

/** 设置一些默认的设置 */
-(void)config{
    self.pleaceHolderLeftMargin = 5;
    self.pleaceHolderTopMargin = 8;
    self.pleaceHolderFont = kFont(14);
    //添加监控textView变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)textChanged:(NSNotification *)notification{
    NSLog(@"textView texst is %@ ",self.text);
    self.pleaceLabel.hidden = self.text.length;
    if ([self.delegate respondsToSelector:@selector(pleaceHolderTextChanged:)]) {
        [self.delegate pleaceHolderTextChanged:self];
    }
}


-(void)setPleaceHolder:(NSString *)pleaceHolder{
    _pleaceHolder = pleaceHolder;
    self.pleaceLabel.text = pleaceHolder;
    //不会立即更新 异步延迟更新
    [self setNeedsLayout];
}

-(void)setPleaceHolderFont:(UIFont *)pleaceHolderFont{
    _pleaceHolderFont = pleaceHolderFont;
    self.pleaceLabel.font = pleaceHolderFont;
    [self setNeedsLayout];
}

-(void)setPleaceHolderColor:(UIColor *)pleaceHolderColor{
    _pleaceHolderColor = pleaceHolderColor;
    [self setNeedsLayout];
}

-(void)setPleaceHolderLeftMargin:(CGFloat)pleaceHolderLeftMargin{
    _pleaceHolderLeftMargin = pleaceHolderLeftMargin;
    [self setNeedsLayout];
}

-(void)setPleaceHolderTopMargin:(CGFloat)pleaceHolderTopMargin{
    _pleaceHolderTopMargin = pleaceHolderTopMargin;
    [self setNeedsLayout];
}

-(UILabel *)pleaceLabel{
    if (!_pleaceLabel) {
        _pleaceLabel = [[UILabel alloc] init];
        _pleaceLabel.textColor = [UIColor lightGrayColor];
        _pleaceLabel.numberOfLines = 0;
        [self addSubview:_pleaceLabel];
    }
    return _pleaceLabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat maxWidth = self.width - _pleaceHolderLeftMargin*2;
    UIFont *font = _pleaceHolderFont ? _pleaceHolderFont : self.pleaceLabel.font;
    CGFloat size = [font pointSize];
    CGFloat height = [self.pleaceHolder heightWithLimitWidth:maxWidth fontSize:size];
    self.pleaceLabel.frame = CGRectMake(_pleaceHolderLeftMargin, _pleaceHolderTopMargin, maxWidth, height);
    NSLog(@"self.pleace frmae is %@ ",NSStringFromCGRect(self.pleaceLabel.frame));
}

-(void)dealloc{
    NSLog(@"LBPublishPleaceHolderTextView === dealloc   ");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
