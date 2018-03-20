//
//  LBNHPublishSelectColumnCell.m
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHPublishSelectColumnCell.h"
#import "LBNHPublishSelectColumnModel.h"
#import "LBNHBaseImageView.h"
@interface LBNHPublishSelectColumnCell()

@property (nonatomic, strong) LBNHBaseImageView *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *rightLabel;


@end

@implementation LBNHPublishSelectColumnCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupConstraints];
    }
    return self;
}

/** 设置约束 */
-(void)setupConstraints{
    CGFloat margin = 15;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(margin);
        make.top.offset(margin);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(margin);
        make.top.equalTo(self.iconView);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.iconView);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-margin);
        make.centerY.equalTo(self.contentView);
    }];
}

-(void)setModel:(LBNHPublishSelectColumnModel *)model{
    [self.iconView setImagePath:model.icon placeHolder:nil];
    
    self.nameLabel.text = model.name;
    
    self.descLabel.text = [NSString stringWithFormat:@"%ld段友期待你的加入",model.subscribe_count];
    
    NSString *video = model.allow_video ? @"视频、" : @"";
    NSString *image = model.allow_multi_image ? @"图片、" :@"";
    NSString *text = model.allow_video ? @"文字、" : @"";
    NSString *gif = model.allow_multi_image ? @"gif" :@"";
    
    NSString *content = [NSString stringWithFormat:@"%@%@%@%@",video,image,text,gif];
    NSRange lastRange = NSMakeRange(content.length-1, 1);
    NSString *lastString = [content substringWithRange:lastRange];
    if ([lastString isEqualToString:@"、"]) {
        content = [content substringToIndex:content.length-1];
    }
    self.rightLabel.text = content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.selectedBackgroundView = [UIView new];
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(LBNHBaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[LBNHBaseImageView alloc] init];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kCommonBlackColor;
        _nameLabel.font = kFont(14);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = kCommonBlackColor;
        _descLabel.font = kFont(12);
        [self.contentView addSubview:_descLabel];
    }
    return _descLabel;
}

-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor lightGrayColor];
        _rightLabel.font = kFont(10);
        [self.contentView addSubview:_rightLabel];
    }
    return _rightLabel;
}

@end
