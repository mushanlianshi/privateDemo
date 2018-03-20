//
//  LBNHHomeGoldCommentView.m
//  nhExample
//
//  Created by liubin on 17/3/25.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomeGoldCommentView.h"
#import "LBNHBaseImageView.h"
#import "NSString+Size.h"
@interface LBNHHomeGoldCommentView ()

@property (nonatomic, strong) LBNHBaseImageView *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end


@implementation LBNHHomeGoldCommentView

-(void)setComment:(LBNHHomeServiceDataElementComment *)comment{
    [self.iconView setImagePath:comment.user_profile_image_url placeHolder:nil];
    self.iconView.frame = CGRectMake(20, 15, 35, 35);
    
    self.nameLabel.text = comment.user_name;
    
    CGFloat nameX = CGRectGetMaxX(self.iconView.frame) +10;
    CGFloat nameY = (CGRectGetMaxY(self.iconView.frame) -15- 15)/2 + 15;
    CGFloat nameW = kScreenWidth - 20*2 - self.iconView.width - 10;
    CGFloat nameH = 15;
    self.nameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
    
    self.contentLabel.text = comment.text;
    CGFloat conX = CGRectGetMaxX(self.iconView.frame) +5;
    CGFloat conY = CGRectGetMaxY(self.iconView.frame) ;
    CGFloat conW = kScreenWidth - 2*20 -CGRectGetMaxY(self.iconView.frame) -5;
    CGFloat conH = [comment.text heightWithLimitWidth:conW fontSize:14];
    self.contentLabel.frame = CGRectMake(conX, conY, conW, conH);
    
    
}

-(LBNHBaseImageView *)iconView{
    if (!_iconView) {
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        _iconView = [[LBNHBaseImageView alloc] init];
        _iconView.layerCornerRadius = 35/2;
        [self addSubview:_iconView];
    }
    return _iconView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFont(13);
        _nameLabel.textColor = kCommonBlackColor;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}


-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kFont(14);
        _contentLabel.textColor = kCommonBlackColor;
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
