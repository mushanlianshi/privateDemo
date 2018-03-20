//
//  LBPriceSliderView.m
//  testPush
//
//  Created by baletu on 2018/1/17.
//  Copyright © 2018年 baletu. All rights reserved.
//

#import "LBPriceSliderView.h"

/** slider 上面的滑点的大小 */
static CGFloat const kThumWidth = 30;

/** 上下浮动的范围 1是一百为单位 */
static CGFloat const kLimitRange = 1;
/**
 * 注意左右slider的划过的颜色是反的 以及位置让一个thumb的大小
 */
@interface LBPriceSliderView ()

@property (nonatomic, strong) UISlider * leftSlider;

@property (nonatomic, strong) UISlider * rightSlider;

/** 价格范围 */
@property (nonatomic, assign) NSUInteger priceRange;

@property (nonatomic, assign) NSUInteger leftValue;

@property (nonatomic, assign) NSUInteger rightValue;

@end


@implementation LBPriceSliderView

- (instancetype)initWithFrame:(CGRect)frame priceRange:(NSUInteger)priceRange{
    self = [super initWithFrame:frame];
    if (self) {
        _priceRange = priceRange;
        [self initUI];
    }
    return self;
}

/** 右边的view在上面  因为右边的minColor设置透明的 */
- (void)initUI{
    self.leftSlider.value = self.leftValue =  0;
    self.rightSlider.value = self.rightValue =  100;
}


- (void)setThumbTintColor:(UIColor *)thumbTintColor{
    if (_thumbTintColor == thumbTintColor) return;
    _thumbTintColor = thumbTintColor;
    self.leftSlider.thumbTintColor = thumbTintColor;
    self.rightSlider.thumbTintColor = thumbTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor{
    if (_minimumTrackTintColor == minimumTrackTintColor) return;
    _minimumTrackTintColor = minimumTrackTintColor;
    self.leftSlider.minimumTrackTintColor = minimumTrackTintColor;
    self.rightSlider.maximumTrackTintColor = minimumTrackTintColor;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor{
    if (_maximumTrackTintColor == maximumTrackTintColor) return;
    _maximumTrackTintColor = maximumTrackTintColor;
    self.leftSlider.maximumTrackTintColor = maximumTrackTintColor;
//    self.rightSlider.minimumTrackTintColor = maximumTrackTintColor;
}

- (void)valueChanged:(UISlider *)slider{

    if (slider == _leftSlider) {
        self.leftValue = slider.value;
        if (self.leftValue >= self.rightValue - kLimitRange) {
            self.leftValue = self.rightValue - kLimitRange;
            self.leftSlider.value = self.leftValue;
        }
    }else{
        self.rightValue = slider.value;
        if (self.rightValue <= self.leftValue + kLimitRange) {
            self.rightValue = self.leftValue + kLimitRange;
            self.rightSlider.value = self.rightValue;
        }
    }

    if (self.sliderBlock) {
        
        /** 对1百求余 保证是一百的倍数 */
        NSUInteger leftPrice = (NSUInteger)self.leftValue * _priceRange / 100;
        NSUInteger rightPrice = (NSUInteger)self.rightValue * _priceRange / 100;
        
        self.sliderBlock(leftPrice % 100 ? leftPrice + 50 : leftPrice, rightPrice % 100 ? rightPrice - 50 : rightPrice);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (UISlider *)leftSlider{
    if (!_leftSlider) {
        _leftSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - kThumWidth, self.bounds.size.height)];
        _leftSlider.maximumValue = 100;
        _leftSlider.minimumTrackTintColor = [UIColor lightGrayColor];
        _leftSlider.maximumTrackTintColor = [UIColor redColor];
        _leftSlider.thumbTintColor = [UIColor lightGrayColor];
        [_leftSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_leftSlider];
    }
    return _leftSlider;
}

- (UISlider *)rightSlider{
    if (!_rightSlider) {
        _rightSlider = [[UISlider alloc] initWithFrame:CGRectMake(kThumWidth , 0, self.bounds.size.width - kThumWidth, self.bounds.size.height)];
        _rightSlider.maximumValue = 100;
        _rightSlider.minimumTrackTintColor = [UIColor clearColor];
        _rightSlider.maximumTrackTintColor = [UIColor lightGrayColor];
        _rightSlider.thumbTintColor = [UIColor lightGrayColor];
        [_rightSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_rightSlider];
    }
    return _rightSlider;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:self.leftSlider];
//}

/** 重写事件的分发  slider里面包含多view  所以不能直接返回 利用别的不响应交互  来让系统分发 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    self.leftSlider.userInteractionEnabled = NO;
    self.rightSlider.userInteractionEnabled = NO;
    
    __block UIImageView *leftIv = nil;
    [self.leftSlider.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.bounds.size.width == obj.bounds.size.height && obj.bounds.size.width > 10) {
            leftIv = obj;
        }
    }];
    
    __block UIImageView *rightIV = nil;
    [self.rightSlider.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.bounds.size.width == obj.bounds.size.height && obj.bounds.size.width > 10) {
            rightIV = obj;
        }
    }];
    
    /** 转换到同一个view中进行判断点是否在点击的frame内 */
    CGRect leftFrame = [self convertRect:leftIv.frame fromView:leftIv.superview];
    if (CGRectContainsPoint(leftFrame, point)) {
        self.rightSlider.userInteractionEnabled = NO;
        self.leftSlider.userInteractionEnabled = YES;
    }
    
    CGRect rightFrame = [self convertRect:rightIV.frame fromView:rightIV.superview];
    if (CGRectContainsPoint(rightFrame, point)) {
        self.leftSlider.userInteractionEnabled = NO;
        self.rightSlider.userInteractionEnabled = YES;
    }
    
//    NSLog(@"LBLog left frame is %@ %@ %@ ",NSStringFromCGRect(leftFrame),NSStringFromCGRect(rightFrame),NSStringFromCGPoint(point));
    
    
    return [super hitTest:point withEvent:event];
}


@end
