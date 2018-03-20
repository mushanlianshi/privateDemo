//
//  LBNaviBarView.m
//  LBSamples
//
//  Created by liubin on 17/2/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNaviBarView.h"
#define kTitleFontSize 16
#define kStatusHeight 20
@interface LBNaviBarView()
{
    NSString *_leftImage;
    NSString *_rightImage;
    NSString *_title;
}
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) LBScaleImageButton *rightButton;
@property (nonatomic, strong) LBScaleImageButton *leftButton;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, strong) UIColor *backColor;
@end
@implementation LBNaviBarView

-(instancetype)initWithLeftImage:(NSString *)leftImage title:(NSString *)title  leftBlock:(dispatch_block_t)leftBlock backGroundColor:(UIColor *)backColor{
    return [self initWithLeftImage:leftImage title:title rightImage:nil leftBlock:leftBlock rightBlock:nil backgroundColor:backColor];
}

-(instancetype)initWithLeftImage:(NSString *)leftImage title:(NSString *)title rightImage:(NSString *)rightImage leftBlock:(dispatch_block_t)leftBlock rightBlock:(void (^)())rightBlock{
    return [self initWithLeftImage:leftImage title:title rightImage:rightImage leftBlock:leftBlock rightBlock:rightBlock backgroundColor:nil];
}

-(instancetype)initWithLeftImage:(NSString *)leftImage title:(NSString *)title rightImage:(NSString *)rightImage leftBlock:(dispatch_block_t)leftBlock rightBlock:(void (^)())rightBlock backgroundColor:(UIColor *)backgroundColor{
    self=[super init];
    if (self) {
        _title=title;
        _leftImage=leftImage;
        _rightImage=rightImage;
        _rightBlock=rightBlock;
        _leftBlock=leftBlock;
        _backColor=backgroundColor;
        [self initUI];
    }
    return self;
}
-(void)initUI{
    
    UIView *statusView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    statusView.backgroundColor=[UIColor clearColor];
    [self addSubview:statusView];
    self.backgroundColor=_backColor;
    if (_title) {
        self.label.text=_title;
    }
    if (_rightImage) {
        [self.rightButton setImage:[UIImage imageNamed:_rightImage] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",_rightImage,@"_s"]] forState:UIControlStateHighlighted];
    }
    if (_leftImage) {
//        [self.leftButton setImage:[UIImage imageNamed:_leftImage] forState:UIControlStateNormal];
//        [self.leftButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",_leftImage,@"_s"]] forState:UIControlStateHighlighted];
        [self.leftButton setBackgroundImage:[UIImage imageNamed:_leftImage] forState:UIControlStateNormal];
        [self.leftButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",_leftImage,@"_s"]] forState:UIControlStateHighlighted];
    }
}


/**
 从新布局子控件
 */
-(void)layoutSubviews{
    self.frame = CGRectMake(0, 0, kScreenWidth, kNavibarHeight);
    CGSize size=self.bounds.size;
    if (_label) {
        _label.frame=CGRectMake(0, kStatusHeight, size.width, size.height-kStatusHeight);
    }
    if (_leftButton) {
        _leftButton.frame=CGRectMake(0, kStatusHeight, size.height-kStatusHeight, size.height-kStatusHeight);
    }
    if (_rightButton) {
        _rightButton.frame=CGRectMake(size.width-size.height+kStatusHeight, kStatusHeight, size.height-kStatusHeight, size.height-kStatusHeight);
    }
}
-(UILabel *)label{
    if (!_label) {
        _label=[[UILabel alloc] init];
        _label.textAlignment=NSTextAlignmentCenter;
        _label.textColor=[UIColor blackColor];
        _label.font=[UIFont systemFontOfSize:kTitleFontSize];
        [self addSubview:_label];
    }
    return _label;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[[LBScaleImageButton alloc] init];
        [_rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
    }
    return _rightButton;
}
-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton=[[LBScaleImageButton alloc] init];
        [_leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
    }
    return _leftButton;
}
-(void)rightButtonClicked{
    if (_rightBlock) {
        _rightBlock();
    }
}
-(void)leftButtonClicked{
    if (_leftBlock) {
        _leftBlock();
    }
}
@end

@implementation LBScaleImageButton


/**
 重写button的image的位置

 @param
 @return image现在的位置
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGSize size=self.frame.size;
    float scale=0.55;
    CGRect rect= CGRectMake(size.width*(1-scale)/2, size.height*(1-scale)/2, scale*size.width, scale*size.height);
//    NSLog(@"contentRect is %@ ---- %@ ",NSStringFromCGRect(contentRect),NSStringFromCGRect(rect));
    return rect;
}

@end
