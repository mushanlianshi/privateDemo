//
//  LBNHDiscoveryHotHeaderCell.m
//  nhExample
//
//  Created by liubin on 17/4/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHDiscoveryHotHeaderCell.h"
#import "LBNHBaseImageView.h"
@interface LBNHDiscoveryHotHeaderCell()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) LBNHBaseImageView *bannerImageView;

@end

@implementation LBNHDiscoveryHotHeaderCell

-(void)setTitle:(NSString *)title{
    _title = title;
    self.label.text = title;
//    [self sendSubviewToBack:self.bannerImageView];
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.bannerImageView setImagePath:imageUrl placeHolder:nil];
    [self.contentView bringSubviewToFront:self.label];
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
//        [_label showBlueBorder];
        _label.font = kFont(15);
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.bottom.offset(-10);
            make.height.mas_equalTo(15);
        }];
    }
    return _label;
}

-(LBNHBaseImageView *)bannerImageView{
    if (!_bannerImageView) {
        _bannerImageView = [[LBNHBaseImageView alloc] init];
//        [_bannerImageView showRedBorder];
        [self.contentView addSubview:_bannerImageView];
        [_bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _bannerImageView;
}

@end
