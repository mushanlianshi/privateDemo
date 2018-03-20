//
//  LBStarView.m
//  Baletu
//
//  Created by baletu on 2017/7/20.
//  Copyright © 2017年 朱 亮亮. All rights reserved.
//

#import "LBStarView.h"

/** 最多五个星 */
static NSInteger const kMaxStarNum = 5;

static NSString * const kNormalImage = @"3.8.8xingxing";

static NSString * const kSelectImage = @"3.8.8xingxing-up";

static NSString * const kHalfImage = @"ditudaohangqidian";

@interface LBStarView ()

@property (nonatomic,assign) CGFloat starNum;

@property (nonatomic,assign) CGFloat ivWidth;

@property (nonatomic,assign) CGFloat ivHeight;

@property (nonatomic,assign) CGFloat margin;

@property (nonatomic,strong) UIImage *normalImage;

@end

@implementation LBStarView


-(instancetype)initWithFrame:(CGRect)frame startNum:(CGFloat)startNum{
    self = [super initWithFrame:frame];
    if (self) {
        _normalImage = [UIImage imageNamed:kNormalImage];
        _starNum = startNum;
        _ivHeight = _normalImage.size.height;
        _ivWidth = _normalImage.size.width;
        _margin = (self.bounds.size.width - kMaxStarNum * _ivWidth)/(kMaxStarNum - 1);
    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    
    UIImage *normaImage = [UIImage imageNamed:kNormalImage];
    UIImage *selectImage = [UIImage imageNamed:kSelectImage];
    UIImage *halfImage = [UIImage imageNamed:kHalfImage];
    
    CGFloat totalHeight = self.bounds.size.height;

    for (int i = 0 ; i < kMaxStarNum; i++) {
        CGRect frame = CGRectMake((_ivWidth + _margin) * i, (totalHeight - _ivHeight)/2, _ivWidth, _ivHeight);
        CGContextDrawImage(context, frame, normaImage.CGImage);
    }
    
    for (int i = 0; i < floor(_starNum); i++) {
        if (i < kMaxStarNum) {
            CGRect frame = CGRectMake((_ivWidth + _margin) * i, (totalHeight - _ivHeight)/2, _ivWidth, _ivHeight);
            CGContextDrawImage(context, frame, selectImage.CGImage);
        }
    }
    NSLog(@"LBLog _starNum %f ",_starNum);
    //如果有半颗星
    if (_starNum > floor(_starNum)) {
        CGRect halfFrame = CGRectMake(floor(_starNum)*(_ivWidth + _margin) , (totalHeight - _ivHeight)/2, _ivWidth, _ivHeight);
        CGContextDrawImage(context, halfFrame, halfImage.CGImage);
    }
    
//    CGContextRestoreGState(context);
    
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
//    CGFloat num = point.x / (_ivWidth + _margin);
    [self dealTouchPointX:point.x];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
//    CGFloat num = point.x / (_ivWidth + _margin);
    [self dealTouchPointX:point.x];
}

-(void)dealTouchPointX:(CGFloat)pointX{
    //1.计算点击的在第几个星星处
    CGFloat num = pointX / (_ivWidth + _margin);
    
    //点击的位置 超过了半个星  按一个整星算
    if ( (num != floor(num)) &&(floor(num)*(_ivWidth +_margin) + _normalImage.size.width/2 <= pointX)) {
        num = floor(num) + 1;
    }
    //点击的位置  不超过半个星  按半个星算
    else if ( (num != floor(num) && (floor(num)*(_ivWidth +_margin) + _normalImage.size.width/2 >pointX))){
        num = floor(num) + 0.5;
    }
    _starNum = num;
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
