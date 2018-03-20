//
//  LBNHDiscoveryBookCell.m
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHDiscoveryBookCell.h"
#import "LBNHBaseImageView.h"


@interface LBNHDiscoveryBookCell()

@property (nonatomic, strong) LBNHBaseImageView *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *rightLabel;



@end


@implementation LBNHDiscoveryBookCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupConstraints];
    }
    return self;
}

/** 设置约束 */
-(void)setupConstraints{
    self.selectedBackgroundView = [UIView new];
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
        make.centerY.equalTo(self.nameLabel);
    }];
}

-(void)setModel:(LBNHDiscoveryCategoryElement *)model{
    [self.iconView setImagePath:model.icon_url placeHolder:nil];
    
    self.nameLabel.text = model.name;
    
    self.descLabel.text = model.intro;
    
    NSString *content = [NSString stringWithFormat:@"今日更新 %ld",model.today_updates];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange range = [content rangeOfString:@"今日更新 "];
    NSString *countString = [content substringFromIndex:(range.location +range.length)];
    NSRange countRange = [content rangeOfString:countString];
    //今日更新显示的富文本
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    [attributeString addAttribute:NSFontAttributeName value:kFont(14) range:range];
    
    //个数显示的富文本
    [attributeString addAttribute:NSForegroundColorAttributeName value:kCommonHighLightRedColor range:countRange];
    [attributeString addAttribute:NSFontAttributeName value:kFont(13) range:countRange];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentRight;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
    self.rightLabel.attributedText = attributeString;
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
