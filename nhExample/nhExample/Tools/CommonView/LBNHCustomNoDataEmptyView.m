//
//  LBNHCustomNoDataEmptyView.m
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHCustomNoDataEmptyView.h"
#import "NSString+Size.h"

@interface LBNHCustomNoDataEmptyView()

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) UIImage *image;

@end

@implementation LBNHCustomNoDataEmptyView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setConstraints];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title image:(UIImage *)image desc:(NSString *)desc{
    self=[super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.desc = desc;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.topLabel.text = self.title;
    self.bottomLabel.text = self.desc;
    self.imageView.image = self.image;
}

-(void)setConstraints{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(150);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(-10);
        make.left.right.equalTo(self);
    }];
    
    self.bottomLabel.preferredMaxLayoutWidth = kScreenWidth - 40*2;
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.imageView.frame = CGRectMake(0, 0, kScreenWidth, 150);
    
    
//    CGFloat imageY ;
//    if (self.title.length>0 || self.topLabel.text.length>0) {
//        self.topLabel.frame = CGRectMake(0, 20, self.width, 25);
//        imageY = 65;
//    }else{
//        imageY = 45;
//    }
//    
//    self.imageView.frame = CGRectMake(0, imageY, self.width, self.imageView.image.size.height);
//    //        CGFloat bottomWidth = 200;
//    CGFloat height = [self.bottomLabel.text heightWithLimitWidth:200 fontSize:14];
//    self.bottomLabel.frame = CGRectMake((self.width-200)/2, CGRectGetMaxY(self.imageView.frame)+30, 200, height);
//    if (self.height<(CGRectGetMaxY(self.bottomLabel.frame)+20)) {
//        self.height = (CGRectGetMaxY(self.bottomLabel.frame)+20);
//    }
}

-(UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.textColor = kCommonBlackColor;
        _topLabel.font = kFont(14);
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_topLabel];
    }
    return _topLabel;
}

-(UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.textColor = kCommonGrayTextColor;
        _bottomLabel.font = kFont(14);
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bottomLabel];
    }
    return _bottomLabel;
}


-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(void)dealloc{
    NSLog(@"LBNHCustomNoDataEmptyView dealloc -===========");
}

@end
