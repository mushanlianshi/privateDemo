//
//  LBNHDetailCell.m
//  nhExample
//
//  Created by liubin on 17/3/24.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHDetailCell.h"
#import "LBNHBaseImageView.h"
#import "NSString+Size.h"
#import "LBUtils.h"
#import "UIView+LBTap.h"
@interface LBNHDetailCell()

@property (nonatomic, strong) LBNHBaseImageView  *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation LBNHDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectedBackgroundView  = [UIView new];
        [self setConstrants];
    }
    return self;
}

-(void)setConstrants{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.top.offset(14);
        make.height.width.mas_equalTo(35);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.top.mas_offset(19);
        make.height.mas_equalTo(18);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(14);
    }];
//    CGFloat height =
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(35 +17+10);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(8);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
}


-(void)setCommentModel:(LBNHHomeServiceDataElementComment *)commentModel{
//    NSLog(@"frmae is %@ ",NSStringFromCGRect(self.contentView.frame));
    _commentModel = commentModel;
    [self.iconView setImagePath: commentModel.user_profile_image_url];
    
    self.nameLabel.text = commentModel.user_name;
    
    self.timeLabel.text = [LBUtils convertTime:commentModel.create_time WithFormatterString:@"yyyy-MM-dd HH:mm"];
    
    self.contentLabel.text = commentModel.text;
//    [self layoutIfNeeded];
    _cellHeight = CGRectGetMaxY(self.contentLabel.frame)+10;
//    NSLog(@"detail cellheight is %f ",_cellHeight);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(LBNHBaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[LBNHBaseImageView alloc] init];
        _iconView.layerCornerRadius = 35/2;
        WS(weakSelf);
        WeakObject(weakIcon, _iconView);
        [_iconView addTapBlock:^{
            if ([weakSelf.delegate respondsToSelector:@selector(detailCell:iconViewClicked:)]) {
                [weakSelf.delegate detailCell:weakSelf iconViewClicked:weakIcon];
            }
        }];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kCommonBlackColor;
        _nameLabel.font = kFont(14);
        _nameLabel.preferredMaxLayoutWidth = kScreenWidth - 35 -17 -10 -15;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}



-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = kFont(10);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kCommonBlackColor;
        _contentLabel.font = kFont(15);
        _contentLabel.numberOfLines = 0;
//        _contentLabel.preferredMaxLayoutWidth = kScreenWidth - 35 -17 -10 -15;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
