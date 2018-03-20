//
//  LBShareBottomView.m
//  nhExample
//
//  Created by liubin on 17/4/1.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBShareBottomView.h"
#import "UIView+LBTap.h"

NSInteger const kColumn = 4 ;// 一行4个item
CGFloat const kItemWidth = 70; //默认item的大小
@interface LBShareBottomView ()

@property (nonatomic, copy) NSArray *titlesArray;

@property (nonatomic, copy) NSArray *imagesArray;

@property (nonatomic, copy) NSArray *bottomTitles;

@property (nonatomic, copy) NSArray *bottomImages;

@property (nonatomic, strong) UILabel *shareLabel;

@property (nonatomic, strong) UIButton *cancelButton;

/** 背景色view */
@property (nonatomic, strong) UIView *backgroundView;

/** 包裹分享菜单的view */
@property (nonatomic, strong) UIView *shareView;

/** 包裹底部菜单栏的view */
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) CALayer *lineLayer;

@end


@implementation LBShareBottomView

-(instancetype)initWithTitle:(NSArray *)titlesArray imagesArray:(NSArray *)imagesArray{
    self=[super init];
    if (self) {
        [self config];
        self.titlesArray = titlesArray;
        self.imagesArray = imagesArray;
    }
    return self;
}

-(void)config{
    WS(weakSelf);
    [self addTapBlock:^{
        [weakSelf dismiss];
    }];
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [self initUI];
}


-(void)setCopyItems:(NSArray *)copyTitles copyImages:(NSArray *)copyImages{
    self.bottomTitles = copyTitles;
    self.bottomImages = copyImages;
}

-(void)layoutSubviews{
    CGFloat width = self.width;
    CGFloat height = self.height;
    CGFloat cancelH = 40;
    CGFloat shareLH = 25;
    
    
    CGFloat bottomHeight = 0;
    if (self.bottomView.subviews.count) {
        for (int i =0 ; i<self.bottomView.subviews.count; i++) {
            LBShareButton *button = (LBShareButton *)[self.bottomView viewWithTag:i+100];
            int col = i % kColumn;
            int row = i / kColumn;
            button.frame = CGRectMake(col*kItemWidth, row*kItemWidth, kItemWidth, kItemWidth);
            NSLog(@"button frame is %@ ",NSStringFromCGRect(button.frame));
            bottomHeight = (row + 1)*kItemWidth;
        }
    }
    
    CGFloat botW = kColumn * kItemWidth;
    CGFloat botH = bottomHeight;
    CGFloat botX = (width - botW)/2;
    
    
    
    CGFloat margin = (width - kItemWidth*kColumn)/(kColumn+1);
    CGFloat shareHeight = 0;
    if (self.shareView.subviews.count) {
        for (int i =0; i<self.shareView.subviews.count; i++) {
            LBShareButton *button = (LBShareButton *)[self.shareView viewWithTag:i+100];
            int col = i % kColumn;
            int row = i / kColumn;
            button.frame = CGRectMake(col*(kItemWidth + margin)+margin, row*kItemWidth, kItemWidth, kItemWidth);
            NSLog(@"shareView frame is %@ ",NSStringFromCGRect(button.frame));
            shareHeight = (row + 1)*kItemWidth;
        }
    }
    
    CGFloat shareW = width;
    CGFloat shareH = shareHeight;
    CGFloat shareX = 0;
    
    //先算出背景色的高度
    CGFloat backH = cancelH +shareH +botH +10 +shareLH;
    self.backgroundView.frame = CGRectMake(0, height - backH, width, backH);
    
    self.shareLabel.frame = CGRectMake(0, 0, width, shareLH);
    
    //根据背景色的高度在算分享 操作的位置
    CGFloat shareY = shareLH;
    self.shareView.frame = CGRectMake(shareX, shareY, shareW, shareH);
    
    self.lineLayer.frame = CGRectMake(0, CGRectGetMaxY(self.shareView.frame), width, 0.5);
    
    CGFloat botY = shareH +10 + shareLH;
    self.bottomView.frame = CGRectMake(botX, botY, botW, botH);
    
    self.cancelButton.frame = CGRectMake(0, shareH + botH + shareLH+10, width, cancelH);
    
}

