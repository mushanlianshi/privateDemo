//
//  LBNHSearchLimitFriendsCell.m
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHSearchLimitFriendsCell.h"
#import "LBNHBaseImageView.h"
#import "LBNHHomeServiceDataModel.h"
//#import "LBImageTitleButton.h"
#import "UIView+LBTap.h"
#import "LBNHUserInfoModel.h"
@interface LBNHSearchLimitFriendsCell()


@end

@implementation LBNHSearchLimitFriendsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)setModelsArray:(NSArray *)modelsArray keyWords:(NSString *)keyWords{
    //最多显示5个 上面一个 下面4个
    NSInteger count = modelsArray.count > 5 ? 5 :modelsArray.count;
    //因为不会回收这个cell  我们移除在创建  效果也可以
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    //一列显示4个  以及间距
    int column = 4;
    CGFloat itemWidth = 75;
    CGFloat itemMargin = (kScreenWidth - column*itemWidth)/(column +1);
    
    for (int i =0; i<count; i++) {
        LBNHUserInfoModel *user = modelsArray[i];
        //第一个显示 单独一行
        if (i ==0 ) {
            CGFloat margin = 15;
            LBNHBaseImageView *imageView = [[LBNHBaseImageView alloc] init];
            imageView.frame = CGRectMake(margin, margin, 44, 44);
            imageView.layerCornerRadius = 44/2;
            [imageView setImagePath:user.avatar_url];
            WS(weakSelf);
            [imageView addTapBlock:^{
                if ([weakSelf.delegate respondsToSelector:@selector(searchLimitFriendsCell:clickedIndex:)]) {
                    [weakSelf.delegate searchLimitFriendsCell:weakSelf clickedIndex:0];
                }
            }];
            [self.contentView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + margin, margin, kScreenWidth - 44 - margin*3, 20);
            label.text = user.name;
            label.textColor = kCommonBlackColor;
            label.font = kFont(14);
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:label.text];
            NSRange range = [label.text rangeOfString:keyWords];
            [attributeString addAttributes:@{NSForegroundColorAttributeName : [[UIColor redColor] colorWithAlphaComponent:0.8]} range:range];
            label.attributedText = attributeString;
            [self.contentView addSubview:label];
            
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(0, 74, kScreenWidth, 0.8);
            lineLayer.backgroundColor = kCommonTintColor.CGColor;
            [self.contentView.layer addSublayer:lineLayer];
        }
        //最后一个显示的
        else if (i == count-1){
            LBImageTitleLimitButton *button = [[LBImageTitleLimitButton alloc] init];
            CGFloat btnX = itemMargin +(count - 1 -1)*(itemMargin + itemWidth);
            CGFloat btnY = itemWidth;
            CGFloat btnW = itemWidth;
            CGFloat btnH = itemWidth;
            button.frame = CGRectMake(btnX, btnY, btnW, btnH);
            button.titleLabel.font = kFont(14);
            [button setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
//            [button showRedBorder];
            [button setImage:ImageNamed(@"morefriends") forState:UIControlStateNormal];
            [button setTitle:@"更多段友" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(moreFriends:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }else{
            LBImageTitleLimitButton *button = [[LBImageTitleLimitButton alloc] init];
            CGFloat btnX = itemMargin +(i -1)*(itemMargin + itemWidth);
            CGFloat btnY = itemWidth;
            CGFloat btnW = itemWidth;
            CGFloat btnH = itemWidth;
            button.titleLabel.font = kFont(13);
            button.titleLabel.textColor = kCommonBlackColor;
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            button.imageView.layerCornerRadius = button.imageView.size.width/2;
            button.frame = CGRectMake(btnX, btnY, btnW, btnH);
//            [button showBlueBorder];
            [button setTitle:user.name forState:UIControlStateNormal];
            [button setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
            NSLog(@"button.titleLabel.text %@ ",button.titleLabel.text);
            
//            button.keyWords = keyWords;
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:button.titleLabel.text];
            NSRange range = [button.titleLabel.text rangeOfString:keyWords options:NSCaseInsensitiveSearch];
            [attributeString addAttributes:@{NSForegroundColorAttributeName : [[UIColor redColor] colorWithAlphaComponent:0.8]} range:range];
//            button.titleLabel.attributedText = attributeString.copy;
            [button setAttributedTitle:attributeString forState:UIControlStateNormal];
            
            button.tag = 100+i;
            [button addTarget:self action:@selector(friendsItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatar_url]];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [button setImage:image forState:UIControlStateNormal];
                });
            });
        }
    }
}


-(void)friendsItemClicked:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(searchLimitFriendsCell:clickedIndex:)]) {
        [self.delegate searchLimitFriendsCell:self clickedIndex:button.tag - 100];
    }
}


-(void)moreFriends:(UIButton *)button{
    NSLog(@"moreFriends moreFriends moreFriends");
    if ([self.delegate respondsToSelector:@selector(searchLimitFriendsMoreClicked:)]) {
        [self.delegate searchLimitFriendsMoreClicked:self];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation LBImageTitleLimitButton

-(instancetype)init{
    self=[super init];
    if (self) {
        self.imageView.contentMode=UIViewContentModeCenter;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    }
    return self;
}




-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.layerCornerRadius = self.imageView.width/2;
}

#pragma  mark 重写button中的label的frame的方法
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return  CGRectMake(0, self.frame.size.height*0.7, self.frame.size.width, self.frame.size.height*0.3);
}
#pragma  mark 重写button中的imageView的frame的方法
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(self.frame.size.height*0.225, 0.1*self.frame.size.height, self.frame.size.height*0.55, self.frame.size.height*0.55);
}

@end
