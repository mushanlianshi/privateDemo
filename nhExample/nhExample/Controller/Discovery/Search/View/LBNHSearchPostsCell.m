//
//  LBNHSearchPostsCell.m
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHSearchPostsCell.h"
#import "LBNHBaseImageView.h"
#import "LBNHHomeVideoCoverImageView.h"
#import "LBCustomGifImageView.h"
#import "UIView+LBTap.h"
#import "LBNHHomeServiceDataModel.h"

#define kBottomBtnTextColor [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f]

@interface LBNHSearchPostsCell()

/** 关注按钮 */
@property (nonatomic, strong) UIButton *careButton;

/** 搞笑囧途入口 */
@property (nonatomic, strong) UIButton *laughButton;


@property (nonatomic, strong) UILabel *contentLabel;


/** 大图 */
@property (nonatomic, strong) LBNHBaseImageView  *bigPicture;

/** gif图片 */
@property (nonatomic, strong) LBCustomGifImageView  *gifPicture;

/** 视频 */
@property (nonatomic, strong) LBNHHomeVideoCoverImageView *videCoverIV;




/** 赞 */
@property (nonatomic, strong) UIButton *thumButton;

/** 踩 */
@property (nonatomic, strong) UIButton *stepButton;

/** 评论 */
@property (nonatomic, strong) UIButton *commentButton;

/** 分享 */
@property (nonatomic, strong) UIButton *shareButton;


/** 最后一个分隔栏 */
@property (nonatomic, strong) UIView *bottomView;

/** 底部赞的状态栏 */
//@property (nonatomic, strong) LBNHHomeThumBottomBarView *bottonBarView;

@end

@implementation LBNHSearchPostsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setConstraints];
    }
    return self;
}