-(void)initUI{
    if (self.bottomTitles.count){
        for (int i=0; i<self.bottomTitles.count; i++) {
            LBShareButton *button = [[LBShareButton alloc] init];
            [button setTitle:self.bottomTitles[i] forState:UIControlStateNormal];
            [button setImage:ImageNamed(self.bottomImages[i]) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(bottomItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100 + i;
            [self.bottomView addSubview:button];
        }
    }
    if (self.titlesArray.count) {
        for (int i =0; i<self.titlesArray.count; i++) {
            LBShareButton *shareButton = [[LBShareButton alloc] init];
            [shareButton setTitle:self.titlesArray[i] forState:UIControlStateNormal];
            [shareButton setImage:ImageNamed(self.imagesArray[i]) forState:UIControlStateNormal];
            [shareButton addTarget:self action:@selector(shareItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            shareButton.tag = 100 + i;
            [self.shareView addSubview:shareButton];
        }
    }
}

-(void)shareItemClicked:(LBShareButton *)button{
    NSLog(@"分享item clicked ==========");
    NSInteger index = button.tag - 100;
    if (self.itemHandler) {
        self.itemHandler(self, YES, index);
    }
}

-(void)bottomItemClicked:(LBShareButton *)button{
    NSLog(@"复制item clicked ==========");
    NSInteger index = button.tag - 100;
    if (self.itemHandler) {
        self.itemHandler(self, NO, index);
    }
}

-(void)cancelButtonClicked:(UIButton *)button{
    [self dismiss];
}

-(void)showDefault{
    self.titlesArray = @[@"微信",@"微信朋友圈",@"手机QQ",@"新浪微博",@"腾讯微博",@"QQ空间"];
    self.imagesArray = @[@"weixin_popover",@"weixinpengyou_popover",@"qq_popover",@"invite-weibo",@"qqweibo_popover",@"qqkongjian_popover"];
    [self setCopyItems:@[@"复制",@"收藏",@"举报",@"保存视频"] copyImages:@[@"url_popover",@"favorite_popover",@"report_popover",@"favorite_popover_select"]];
    [self config];
    [self layoutIfNeeded];
    [self show];
}

/** 显示 */
-(void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    NSLog(@"self. frame si %@ ", NSStringFromCGRect(self.frame));
    self.y = kScreenHeight;
    
    [UIView animateWithDuration:0.6f animations:^{
        self.y = 0;
    } completion:^(BOOL finished) {
        for (LBShareButton *button in self.shareView.subviews) {
            button.y -=button.height ;
            NSLog(@"self.bottomView frame is %@ ",NSStringFromCGRect(button.frame));
        }
    }];
    for (LBShareButton *button in self.shareView.subviews) {
        [UIView animateWithDuration:1.f delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            button.y +=button.height;
        } completion:^(BOOL finished) {
            
        }];
    }
}

/** 关闭显示 */
-(void)dismiss{
    [UIView animateWithDuration:0.6f animations:^{
        self.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(UILabel *)shareLabel{
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.textAlignment = NSTextAlignmentCenter;
        _shareLabel.text = @"分享到";
        [self.backgroundView addSubview:_shareLabel];
        _shareLabel.textColor = [UIColor blackColor];
        _shareLabel.font = kFont(15);
    }
    return _shareLabel;
}

-(UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.backgroundView addSubview:_bottomView];
    }
    return _bottomView;
}

-(UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc] init];
        _shareView.backgroundColor = [UIColor whiteColor];
        [self.backgroundView addSubview:_shareView];
    }
    return _shareView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.titleLabel.font = kFont(17);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:_cancelButton];
    }
    return _cancelButton;
}

-(NSArray *)titlesArray{
    if (!_titlesArray) {
        
    }
    return _titlesArray;
}
-(NSArray *)imagesArray{
    if (!_imagesArray) {
        
    }
    return _imagesArray;
}
-(NSArray *)bottomTitles{
    if (!_bottomTitles) {
        
    }
    return _bottomTitles;
}
-(NSArray *)bottomImages{
    if (!_bottomImages) {
        
    }
    return _bottomImages;
}

-(CALayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [[CALayer alloc] init];
        _lineLayer.backgroundColor = kCommonTintColor.CGColor;
        [self.backgroundView.layer addSublayer:_lineLayer];
    }
    return _lineLayer;
}

-(void)dealloc{
    NSLog(@"LBLog shareView dealloc ===============");
}

@end

@implementation LBShareButton

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
//        [self showRedBorder];
//        [self.titleLabel showBlueBorder];
//        [self.imageView showRedBorder];
        self.titleLabel.font = kFont(13);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self;
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0.15*self.width, 0, self.width*0.7, self.height * 0.6);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0.6*self.height, self.width, self.height * 0.3);
}



-(void)dealloc{
//    NSLog(@"LBLog LBShareButton dealloc ===============");
}
@end
