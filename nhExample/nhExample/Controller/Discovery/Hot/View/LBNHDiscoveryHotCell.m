//
//  LBNHDiscoveryHotCell.m
//  nhExample
//
//  Created by liubin on 17/4/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHDiscoveryHotCell.h"
#import "LBNHDiscoveryModel.h"
#import "LBNHBaseImageView.h"
#import "NSString+Size.h"

@interface LBNHDiscoveryHotCell ()

@property (nonatomic, strong) LBNHBaseImageView *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *bookButton;

@property (nonatomic, strong) UILabel *bookLabel;

@property (nonatomic, strong) UILabel *countsLabel;

@property (nonatomic, strong) CALayer *lineLayer;


@end

@implementation LBNHDiscoveryHotCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setConstraints{
    self.selectedBackgroundView = [UIView new];
    CGFloat margin = 15;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(margin);
        make.top.offset(margin);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.bookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-margin);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(50);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(margin);
        make.top.offset(10);
        make.right.equalTo(self.bookButton.mas_left).offset(-margin);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.bookButton.mas_left).offset(-margin);
    }];
    
    [self.bookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.countsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookLabel.mas_right).offset(margin);
        make.centerY.equalTo(self.bookLabel);
    }];
}

-(void)setModel:(LBNHDiscoveryCategoryElement *)model{
    [self.iconView setImagePath:model.small_icon_url];
    self.nameLabel.text = model.name;
    self.descLabel.text = model.intro;
    
    self.bookLabel.text = [NSString stringWithFormat:@"%ld 订阅",model.subscribe_count];
    
    NSString *countText = [NSString stringWithFormat:@"今日更新 %ld",model.today_updates];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:countText];
    NSRange range = [countText rangeOfString:@"今日更新 "];
    NSRange rangeRed = NSMakeRange(range.location +range.length, countText.length-range.length);
    [attributeString addAttributes:@{NSForegroundColorAttributeName : kCommonHighLightRedColor} range:rangeRed];
    self.countsLabel.attributedText = attributeString;
}

-(LBNHBaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[LBNHBaseImageView alloc] init];
        _iconView.backgroundColor = kCommonTintColor;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kCommonBlackColor;
        _nameLabel.font = kFont(15);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = kCommonGrayTextColor;
        _descLabel.font = kFont(13);
        //设置后面多余字不显示
        _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_descLabel];
    }
    return _descLabel;
}

-(UIButton *)bookButton{
    if (!_bookButton) {
        _bookButton = [[UIButton alloc] init];
        _bookButton.titleLabel.font = kFont(15);
        [_bookButton setTitle:@"订阅" forState:UIControlStateNormal];
        [_bookButton setTitle:@"已订阅" forState:UIControlStateSelected];
        [_bookButton setTitleColor:kCommonHighLightRedColor forState:UIControlStateNormal];
        [_bookButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_bookButton addTarget:self action:@selector(bookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bookButton setLayerCornerRadius:5 borderWitdh:1 borderColor:kCommonHighLightRedColor];
        [self.contentView addSubview:_bookButton];
    }
    return _bookButton;
}

-(UILabel *)bookLabel{
    if (!_bookLabel) {
        _bookLabel = [[UILabel alloc] init];
        _bookLabel.textColor = kCommonGrayTextColor;
        _bookLabel.font = kFont(13);
        [self.contentView addSubview:_bookLabel];
    }
    return _bookLabel;
}

-(CALayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [[CALayer alloc] init];
        _lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [self.contentView.layer addSublayer:_lineLayer];
    }
    return _lineLayer;
}

-(UILabel *)countsLabel{
    if (!_countsLabel) {
        _countsLabel = [[UILabel alloc] init];
        _countsLabel.textColor = kCommonGrayTextColor;
        _countsLabel.font = kFont(13);
        [self.contentView addSubview:_countsLabel];
    }
    return _countsLabel;
}

-(void)bookButtonClicked:(UIButton *)button{
    if (button.isSelected) return;
    button.hidden =YES;
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = button.center;
    indicatorView.bounds = CGRectMake(0, 0, 25, 25);
    [self.contentView addSubview:indicatorView];
    indicatorView.tag = 1002;
    NSLog(@"self indicatView frame si %@ ",NSStringFromCGRect(indicatorView.frame));
    NSLog(@"self button frame si %@ ",NSStringFromCGRect(button.frame));
    [indicatorView startAnimating];
    if (self.careBtnHandler) {
        self.careBtnHandler(self,button);
    }
}
-(void)removeAnimation{
    UIActivityIndicatorView *indicatorView = [self.contentView viewWithTag:1002];
    if (indicatorView) {
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
    }
}


@end
