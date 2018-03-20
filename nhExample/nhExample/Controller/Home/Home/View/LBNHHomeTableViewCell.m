//
//  LBNHHomeTableViewCell.m
//  nhExample
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomeTableViewCell.h"
#import "LBNHBaseImageView.h"
#import "LBNHHomeVideoCoverImageView.h"
#import "LBNHHomeThumBottomBarView.h"
#import "UIView+LBLayer.h"
#import "UIView+LBTap.h"
#import "LBNHHomeServiceDataModel.h"
#import "LBNHHomeCellFrame.h"
#import "LBTips.h"
#import "LBNHHomeGoldCommentView.h"
#import "LBUtils.h"
#import "LBNHSearchPostsCellFrame.h"
#import "LBCustomLongImageView.h"
#import "LBCustomGifImageView.h"
#import "UIImage+SubImage.h"
#import "UIImageView+LBGIF.h"

#define kBottomBtnTextColor [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f]

static const NSInteger kLittleImageStartTag = 100;

@interface LBNHHomeTableViewCell()


/** 热门 */
@property (nonatomic, strong) UILabel *hotLabel;

/** 头像 */
@property (nonatomic, strong) LBNHBaseImageView *iconView;

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/** 关注按钮 */
@property (nonatomic, strong) UIButton *careButton;

/** 搞笑囧途入口 */
@property (nonatomic, strong) UIButton *laughButton;


@property (nonatomic, strong) UILabel *contentLabel;


/** 大图 */
//@property (nonatomic, strong) LBNHBaseImageView  *bigPicture;
@property (nonatomic, strong) LBCustomLongImageView  *bigPicture;

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

@property (nonatomic, copy) NSString *keyWords;

@end