-(void)setGroup:(LBNHHomeServiceDataElementGroup *)group{
    CGFloat leftMargin = 15;
    CGFloat topMargin = 10;
    self.contentLabel.text = group.text;
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(leftMargin);
        make.top.offset(topMargin);
        make.width.mas_lessThanOrEqualTo(kScreenWidth - 2*leftMargin);
    }];
    
    [self.laughButton setTitle:group.category_name forState:UIControlStateNormal];
    [self.laughButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(topMargin);
    }];
    
    [self removeImageViews];
    __block UIView *tmpView;
    switch (group.media_type) {
        case LBNHHomeServiceDataMediaTypeLargeImage:
            {
                [self.bigPicture setImagePath:group.large_image.url_list.firstObject.url];
                [self.bigPicture mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel);
                    make.right.offset(-leftMargin);
                    make.top.equalTo(self.laughButton).offset(topMargin*0.5);
                }];
                tmpView = self.bigPicture;
            }
            break;
        case LBNHHomeServiceDataMediaTypeGif:
            {
                [self.gifPicture setImagePath:group.large_image.url_list.firstObject.url];
                [self.gifPicture mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel);
                    make.right.offset(-leftMargin);
                    make.top.equalTo(self.laughButton).offset(topMargin*0.5);
                }];
                tmpView = self.gifPicture;
            }
            break;
        case LBNHHomeServiceDataMediaTypeVideo:
            {
                [self.videCoverIV setImagePath:group.large_cover.url_list.firstObject.url];
                [self.videCoverIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel);
                    make.right.offset(-leftMargin);
                    make.top.equalTo(self.laughButton).offset(topMargin*0.5);
                }];
                tmpView = self.videCoverIV;
            }
            break;
        case LBNHHomeServiceDataMediaTypeLittleImages:
            {
                NSInteger column = 3;
                CGFloat itemWidth = (kScreenWidth - (column -1)*leftMargin - 2*leftMargin)/column;
                UIView *littleView;
                for (int i =0; i<group.thumb_image_list.count; i++) {
                    
                    NSInteger row = i / column;
                    NSInteger col = i % column;
                    
                    LBNHHomeServiceDataElementGroupLargeImage *image = group.thumb_image_list[i];
                    if (image.is_gif) {
                        LBCustomGifImageView *gifView = [[LBCustomGifImageView alloc] init];
                        [gifView setImagePath:image.url];
                        gifView.contentMode = UIViewContentModeScaleAspectFit;
                        gifView.tag = 100+1;
                        [self.contentView addSubview:gifView];
                        
                        [gifView mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.width.height.mas_equalTo(itemWidth);
                            //第一行
                            if (row == 0) {
                                if (littleView == nil) {
                                    make.left.equalTo(self.contentLabel);
                                    make.top.equalTo(self.laughButton.mas_bottom).offset(topMargin);
                                }else{
                                    make.left.equalTo(littleView.mas_right).offset(leftMargin);
                                    make.topMargin.equalTo(littleView);
                                }
                            }else{
                                if (col == 0) {
                                    make.left.equalTo(self.contentLabel.mas_right).offset(leftMargin);
                                    make.top.equalTo(littleView.mas_bottom).offset(leftMargin);
                                }else{
                                    make.left.equalTo(littleView.mas_right).offset(leftMargin);
                                    make.top.equalTo(littleView);
                                }
                            }
                        }];
                        tmpView = gifView;
                        littleView = gifView;
                        
                    }else{
                        LBNHBaseImageView *iv = [[LBNHBaseImageView alloc] init];
                        [iv setImagePath:image.url];
                        iv.contentMode = UIViewContentModeScaleAspectFit;
                        iv.tag = 100+1;
                        [self.contentView addSubview:iv];
                        
                        [iv mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.width.height.mas_equalTo(itemWidth);
                        //第一行
                        if (row == 0) {
                            if (littleView == nil) {
                                make.left.equalTo(self.contentLabel);
                                make.top.equalTo(self.laughButton.mas_bottom).offset(topMargin);
                            }else{
                                make.left.equalTo(littleView.mas_right).offset(leftMargin);
                                make.topMargin.equalTo(littleView);
                            }
                        }else{
                            if (col == 0) {
                                make.left.equalTo(self.contentLabel.mas_right).offset(leftMargin);
                                make.top.equalTo(littleView.mas_bottom).offset(leftMargin);
                            }else{
                                make.left.equalTo(littleView.mas_right).offset(leftMargin);
                                make.top.equalTo(littleView);
                            }
                        }
//                        //第二行
//                        else if (row == 1){
//                            //第一个
//                            if (col == 0) {
//                                make.left.equalTo(self.contentLabel);
//                                make.top.equalTo(littleView.mas_bottom).offset(leftMargin);
//                            }else{
//                                make.left.equalTo(littleView.mas_right).offset(leftMargin);
//                                make.top.equalTo(littleView);
//                            }
//                        }
//                            
//                        else if (row == 2){
//                            //第一个
//                            if (col == 0) {
//                                make.left.equalTo(self.contentLabel);
//                                make.top.equalTo(littleView.mas_bottom).offset(leftMargin);
//                            }else{
//                                make.leftMargin.equalTo(littleView.mas_right).offset(leftMargin);
//                                make.top.equalTo(littleView);
//                            }
//                        }
                            
                        }];
                        tmpView = iv;
                        littleView = iv;
                    }
                    
                }
            }
            break;
            
        default:
            break;
    }
    
    if (tmpView == nil) {
        tmpView = self.laughButton;
    }
    
   [self.thumButton setTitle:[self dealCountWithForrmater:group.digg_count] forState:UIControlStateNormal];
//    [self.thumButton showRedBorder];
    //如果已经定过  高亮图片
    [self.thumButton setImage:ImageNamed(group.user_digg?@"digupicon_textpage_press":@"digupicon_textpage") forState:UIControlStateNormal];
   [self.thumButton mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.contentLabel);
       make.top.mas_equalTo(tmpView.mas_bottom);
       make.height.mas_equalTo(35);
       make.width.mas_equalTo((kScreenWidth - 20)/5);
   }];
    
    [self.stepButton setTitle:[self dealCountWithForrmater:group.bury_count] forState:UIControlStateNormal];
//    [self.stepButton showBlueBorder];
    //如果已经定过  高亮图片
    [self.stepButton setImage:ImageNamed(group.bury_count?@"digdownicon_textpage_press":@"digdownicon_textpage") forState:UIControlStateNormal];
    [self.stepButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumButton.mas_right).offset(5);
        make.top.equalTo(self.thumButton);
        make.width.height.equalTo(self.thumButton);
    }];
    
    
    [self.commentButton setTitle:[self dealCountWithForrmater:group.comment_count] forState:UIControlStateNormal];
    [self.commentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stepButton.mas_right).offset(5);
        make.top.equalTo(self.thumButton);
        make.width.height.equalTo(self.thumButton);
    }];
    
    [self.shareButton setTitle:[self dealCountWithForrmater:group.share_count] forState:UIControlStateNormal];
    [self.shareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-leftMargin);
        make.top.equalTo(self.thumButton);
        make.width.height.equalTo(self.thumButton);
    }];
    
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thumButton.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.contentView);
    }];
    
    
    
}


