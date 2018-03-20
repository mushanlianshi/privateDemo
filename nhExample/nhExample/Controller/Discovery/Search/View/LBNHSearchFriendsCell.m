//
//  LBNHSearchFriendsCell.m
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHSearchFriendsCell.h"
#import "LBNHUserInfoModel.h"
#import "LBNHBaseImageView.h"
#import "UIView+LBTap.h"

NSInteger const kSearchCellMargin = 15;

@interface LBNHSearchFriendsCell()

@property (nonatomic, strong) LBNHBaseImageView  *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation LBNHSearchFriendsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setConstrants];
    }
    return self;
}

-(void)setConstrants{
    
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(kSearchCellMargin);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(kSearchCellMargin);
        make.right.equalTo(self.contentView).offset(-kSearchCellMargin);
        make.height.mas_equalTo(15);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0.5*kSearchCellMargin);
        make.right.equalTo(self.self.nameLabel);
        make.height.mas_lessThanOrEqualTo(75-38);
    }];
}

-(void)setModel:(LBNHUserInfoModel *)model{
    [self.iconView setImagePath:model.avatar_url];
    
    self.nameLabel.text = model.name;
    
    self.descLabel.text = model.desc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(LBNHBaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[LBNHBaseImageView alloc] init];
        [self.contentView addSubview:_iconView];
        _iconView.layerCornerRadius = 22;
//        WS(weakSelf);
//        WeakObject(weakIcon, _iconView);
//        [_iconView addTapBlock:^{
//
//        }];
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

@end