@implementation LBNHHomeTableViewCell
-(instancetype)init{
    self=[super init];
    if (self) {
        self.selectedBackgroundView = [UIView new];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [UIView new];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setCellFrame:(LBNHHomeCellFrame *)cellFrame keyWords:(NSString *)keyWords{
    _keyWords = keyWords;
    [self setCellFrame:cellFrame];
}

-(void)setCellFrame:(LBNHHomeCellFrame *)cellFrame{
    if (_cellFrame == cellFrame && _cellFrame) {
        return ;
    }
    _cellFrame = cellFrame;
    LBNHHomeServiceDataElementGroup *group ;
    //注意判断的先后顺序
     if ([cellFrame isKindOfClass:[LBNHSearchPostsCellFrame class]]){
        group = [(LBNHSearchPostsCellFrame *)cellFrame group];
     }else if ([cellFrame isKindOfClass:[LBNHHomeCellFrame class]]) {
         group = cellFrame.model.group;
     }
    if (group == nil) {
        return;
    }
    [self removeImageView];
    
    if (cellFrame.isDetail) {
        self.careButton.frame = cellFrame.careBtnFrame;
    }else{
        [self.careButton removeFromSuperview];
        self.careButton = nil ;
    }
    
    NSLog(@"group.status_desc IS %@ ",group.status_desc);
    //1.热门
    if ([group.status_desc containsString:@"热门"]) {
        self.hotLabel.text = @"热门";
        self.hotLabel.frame = cellFrame.hotLabelFrame;
    }else{
        [self.hotLabel removeFromSuperview];
        self.hotLabel = nil;
    }
    
    self.iconView.frame = cellFrame.iconViewFrame;
    [self.iconView setImagePath:group.user.avatar_url placeHolder:nil];
    
    self.titleLabel.text = group.user.name;
    self.titleLabel.frame = cellFrame.titleLabelFrame;
    
    self.contentLabel.text = group.content;
    if (self.keyWords && self.keyWords.length >0) {
        self.contentLabel.attributedText = [LBUtils attributeWithString:group.content keyWords:self.keyWords font:self.contentLabel.font highLightColor:kCommonHighLightRedColor textColor:self.contentLabel.textColor lineSpace:0];
    }
    self.contentLabel.frame = cellFrame.contentLabelFrame;
    
    [self.laughButton setTitle:group.category_name forState:UIControlStateNormal];
    self.laughButton.frame = cellFrame.laughButtonFrame;
    
    switch (group.media_type) {
        case LBNHHomeServiceDataMediaTypeLargeImage:
            {
                LBNHHomeServiceDataElementGroupLargeImageUrl *imageUrlModel =group.large_image.url_list.firstObject;
//                [self.bigPicture setImagePath:imageUrlModel.url placeHolder:nil];
                WS(weakSelf);
//                [self.bigPicture showRedBorder];
                [self.bigPicture setImagePath:imageUrlModel.url placeHolder:nil finishHandler:^(NSError *error, UIImage *image) {
//                    NSLog(@"LBLog yyimage image url is %@ ",imageUrlModel.url);
//                    NSLog(@"LBLog yyimage image.size is %@ ",NSStringFromCGSize(image.size));
//                    NSLog(@"LBLog yyimage image.size scale is %f ",(image.scale));
                    if (image && cellFrame.bigPictureFrame.size.height >=500) {
                        //记录原来的长图
                        weakSelf.bigPicture.originalLongImage = image;
                        //获取裁剪位置的图片  需要计算需要裁剪的位置  不能用image的尺寸来算  和实际下载下来的不一致  按服务器返回的宽高算
//                        CGImageRef newImage = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, image.size.width, cellFrame.bigPictureFrame.size.height*image.size.width/cellFrame.bigPictureFrame.size.width));
                        UIImage *longTopImage = [image subImageWithRect:CGRectMake(0, 0, cellFrame.model.group.large_image.r_width, cellFrame.bigPictureFrame.size.height*cellFrame.model.group.large_image.r_width/cellFrame.bigPictureFrame.size.width)];
                        weakSelf.bigPicture.image = longTopImage;
                        //记录当前裁剪后的image
                        weakSelf.bigPicture.cutTopImage = longTopImage;
                    }
                }];
//                [self.bigPicture setImagePath:@"http://172.16.20.232:8080/image/long.png" placeHolder:nil];
                self.bigPicture.frame = cellFrame.bigPictureFrame;
                
            }
            break;
        case LBNHHomeServiceDataMediaTypeGif:
        {
//            LBNHHomeServiceDataElementGroupLargeImageUrl
            LBNHHomeServiceDataElementGroupLargeImageUrl *imageUrlModel =group.large_image.url_list.firstObject;
            WS(weakSelf);
            [self.gifPicture lb_setGifImage:[NSURL URLWithString:imageUrlModel.url] firstImageBlock:nil];
//            [self.gifPicture setImagePath:imageUrlModel.url placeHolder:nil progressHandler:^(CGFloat progress) {
////                NSLog(@"gif picture is %f  %@ ",progress,imageUrlModel.url.description);
////                NSLog(@"currentThread log is %@ ",[NSThread currentThread]);
////                @synchronized (@"progress") {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        weakSelf.gifPicture.progress = progress;
//                    });
////                }
//                
//                
//            } finishHandler:nil];
            self.gifPicture.frame = cellFrame.gifPictureFrame;
        }
            break;
        case LBNHHomeServiceDataMediaTypeVideo:
        {
            LBNHHomeServiceDataElementGroupLargeImageUrl *imageUrlModel =group.large_cover.url_list.firstObject;
            [self.videCoverIV setImagePath:imageUrlModel.url placeHolder:nil];
            self.videCoverIV.frame = cellFrame.videoCoverFrame;
        }
            break;
        case LBNHHomeServiceDataMediaTypeLittleImages:
        {
            for (int i =0 ; i < cellFrame.littleImagesFrameArray.count; i++) {
                LBNHHomeServiceDataElementGroupLargeImage *image = group.thumb_image_list[i];
                NSString *rectString = cellFrame.littleImagesFrameArray[i];
                LBNHBaseImageView *imageView = nil ;
                if (image.is_gif) {
                    
                }else{
                    imageView = [[LBNHBaseImageView alloc] init];
                }
                imageView.frame = CGRectFromString(rectString);
                imageView.userInteractionEnabled = YES;
//                [imageView showRedBorder];
                NSLog(@"little imageFrame is %d  %@ ",i,NSStringFromCGRect(imageView.frame));
                imageView.tag = i+100; //标记tag  用来下面移除的
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(littleImageTapped:)];
                [imageView addGestureRecognizer:tapGesture];
                [imageView setImagePath:image.url];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self.contentView addSubview:imageView];
            }
        }
            break;
            
        default:
            break;
    }
    
    if (!cellFrame.isDetail) {
        if (cellFrame.model.comments.count) {
            for (int i=0; i<cellFrame.model.comments.count; i++) {
                LBNHHomeServiceDataElementComment *comment = cellFrame.model.comments[i];
                LBNHHomeGoldCommentView *commentView = [[LBNHHomeGoldCommentView alloc] init];
                commentView.comment = comment;
                commentView.tag = 200 +i;
                commentView.frame = CGRectFromString(self.cellFrame.commentsFrameArray[i]);
                [self.contentView addSubview:commentView];
            }
        }
    }
    
    [self.thumButton setTitle:[self dealCountWithForrmater:group.digg_count] forState:UIControlStateNormal];
    //如果已经定过  高亮图片
    [self.thumButton setImage:ImageNamed(group.user_digg?@"digupicon_textpage_press":@"digupicon_textpage") forState:UIControlStateNormal];
    [self.thumButton setTitleColor:(group.user_digg?kCommonHighLightRedColor:kCommonGrayTextColor) forState:UIControlStateNormal];
    self.thumButton.frame = cellFrame.thumButtonFrame;
    
    
    //踩
    [self.stepButton setTitle:[self dealCountWithForrmater:group.bury_count] forState:UIControlStateNormal];
    //如果已经定过  高亮图片
    [self.stepButton setImage:ImageNamed(group.bury_count?@"digdownicon_textpage_press":@"digdownicon_textpage") forState:UIControlStateNormal];
    [self.stepButton setTitleColor:(group.user_bury?kCommonHighLightRedColor:kCommonGrayTextColor) forState:UIControlStateNormal];
    self.stepButton.frame = cellFrame.stepButtonFrame;
    
    
    //评论
    [self.commentButton setTitle:[self dealCountWithForrmater:group.comment_count] forState:UIControlStateNormal];
    //如果已经定过  高亮图片
    self.commentButton.frame = cellFrame.commentButtonFrame;
    
    [self.shareButton setTitle:[self dealCountWithForrmater:group.share_count] forState:UIControlStateNormal];
    //如果已经定过  高亮图片
    self.shareButton.frame = cellFrame.shareButtonFrame;
    
    self.bottomView.frame = cellFrame.bottomViewFrame;
    
//    self.bottonBarView.frame = cellFrame.thumBottomFrame;
//    [self.bottonBarView setThums:group.user_digg steps:group.user_bury comments:group.user_repin];
    
    
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


/**
 * 移除下面大图 小图 视频缩略图等会遮盖的view
 */
-(void)removeImageView{
    //移除小图
    for (int i =0 ; i< 9; i++) {
        LBNHBaseImageView *iv = [self.contentView viewWithTag:i+100];
        if (iv && iv.superview) {
            [iv removeFromSuperview];
        }
    }
    //移除神评  不管有没有神评 把可能创建 的移除了
    for (int i =0 ; i<9; i++) {
        LBNHHomeGoldCommentView *view = [self.contentView viewWithTag:i+200];
        if (view && view.superview) {
            [view removeFromSuperview];
            view = nil;
        }
        
    }
    [self.bigPicture removeFromSuperview];
    [self.gifPicture removeFromSuperview];
    [self.videCoverIV removeFromSuperview];
    [self.careButton removeFromSuperview];
    self.careButton = nil;
    self.bigPicture = nil;
    self.gifPicture = nil;
    self.videCoverIV = nil ;
}



-(UILabel *)hotLabel{
    if (!_hotLabel) {
        _hotLabel = [[UILabel alloc] init];
        _hotLabel.backgroundColor = [UIColor colorWithRed:0.99f green:0.44f blue:0.40f alpha:1.00f];;
        _hotLabel.numberOfLines = 2;
        _hotLabel.textColor = [UIColor whiteColor];
        _hotLabel.font =kFont(11);
        [self.contentView addSubview:_hotLabel];
    }
    return _hotLabel;
}

-(LBNHBaseImageView *)iconView{
    if (!_iconView) {
        WS(weakSelf);
        _iconView = [[LBNHBaseImageView alloc] init];
        _iconView.layerCornerRadius = 44/2;
        [_iconView addTapBlock:^{
           //跳转到个人信息界面
            NSLog(@"go to man info =====");
            if ([weakSelf.delegate respondsToSelector:@selector(homeTableViewCell:goToPersonalCenterWithUserInfo:)]) {
                LBNHHomeServiceDataElement *element = weakSelf.cellFrame.model;
                [weakSelf.delegate homeTableViewCell:weakSelf goToPersonalCenterWithUserInfo:element.group.user];
            }
        }];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
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

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(14);
        _titleLabel.textColor = kCommonBlackColor;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
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

-(LBCustomLongImageView *)bigPicture{
    if (!_bigPicture ) {
        _bigPicture = [[LBCustomLongImageView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(largeImageTapped:)];
        [_bigPicture addGestureRecognizer:tapGesture];
        _bigPicture.userInteractionEnabled = YES;
        //add for 点击查看长图
        self.bigPicture.contentMode = UIViewContentModeScaleAspectFit;
        self.bigPicture.clipsToBounds = YES;
        [self.contentView addSubview:_bigPicture];
    }
    return _bigPicture;
}

-(LBCustomGifImageView *)gifPicture{
    if (!_gifPicture) {
        _gifPicture = [[LBCustomGifImageView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gifImageTapped:)];
        [_gifPicture addGestureRecognizer:tapGesture];
        _gifPicture.userInteractionEnabled = YES;
////        _gifPicture.autoPlayAnimatedImage = NO;
//            [self.gifPicture startAnimating];
        [self.contentView addSubview:_gifPicture];
    }
    return _gifPicture;
}

-(LBNHHomeVideoCoverImageView *)videCoverIV{
    WS(weakSelf);
    if (!_videCoverIV) {
        _videCoverIV = [[LBNHHomeVideoCoverImageView alloc] init];
        _videCoverIV.LBNHHomeVideoPlayButtonHandler = ^(UIButton *button){
            if ([weakSelf.delegate respondsToSelector:@selector(homeTableViewCell:didClickedVideo:videoCoverImage:)]) {
                [weakSelf.delegate homeTableViewCell:weakSelf didClickedVideo:weakSelf.cellFrame.model.group.video_360P.url_list.firstObject.url videoCoverImage:weakSelf.videCoverIV];
            }
            NSLog(@"点击要播放的视频地址 %@ ",weakSelf.cellFrame.model.group.video_360P.url_list.firstObject.url);
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
        _shareButton.titleLabel.font = kFont(13);
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

//-(LBNHHomeThumBottomBarView *)bottonBarView{
//    if (!_bottonBarView) {
//        _bottonBarView = [[LBNHHomeThumBottomBarView alloc] init];
//        _bottonBarView.bottomHandler=^(LBNHThumBottomClickedType type, NSInteger numbers, UIButton *button){
//        
//        };
//        [self.contentView addSubview:_bottonBarView];
//    }
//    return _bottonBarView;
//}


#pragma mark 点赞 踩按钮的变化
-(void)didDigg{
    [self.thumButton setImage:ImageNamed(@"digupicon_textpage_press") forState:UIControlStateNormal];
    [self showThumItemAnimation:self.thumButton];
    [self.thumButton setTitle:[self dealCountWithForrmater:self.cellFrame.model.group.digg_count+1] forState:UIControlStateNormal];
    
}

-(void)didBury{
    [self.stepButton setImage:ImageNamed(@"digdownicon_textpage_press") forState:UIControlStateNormal];
    [self showThumItemAnimation:self.stepButton];
    [self.stepButton setTitle:[self dealCountWithForrmater:self.cellFrame.model.group.bury_count+1] forState:UIControlStateNormal];
    
}

#pragma mark 赞  踩加1的动画
-(void)showThumItemAnimation:(UIButton *)button{
    [button setTitleColor:kCommonHighLightRedColor forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @" + 1";
    label.font = kFont(12);
    label.textColor = kCommonHighLightRedColor;
    [self.contentView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = button.frame;
    //让label在其上面20 显示
    label.y = button.y -20;
    label.transform =CGAffineTransformMakeScale(0.2, 0.2);
    label.alpha = 0.0;
    
    //+1显示的动画
    [UIView animateWithDuration:0.2 animations:^{
        label.transform = CGAffineTransformMakeScale(1.2, 1.2);
        label.alpha = 1.0;
    } completion:^(BOOL finished) {
        NSLog(@"animation thread is %@ ",[NSThread currentThread]);
        [label removeFromSuperview];
    }];
    
    //按钮的动画
    [UIView animateWithDuration:0.2 animations:^{
        button.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            button.transform = CGAffineTransformIdentity;
        }];
    }];
}



#pragma mark 赞  踩等按钮的事件
-(void)thumButtonItemClicked:(UIButton *)button{
    WS(weakSelf);
    if ([weakSelf.delegate respondsToSelector:@selector(homeTableViewCell:thumBottonItemClicked:)]) {
        [weakSelf.delegate homeTableViewCell:weakSelf thumBottonItemClicked:button.tag];
    }
    NSLog(@"赞栏点击的索引是  %d ",(int)button.tag-10);
}



#pragma mark 图片点击查看大图
/** 点击一张图片查看大图 */
-(void)largeImageTapped:(UITapGestureRecognizer *)tapGesture{
    LBCustomLongImageView *bigPicture = (LBCustomLongImageView *)[tapGesture view];
    WS(weakSelf);
    LBNHHomeServiceDataElementGroupLargeImageUrl *imageModel= self.cellFrame.model.group.large_image.url_list.firstObject;
    if ([weakSelf.delegate respondsToSelector:@selector(homeTableViewCell:didClickedImageView:currentIndex:urls:)]) {
        [weakSelf.delegate homeTableViewCell:weakSelf didClickedImageView:bigPicture currentIndex:0 urls:@[[NSURL URLWithString:imageModel.url]]];
    }
    NSLog(@"大图点击的图片地址 ：%@ ",imageModel.url);
}

-(void)gifImageTapped:(UITapGestureRecognizer *)tapGesture{
    LBCustomGifImageView *gifView = (LBCustomGifImageView *)[tapGesture view];
    WS(weakSelf);
    LBNHHomeServiceDataElementGroupLargeImageUrl *imageModel= self.cellFrame.model.group.large_image.url_list.firstObject;
    if ([weakSelf.delegate respondsToSelector:@selector(homeTableViewCell:didClickedGifView:currentIndex:urls:)]) {
        [weakSelf.delegate homeTableViewCell:weakSelf didClickedGifView:gifView currentIndex:0 urls:@[[NSURL URLWithString:imageModel.url]]];
    }
}
/** 点击九宫格图片查看大图 */
-(void)littleImageTapped:(UITapGestureRecognizer *)tapGesture{
    LBNHBaseImageView *imageView = (LBNHBaseImageView *)[tapGesture view];
    NSInteger index = imageView.tag -100;
    WS(weakSelf);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.cellFrame.littleImagesFrameArray.count; i++) {
        LBNHHomeServiceDataElementGroupLargeImageUrl *imageModel = self.cellFrame.model.group.large_image.url_list[i];
        [array addObject:[NSURL URLWithString:imageModel.url]];
    }
    if ([weakSelf.delegate respondsToSelector:@selector(homeTableViewCell:didClickedImageView:currentIndex:urls:)]) {
        [weakSelf.delegate homeTableViewCell:weakSelf didClickedImageView:imageView currentIndex:index urls:array];
    }
    NSLog(@"九宫格点击的图片地址 :%@ ,%@ ",self.cellFrame.model.group.large_image.url_list[index].url,array);
    
}

//分类按钮被点击了
-(void)laughButtonClicked:(UIButton *)button{
    NSLog(@"%@ 分类被点击了======= ",button.titleLabel.text);
    if ([self.delegate respondsToSelector:@selector(homeTableViewCellCategoryClicked:)]) {
        [self.delegate homeTableViewCellCategoryClicked:self];
    }
}

//关注按钮被点击了
-(void)careButtonClicked{
    if ([self.delegate respondsToSelector:@selector(homeTableViewCell:careButtonClicked:)]) {
        [self.delegate homeTableViewCell:self careButtonClicked:self.careButton];
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

@end
