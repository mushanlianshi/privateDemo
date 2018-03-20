//
//  LBNHPersonalHeaderCountView.m
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHPersonalHeaderCountView.h"

/**
 * 子button  重写他的方法  上面的title和下面的title
 */
@interface LBNHPersonalHeaderCountViewButton : UIButton
//关注
@property (nonatomic, copy) NSString *title;

//关注数
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation LBNHPersonalHeaderCountViewButton

-(void)layoutSubviews{
    self.topLabel.frame = CGRectMake(0, (self.height/2-20), self.width, 20);
    self.bottomLabel.frame = CGRectMake(0, self.topLabel.bottom, self.width, 20);
}

-(void)setTitle:(NSString *)title{
    self.bottomLabel.text = title;
}
-(void)setCount:(NSInteger)count{
    self.topLabel.text = [NSString stringWithFormat:@"%ld",count <= 0 ? 0 : count];
}

-(UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.textColor = kCommonBlackColor;
        _topLabel.font = kFont(13);
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_topLabel];
    }
    return _topLabel;
}

-(UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.textColor = kCommonBlackColor;
        _bottomLabel.font = kFont(13);
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bottomLabel];
    }
    return _bottomLabel;
}


@end


@interface LBNHPersonalHeaderCountView ()

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, copy) NSArray *countsArray;


/** 分割线 */
@property (nonatomic, strong) CALayer *topLayer;

/* 分割线 **/
@property (nonatomic, strong) CALayer *bottomLayer;

@end

@implementation LBNHPersonalHeaderCountView

-(instancetype)initWithTitles:(NSArray<NSString *> *)titles counts:(NSArray<NSNumber *> *)counts{
    self=[super init];
    if (self) {
        self.titles = titles;
        self.countsArray = counts;
        [self initUI];
    }
    return self;
}

-(void)setTitles:(NSArray<NSString *> *)titles counts:(NSArray<NSNumber *> *)counts{
    self.titles = titles;
    self.countsArray = counts;
    [self initUI];
}

-(void)initUI{
    if (!(_titles&&_countsArray&&(_titles.count == _countsArray.count))) {
        return;
    }
    for (int i=0; i<_titles.count; i++) {
        LBNHPersonalHeaderCountViewButton *button  = [[LBNHPersonalHeaderCountViewButton alloc] init];
        button.tag = i+100;
        button.title = _titles[i];
        button.count = [_countsArray[i] integerValue];
        [button addTarget:self action:@selector(buttonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    for (int i =0; i<_titles.count; i++) {
        LBNHPersonalHeaderCountViewButton *button = (LBNHPersonalHeaderCountViewButton *)[self viewWithTag:i+100];
        button.frame = CGRectMake(i*self.width/_titles.count, 0, self.width/_titles.count, self.height);
    }
}

-(void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
//    self.topLayer.frame = CGRectMake(0, 0, kScreenWidth, 1);
    self.bottomLayer.frame = CGRectMake(0, self.height-0.5, kScreenWidth, 0.5);
}

-(void)buttonItemClicked:(LBNHPersonalHeaderCountViewButton *)button{
    NSInteger index = button.tag - 100;
    NSLog(@"点击的是 %ld ",index);
    if (self.clickedHandler) {
        self.clickedHandler(self,index);
    }
}

-(CALayer *)topLayer{
    if (!_topLayer) {
        _topLayer = [[CALayer alloc] init];
        _topLayer.backgroundColor = kSeparatorColor.CGColor;
        [self.layer addSublayer:_topLayer];
    }
    return _topLayer;
}

-(CALayer *)bottomLayer{
    if (!_topLayer) {
        _bottomLayer = [[CALayer alloc] init];
        _bottomLayer.backgroundColor = kSeparatorColor.CGColor;
        [self.layer addSublayer:_bottomLayer];
    }
    return _bottomLayer;
}

@end
