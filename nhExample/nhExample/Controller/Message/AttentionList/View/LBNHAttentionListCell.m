//
//  LBNHAttetiionListCell.m
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHAttentionListCell.h"
#import "LBNHBaseImageView.h"
#import "LBNHAttetionListModel.h"
#import "UIView+LBTap.h"

const CGFloat kAtMargin = 15;

@interface LBNHAttentionListCell ()

@property (nonatomic, strong) LBNHBaseImageView  *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *careButton;


/** 点击关注的加载框 */
//@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;


/** 显示文字动画的label */
//@property (nonatomic, strong) UILabel *animationLabel;


@end


@implementation LBNHAttentionListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setConstrants];
    }
    return self;
}

-(void)setConstrants{
    [self.careButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kAtMargin);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(kAtMargin);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(kAtMargin);
        make.right.equalTo(self.careButton.mas_left).offset(-kAtMargin);
        make.height.mas_equalTo(15);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0.5*kAtMargin);
        make.right.equalTo(self.self.nameLabel);
        make.height.mas_lessThanOrEqualTo(75-38);
    }];
}

-(void)setAttentionModel:(LBNHAttetionListModel *)attentionModel{
    
    [self.iconView setImagePath:attentionModel.avatar_url placeHolder:nil];
    
    self.nameLabel.text = attentionModel.name;
    
    self.descLabel.text = attentionModel.last_update;
    
    if (attentionModel.is_following) {
        [self.careButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.careButton setTitleColor:kCommonGrayTextColor forState:UIControlStateNormal];
        self.careButton.layerBorderColor = kCommonGrayTextColor;
    }else{
        [self.careButton setTitleColor:kCommonHighLightRedColor forState:UIControlStateNormal];
        [self.careButton setTitle:@"关注" forState:UIControlStateNormal];
        self.careButton.layerBorderColor = kCommonHighLightRedColor;
    }
}



-(LBNHBaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[LBNHBaseImageView alloc] init];
        [self.contentView addSubview:_iconView];
        _iconView.layerCornerRadius = 22;
        WS(weakSelf);
        WeakObject(weakIcon, _iconView);
        [_iconView addTapBlock:^{
            if ([weakSelf.delegate respondsToSelector:@selector(attentionListCell:userIconTapped:)]) {
                [weakSelf.delegate attentionListCell:weakSelf userIconTapped:weakIcon];
            }
        }];
    }
    return _iconView;
}


-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFont(15);
        _nameLabel.textColor = kCommonBlackColor;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}


-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = kFont(13);
        _descLabel.textColor = kCommonBlackColor;
        _descLabel.numberOfLines = 0;
        _descLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_descLabel];
    }
    return _descLabel;
}

-(UIButton *)careButton{
    if (!_careButton) {
        _careButton = [[UIButton alloc] init];
        [_careButton addTarget:self action:@selector(careButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.careButton.layerBorderWidth = 0.5;
        self.careButton.layerCornerRadius = 4;
        self.careButton.titleLabel.font = kFont(14);
        [self.contentView addSubview:_careButton];
    }
    return _careButton;
}

//-(UIActivityIndicatorView *)indicatorView{
//    if (!_indicatorView) {
//        
//    }
//    return _indicatorView;
//}
//
//-(UILabel *)animationLabel{
//    if (!_animationLabel) {
//        _animationLabel = [[UILabel alloc] init];
//        [self.contentView addSubview:_animationLabel];
//    }
//    return _animationLabel;
//}

#pragma mark 动画显示加载
-(void)startAnimationShow{
    self.careButton.hidden = YES;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = self.careButton.center;
    indicatorView.bounds = CGRectMake(0, 0, 30, 30);
    indicatorView.tag = 1001;
    [indicatorView startAnimating];
    [self.contentView addSubview:indicatorView];
    
    UILabel *label = [[UILabel alloc] init];
    label.center = self.careButton.center;
    label.bounds = self.careButton.bounds;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kFont(12);
    label.text = self.careButton.currentTitle;
    label.textColor = [UIColor colorWithRed:0.92 green:0.53 blue:0.24 alpha:1.00];
    [self.contentView addSubview:label];
    
    [UIView animateWithDuration:0.5 animations:^{
        label.centerY = label.centerY -20;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}

-(void)setCareButtonIsCare:(BOOL)isCare{
    UIActivityIndicatorView *indicator = [self.contentView viewWithTag:1001];
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    self.careButton.hidden = NO;
    if (isCare) {
        [self.careButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.careButton setTitleColor:kCommonGrayTextColor forState:UIControlStateNormal];
        self.careButton.layerBorderColor = kCommonGrayTextColor;
    }else{
        [self.careButton setTitleColor:kCommonHighLightRedColor forState:UIControlStateNormal];
        [self.careButton setTitle:@"关注" forState:UIControlStateNormal];
        self.careButton.layerBorderColor = kCommonHighLightRedColor;
    }
}

-(void)careButtonClicked:(UIButton *)button{
    [self startAnimationShow];
    WS(weakSelf);
    if ([weakSelf.delegate respondsToSelector:@selector(attentionListCell:careUserClicked:)]) {
        [weakSelf.delegate attentionListCell:weakSelf careUserClicked:button];
    }
}


@end
