//
//  LBNHPersonalHeaderView.m
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHPersonalHeaderView.h"
#import "LBNHBaseImageView.h"
#import "LBNHPersonalHeaderCountView.h"
#import "LBNHUserInfoModel.h"

@interface LBNHPersonalHeaderView()

@property (nonatomic, strong) UILabel *nameLabel;

/** 封面图 */
@property (nonatomic, strong) LBNHBaseImageView *coverIV;

/** 头像图片 */
@property (nonatomic, strong) LBNHBaseImageView *iconIV;

@property (nonatomic, strong) LBNHPersonalHeaderCountView *careColumeView;

@end

@implementation LBNHPersonalHeaderView

-(void)setUserInfoModel:(LBNHUserInfoModel *)userInfoModel{
    [self coverIV];
    _userInfoModel = userInfoModel;
    self.nameLabel.text = userInfoModel.name;
    
    NSInteger fans = userInfoModel.followers;
    NSInteger follows = userInfoModel.followings;
    NSInteger point = userInfoModel.point;
    [self.careColumeView setTitles:@[@"关注",@"粉丝",@"积分"] counts:@[@(fans),@(follows),@(point)]];
    [self.iconIV setImageURL:[NSURL URLWithString:userInfoModel.avatar_url] placeHolder:nil];
}


-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = kCommonBlackColor;
        _nameLabel.font = kFont(17);
        _nameLabel.frame = CGRectMake(0, 200-45, kScreenWidth, 25);
        [self addSubview:_nameLabel];
        
    }
    return _nameLabel;
}

-(LBNHBaseImageView *)coverIV{
    if (!_coverIV) {
        _coverIV = [[LBNHBaseImageView alloc] init];
        UIImage *image = ImageNamed(@"cover_kebi.jpg");
        _coverIV.image = image;
        _coverIV.frame = CGRectMake(0, 0, kScreenWidth, 200);
        [self addSubview:_coverIV];
    }
    return _coverIV;
}

-(LBNHBaseImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [[LBNHBaseImageView alloc] init];
        _iconIV.frame = CGRectMake(25, 135, 80, 80);
        _iconIV.layerCornerRadius = 40;
        [self addSubview:_iconIV];
    }
    return _iconIV;
}

-(LBNHPersonalHeaderCountView *)careColumeView{
    if (!_careColumeView) {
        _careColumeView = [[LBNHPersonalHeaderCountView alloc] init];
        _careColumeView.frame = CGRectMake(0, 200, kScreenWidth, 79);
        _careColumeView.backgroundColor = [UIColor whiteColor];
        WS(weakSelf);
        _careColumeView.clickedHandler = ^(LBNHPersonalHeaderCountView *countView,NSInteger index){
            if ([weakSelf.delegate respondsToSelector:@selector(personalHeaderView:clickedIndex:)]) {
                [weakSelf.delegate personalHeaderView:self clickedIndex:index];
            }
        };
        [self addSubview:_careColumeView];
    }
    return _careColumeView;
}


@end
