//
//  LBNHCheckReportView.m
//  nhExample
//
//  Created by liubin on 17/3/23.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHCheckReportView.h"
#import "UIView+LBTap.h"

NSInteger const kReportCol = 2;

@interface LBNHCheckReportView()

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) CALayer *lineLayer;


/** 容器 */
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) NSArray *contentsArray;

@end

@implementation LBNHCheckReportView

-(instancetype)initWithContents:(NSArray *)contents{
    self=[super init];
    if (self) {
        self.contentsArray = contents;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    if (!_contentsArray || _contentsArray.count == 0) return;
    WS(weakSelf);
    [self addTapBlock:^{
        [weakSelf dismiss];
    }];
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    self.alpha = 0;
    
    for (int i =0; i<_contentsArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:ImageNamed(@"selectround_detail_report") forState:UIControlStateNormal];
        [button setImage:ImageNamed(@"selectround_detail_report_press") forState:UIControlStateSelected];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.titleLabel.font = kFont(14);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [button setTitle:_contentsArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 +i;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:button];
    }
}


-(void)itemClicked:(UIButton *)button{
    button.selected = !button.isSelected;
    NSInteger index = button.tag - 100;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.itemHandler) {
            self.itemHandler(self, button, index);
        }
    });
    
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0.48f green:0.82f blue:0.90f alpha:1.00f] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelButton];
    }
    return _cancelButton;
}

-(CALayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [[CALayer alloc] init];
        _lineLayer.backgroundColor = [UIColor blackColor].CGColor;
//        _lineLayer.borderWidth = 0.5;
        [self.contentView.layer addSublayer:_lineLayer];
    }
    return _lineLayer;
}

-(void)showInSuperView:(UIView *)superView{
    NSLog(@"superView is %@ ",NSStringFromCGRect(superView.frame));
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow;
    }else{
        superView = superView.window;
    }
    [superView addSubview:self];
    self.frame = superView.bounds;

    CGFloat startX = 20;
    CGFloat startY = 15;
    CGFloat buttonH = 40;
    CGFloat buttonW = (self.width -20*2)/kReportCol;
    NSInteger row = (_contentsArray.count +1)/kReportCol ;
    
    self.contentView.frame = CGRectMake(0, self.height - startY*2 - buttonH*row - 45, self.width, startY*2 + buttonH*row + 45);
    
    
    
    self.contentView.y = self.height;
    int i =0;
    for (UIButton *button in self.contentView.subviews) {
        NSInteger colB = i%kReportCol;
        NSInteger rowB = i/kReportCol;
        button.frame = CGRectMake(startX +buttonW*colB, startY+buttonH*rowB, buttonW, buttonH);
        i++;
    }
    self.cancelButton.frame = CGRectMake(0, self.contentView.height - 45, self.contentView.width, 45);
    NSLog(@"cancelButton frame si %@ ",NSStringFromCGRect(self.cancelButton.frame));
    
    self.lineLayer.frame = CGRectMake(0, self.contentView.height - 45, self.contentView.width, 0.5);
    
    [UIView animateKeyframesWithDuration:0.4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.alpha = 1;
        self.contentView.y = self.height - self.contentView.height;
    } completion:^(BOOL finished) {
        
    }];

}

-(void)dismiss{
    [UIView animateKeyframesWithDuration:0.4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.alpha = 0.0;
        self.contentView.y =self.height;
    } completion:^(BOOL finished) {
        [self.cancelButton removeFromSuperview];
        [self.contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


@end
