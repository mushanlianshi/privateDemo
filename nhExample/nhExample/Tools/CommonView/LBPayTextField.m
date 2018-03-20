//
//  LBPayTextField.m
//  nhExample
//
//  Created by liubin on 17/4/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBPayTextField.h"

static NSInteger kStartLineTag = 100;

static NSInteger kStartCircleTag = 200;

static NSInteger kMaxCount = 6;

@interface LBPayTextField()



@end


@implementation LBPayTextField

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLineUI];
    }
    return self;
}

-(void)initLineUI{
    //设置背景色白色
    self.backgroundColor = [UIColor whiteColor];
    //设置文字颜色透明  和光标颜色透明 不然会显示出来
    self.textColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    self.layerBorderWidth = 1;
    self.layerBorderColor = [UIColor lightGrayColor];
    for (int i =0; i<6; i++) {
        if (i!=5) {
            CATagLayer *layer = [[CATagLayer alloc] init];
            layer.tag = kStartLineTag + i;
            layer.backgroundColor = [UIColor lightGrayColor].CGColor;
            [self.layer addSublayer:layer];
        }
        UIView *circleView = [[UIView alloc] init];
        circleView.backgroundColor = [UIColor blackColor];
        circleView.tag = kStartCircleTag + i;
        circleView.hidden = YES;
        [self addSubview:circleView];
    }
    self.keyboardType = UIKeyboardTypePhonePad;
    [self addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void)layoutSubviews{
    CGFloat width = self.bounds.size.width/kMaxCount;
    CGFloat height = self.bounds.size.height;
    CGFloat circleH = height/6;
    if (self.layer.sublayers.count>4) {
        for (int i=0; i<self.layer.sublayers.count; i++) {
            if ([self.layer.sublayers[i] isKindOfClass:[CATagLayer class]]) {
                CATagLayer *layer = (CATagLayer *)self.layer.sublayers[i];
                NSInteger index =layer.tag - kStartLineTag;
                layer.frame = CGRectMake(width*(index + 1), 0, 1, height);
            }
        }
    }
    
    for (int i =0 ; i< 6 ;i++) {
        UIView *circleView = [self viewWithTag:i+kStartCircleTag];
        circleView.bounds = CGRectMake(0, 0, circleH, circleH);
        circleView.center = CGPointMake((i+1)*width - width/2, height/2);
        circleView.layer.cornerRadius = circleH/2;
        
    }
}

-(void)textChanged:(UITextField *)textField{
    NSInteger length = textField.text.length;
    [self showCircleLength:length];
    if (length == kMaxCount) {
        [self resignFirstResponder];
        if (self.inputMaxHandler) {
            self.inputMaxHandler(self);
        }
    }
    if (length>kMaxCount) {
        self.text = [self.text substringToIndex:kMaxCount];
    }
}

/** 隐藏所有的圆圈 */
-(void)hiddenAllCircle{
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
}

/** 根据长度显示圆圈 */
-(void)showCircleLength:(NSUInteger )lenght{
    [self hiddenAllCircle];
    for (int i =0; i<lenght; i++) {
        UIView *view = [self viewWithTag:i+kStartCircleTag];
        view.hidden = NO;
    }
}

-(void)dealloc{
    NSLog(@"self pay textfield dealloc ===========");
}

@end


@implementation CATagLayer



@end