-(void)removeImageViews{
    [self.bigPicture removeFromSuperview];
    self.bigPicture = nil;
    [self.gifPicture removeFromSuperview];
    self.gifPicture = nil;
    [self.videCoverIV removeFromSuperview];
    self.videCoverIV = nil;
    for (int i =0; i<9; i++) {
        LBNHBaseImageView *iv = [self.contentView viewWithTag:100+i];
        if (iv&&iv.superview) {
            [iv removeFromSuperview];
        }
    }
    
}

-(NSString *)dealCountWithForrmater:(NSInteger)count{
    if (count>10000) {
        CGFloat number=count/10000.0f;
        NSString *title=[NSString stringWithFormat:@"%.1f万",number];
        title=[title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        return title;
    }
    return [NSString stringWithFormat:@"%ld",count];
}

-(void)setConstraints{
//    CGFloat leftMargin = 15;
//    CGFloat topMargin = 10;
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(leftMargin);
//        make.top.offset(topMargin);
//        make.width.mas_lessThanOrEqualTo(kScreenWidth - 2*leftMargin);
//    }];
//    
//    [self.laughButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentLabel);
//        make.top.equalTo(self.contentLabel.mas_bottom).offset(topMargin);
//    }];
//    
//    [self.bigPicture mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentLabel);
//        make.right.offset(-leftMargin);
//        make.top.equalTo(self.laughButton).offset(topMargin*0.5);
//    }];
//    
//    [self.gifPicture mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentLabel);
//        make.right.offset(-leftMargin);
//        make.top.equalTo(self.laughButton).offset(topMargin*0.5);
//    }];
//    
//    [self.videCoverIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentLabel);
//        make.right.offset(-leftMargin);
//        make.top.equalTo(self.laughButton).offset(topMargin*0.5);
//    }];
    
    
    
}



-(UIButton *)laughButton{
    if (!_laughButton) {
        _laughButton = [[UIButton alloc] init];
        [_laughButton addTarget:self action:@selector(laughButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _laughButton.titleLabel.font = kFont(14);
        [_laughButton setTitleColor:kCommonTintColor forState:UIControlStateNormal];
        [_laughButton setLayerCornerRadius:10.f borderWitdh:1 borderColor:kCommonTintColor];
        [self.contentView addSubview:_laughButton];
    }
    return _laughButton;
}



-(UIButton *)careButton{
    if (!_careButton) {
        _careButton = [[UIButton alloc] init];
        [_careButton addTarget:self action:@selector(careButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_careButton setTitleColor:kCommonHighLightRedColor forState:UIControlStateNormal];
        _careButton.layerBorderWidth =1;
        _careButton.layerBorderColor = kCommonHighLightRedColor;
        _careButton.layerCornerRadius = 3;
        [_careButton setTitle:@"关注" forState:UIControlStateNormal];
        _careButton.titleLabel.font = kFont(14);
        [self.contentView addSubview:_careButton];
    }
    return _careButton;
}

-(UIView *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kCommonBlackColor;
        _contentLabel.font = kFont(16);
        _contentLabel.numberOfLines = 0 ;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(LBNHBaseImageView *)bigPicture{
    if (!_bigPicture ) {
        _bigPicture = [[LBNHBaseImageView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(largeImageTapped:)];
        [_bigPicture addGestureRecognizer:tapGesture];
        _bigPicture.userInteractionEnabled = YES;
        [self.contentView addSubview:_bigPicture];
    }
    return _bigPicture;
}

-(LBCustomGifImageView *)gifPicture{
    if (!_gifPicture) {
        //        _gifImageView = [[LBCustomGifImageView alloc] init];
        //        [self.scrollView addSubview:_gifImageView];
        
        LBCustomGifImageView *gifImageView = [[LBCustomGifImageView alloc] init];
        [self.contentView addSubview:gifImageView];
        WS(weakSelf);
        [_gifPicture addTapBlock:^{
//            if ([weakSelf.delegate respondsToSelector:@selector(checkCell:imageView:currentIndex:urls:)]) {
//                [weakSelf.delegate checkCell:weakSelf imageView:weakSelf.gifImageView currentIndex:0 urls:@[[NSURL URLWithString:imageModel.url]]];
//            }
        }];
        _gifPicture = gifImageView;
        _gifPicture.backgroundColor = kCommonBgColor;
        
    }
    return  _gifPicture;
}

-(LBNHHomeVideoCoverImageView *)videCoverIV{
    WS(weakSelf);
    if (!_videCoverIV) {
        _videCoverIV = [[LBNHHomeVideoCoverImageView alloc] init];
        _videCoverIV.LBNHHomeVideoPlayButtonHandler = ^(UIButton *button){
//            if ([weakSelf.delegate respondsToSelector:@selector(homeTableViewCell:didClickedVideo:videoCoverImage:)]) {
//                [weakSelf.delegate homeTableViewCell:weakSelf didClickedVideo:weakSelf.cellFrame.model.group.video_360P.url_list.firstObject.url videoCoverImage:weakSelf.videCoverIV];
//            }
//            NSLog(@"点击要播放的视频地址 %@ ",weakSelf.cellFrame.model.group.video_360P.url_list.firstObject.url);
        };
        [self.contentView addSubview:_videCoverIV];
    }
    return _videCoverIV;
}

-(UIButton *)thumButton{
    if (!_thumButton) {
        _thumButton = [[UIButton alloc] init];
        [_thumButton setImage:ImageNamed(@"digupicon_comment") forState:UIControlStateNormal];
        [_thumButton setTitleColor:kBottomBtnTextColor forState:UIControlStateNormal];
        _thumButton.titleLabel.font = kFont(11);
        //让按钮内的位子 图片 左右排列
        _thumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        _thumButton.titleLabel.adjustsFontSizeToFitWidth = YES; //字体大小自动调节
        _thumButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 3, -3);
        [_thumButton addTarget:self action:@selector(thumButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        _thumButton.tag = LBThumBottomClickItemTypeThum;
        [self.contentView addSubview:_thumButton];
    }
    return _thumButton;
}

-(UIButton *)stepButton{
    if (!_stepButton) {
        _stepButton = [[UIButton alloc] init];
        [_stepButton setImage:ImageNamed(@"digdownicon_textpage") forState:UIControlStateNormal];
        [_stepButton setTitleColor:kBottomBtnTextColor forState:UIControlStateNormal];
        _stepButton.titleLabel.font = kFont(11);
        //让按钮内的位子 图片 左右排列
        _stepButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        _stepButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _stepButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 3, -3);
        [_stepButton addTarget:self action:@selector(thumButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        _stepButton.tag = LBThumBottomClickItemTypeStep;
        [self.contentView addSubview:_stepButton];
    }
    return _stepButton;
}

-(UIButton *)commentButton{
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] init];
        [_commentButton setImage:ImageNamed(@"commenticon_textpage") forState:UIControlStateNormal];
        [_commentButton setTitleColor:kBottomBtnTextColor forState:UIControlStateNormal];
        _commentButton.titleLabel.font = kFont(11);
        //让按钮内的位子 图片 左右排列
        _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        _stepButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_commentButton addTarget:self action:@selector(thumButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        _commentButton.tag = LBThumBottomClickItemTypeComment;
        _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 3, -3);
        [self.contentView addSubview:_commentButton];
    }
    return _commentButton;
}

-(UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        [_shareButton setImage:ImageNamed(@"moreicon_textpage") forState:UIControlStateNormal];
        [_shareButton setTitleColor:kBottomBtnTextColor forState:UIControlStateNormal];
        _shareButton.titleLabel.font = kFont(11);
        _shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 3, -3);
        //让按钮内的位子 图片 左右排列
        _shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        _stepButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_shareButton addTarget:self action:@selector(thumButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.tag = LBThumBottomClickItemTypeShare;
        [self.contentView addSubview:_shareButton];
    }
    return _shareButton;
}


-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    }
    [self.contentView addSubview:_bottomView];
    return _bottomView;
}

@end
