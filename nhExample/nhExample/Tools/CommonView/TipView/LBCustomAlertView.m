//
//  LBCustomAlertView.m
//  nhExample
//
//  Created by liubin on 17/4/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#define alertBackGroundColor  [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.00]
#import "LBCustomAlertView.h"
#import "LBUtils.h"
#import "NSAttributedString+LBSize.h"




@interface LBCustomAlertView ()



@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *contentStr;

@property (nonatomic, copy) NSString *cancelStr;

@property (nonatomic, copy) NSString *sureStr;

@property (nonatomic, strong) CALayer *lineLayer;

@property (nonatomic, copy) dispatch_block_t cancelBlock;


@property (nonatomic, copy) dispatch_block_t sureBlock;


@end

@implementation LBCustomAlertView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel sure:(NSString *)sure{
    self = [super init];
    if (self) {
        _titleStr = title;
        _cancelStr = cancel;
        _sureStr = sure;
        _contentStr = content;
        [self setupViews];
    }
    return self;
}

//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setupViews];
//    }
//    return self;
//}

-(void)setupViews{
    _titleStr = _titleStr ? _titleStr : @"提示";
//    _cancelStr = _cancelStr ? _cancelStr : @"取消";
    _sureStr = _sureStr ? _sureStr : @"确定";
    self.titleLabel.text = _titleStr;
//    self.contentLabel.text = _contentStr;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_contentStr];
    NSRange range = NSMakeRange(0, _contentStr.length);
    [attributeString addAttribute:NSForegroundColorAttributeName value:kCommonBlackColor range:range];
    [attributeString addAttribute:NSFontAttributeName value:kFont(kScreenWidth > 320 ? 15 :14) range:range];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //行间距
    style.lineSpacing = 5;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:range];
    self.contentLabel.attributedText = attributeString;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    
    if (_cancelStr.length) {
        [self.cancelButton setTitle:_cancelStr forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = self.contentLabel.font;
    }
    
    self.sureButton.titleLabel.font = self.contentLabel.font;
    [self.sureButton setTitle:_sureStr forState:UIControlStateNormal];
    
    [self insertSubview:self.backgroundView belowSubview:self.contentView];
    
}

-(UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = alertBackGroundColor;
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(kScreenWidth > 320 ? 16 :15);
        _titleLabel.textColor = [kCommonBlackColor colorWithAlphaComponent:0.8];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kFont(kScreenWidth > 320 ? 15 :14);
        _contentLabel.textColor = [kCommonBlackColor colorWithAlphaComponent:0.8];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setBackgroundImage:[LBUtils imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[LBUtils imageWithColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
        [_cancelButton setTitleColor:[kCommonBlackColor colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [self.contentView addSubview:_cancelButton];
    }
    return _cancelButton;
}

-(UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setBackgroundImage:[LBUtils imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[LBUtils imageWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
        [_sureButton setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [self.contentView addSubview:_sureButton];
    }
    return _sureButton;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [kCommonTintColor colorWithAlphaComponent:0.8];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

-(CALayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [[CALayer alloc] init];
        _lineLayer.backgroundColor = [kCommonTintColor colorWithAlphaComponent:0.8].CGColor;
        [self.contentView.layer addSublayer:_lineLayer];
    }
    return _lineLayer;
}

- (void)dismiss{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)showInSuperView:(UIView *)superView{
    UIView *view = superView ? superView : [UIApplication sharedApplication].keyWindow;
    self.frame = view.bounds;
    [view addSubview:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = [UIScreen mainScreen].bounds;
    //竖直方向的Y布局 逐渐累加
    CGFloat verticalY = 0;
    CGFloat width = kScreenWidth * 0.7 ;
    
    self.titleLabel.frame = CGRectMake(0, verticalY, width, 40);
    
    
    
    CGFloat maxWidth = width - 60;
    CGFloat contentX = 30;
    verticalY = CGRectGetMaxY(self.titleLabel.frame);
    CGFloat contentW = maxWidth;
    CGFloat contentH = [self.contentLabel.attributedText heightWithLimitWidth:contentW];
    self.contentLabel.frame = CGRectMake(contentX, verticalY, contentW, contentH);
    
    
    self.lineLayer.frame = CGRectMake(0.f, CGRectGetMaxY(self.contentLabel.frame) + 10, width, 0.5);
    
    
    CGFloat canX = 0;
    verticalY += 10+contentH;
    CGFloat canW = width/2;
    CGFloat canH = 40;
    self.cancelButton.frame = CGRectMake(canX, verticalY, canW, canH);
    
    CGFloat sureX = canW;
    verticalY += 0;
    CGFloat sureW = canW;
    CGFloat sureH = 40;
    self.sureButton.frame = CGRectMake(sureX, verticalY, sureW, sureH);
    
    
    CGFloat lineX = canW;
    verticalY += 5;
    CGFloat lineW = 0.5f;
    CGFloat lineH = 30;
    self.lineView.frame = CGRectMake(lineX, verticalY, lineW, lineH);
    
    //没有取消按钮的时候
    if (!_cancelStr || _cancelStr.length == 0) {
        self.cancelButton.hidden = YES;
        self.lineView.hidden = YES;
        self.sureButton.frame = CGRectMake(0, verticalY - 5, width, sureH);
    }
    
    self.contentView.bounds = CGRectMake(0, 0, width, CGRectGetMaxY(self.sureButton.frame));
    self.contentView.center = self.center;
}


-(void)setCancelBlock:(dispatch_block_t)cancelBlock{
    _cancelBlock = cancelBlock;
}

-(void)setSureBlock:(dispatch_block_t)sureBlock{
    _sureBlock = sureBlock;
}

#pragma mark 按钮事件

-(void)cancelButtonClicked:(UIButton *)button{
    [self dismiss];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

-(void)sureButtonClicked:(UIButton *)button{
    [self dismiss];
    if (self.sureBlock) {
        self.sureBlock();
    }
}

-(void)dealloc{
    NSLog(@" %@ dealloc ========",NSStringFromClass([self class]));
}

@end
