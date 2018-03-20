//
//  YPUserInfoTableviewCell.m
//  nhExample
//
//  Created by liubin on 17/5/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "YPUserInfoTableviewCell.h"
#import "YPUserInfoModel.h"
#import "LBNHBaseImageView.h"

static CGFloat kMargin = 10;

@interface YPUserInfoTableviewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subLabel;

@property (nonatomic, strong) LBNHBaseImageView *iconImageView;

@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation YPUserInfoTableviewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setConstraints];
    }
    return self;
}

-(void)setConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kMargin);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kMargin);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-kMargin);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.subLabel.mas_left).offset(-kMargin);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(35);
    }];
    self.iconImageView.layerCornerRadius = 35/2;
}


-(void)setModel:(YPUserInfoModel *)model{
    if (!model) return;
//    UIView *tempView = nil;
    
    self.titleLabel.text = model.title;
    
    if (model.subTitle && model.subTitle.length) {
        self.subLabel.hidden = NO;
        self.subLabel.text = model.subTitle;
        
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.subLabel.mas_left).offset(-kMargin);
            make.centerY.equalTo(self.contentView);
            make.height.width.mas_equalTo(35);
        }];
        
    }else{
        self.subLabel.hidden = YES;
        
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImageView.mas_left).offset(-kMargin);
            make.centerY.equalTo(self.contentView);
            make.height.width.mas_equalTo(35);
        }];
    }
    
    
    if (model.image) {
        self.iconImageView.hidden = NO;
        self.iconImageView.image = model.image;
    }else{
        if (model.iconURL && model.iconURL.length) {
            self.iconImageView.hidden = NO;
            [self.iconImageView setImagePath:model.iconURL];
        }{
            self.iconImageView.hidden = YES;
        }
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(15);
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        _subLabel.font = kFont(12);
        _subLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_subLabel];
    }
    return _subLabel;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[LBNHBaseImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = ImageNamed(@"yp_arrow");
        [self.contentView addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

@end
