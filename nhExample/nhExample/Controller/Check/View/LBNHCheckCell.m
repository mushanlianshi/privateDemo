//
//  LBNHCheckCell.m
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHCheckCell.h"
#import "LBNHBaseImageView.h"
#import "LBNHHomeServiceDataModel.h"
#import "LBNHCheckCellFrame.h"
#import "LBNHHomeVideoCoverImageView.h"
#import "UIView+LBTap.h"
#import "LBNHCheckCellViewProgressBar.h"
#import "LBCustomGifImageView.h"

@interface LBNHCheckCell ()


/**
 * 因为内容高度超过collectionView  所以内容需要被scrol包裹 不然会出问题
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/** 投稿的内容 */
@property (nonatomic, strong) UILabel *titleLabel;

/** 大图 */
@property (nonatomic, strong) LBNHBaseImageView *largeImageView;

/** gif大图 */
@property (nonatomic, strong) LBCustomGifImageView *gifImageView;

/** 视频缩略图 */
@property (nonatomic, strong) LBNHHomeVideoCoverImageView *videoImageView;

/** 举报的 */
@property (nonatomic, strong) UIButton *reportButton;


/** 上面白色背景view */
@property (nonatomic, strong) UIView *whiteBackView;



/** 喜欢的图片 */
@property (nonatomic, strong) UIImageView *likeIV;

/** 喜欢的label */
@property (nonatomic, strong) UILabel *likeLabel;

/** 喜欢的图片 */
@property (nonatomic, strong) UIImageView *dislikeIV;

/** 喜欢的label */
@property (nonatomic, strong) UILabel *dislikeLabel;

@property (nonatomic, strong) LBNHCheckCellViewProgressBar *progressBar;

@property (nonatomic, assign) BOOL isLikeFlag;

@end


@implementation LBNHCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setCellFrame:(LBNHCheckCellFrame *)cellFrame{
    _cellFrame = cellFrame;
    
    LBNHHomeServiceDataElementGroup *group = cellFrame.element.group;
    self.titleLabel.text = group.content;
    self.titleLabel.frame = cellFrame.titleFrame;
    //移除缓存cell显示的图片空间
    [self removeImageViews];
    
    switch (group.media_type) {
        case LBNHHomeServiceDataMediaTypeLargeImage:
            {
                LBNHHomeServiceDataElementGroupLargeImageUrl *urlModel = group.large_image.url_list.firstObject;
                [self.largeImageView setImagePath:urlModel.url placeHolder:nil];
                self.largeImageView.frame = cellFrame.largeFrame;
            }
            break;
        case LBNHHomeServiceDataMediaTypeGif:
        {
            LBNHHomeServiceDataElementGroupLargeImageUrl *urlModel = group.large_image.url_list.firstObject;
//            [self.gifImageView setImagePath:urlModel.url placeHolder:nil];
            WS(weakSelf);
            [self.gifImageView setImagePath:urlModel.url placeHolder:nil progressHandler:^(CGFloat progress) {
                NSLog(@"gif progress is %f %@",progress,group.content);
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.gifImageView.progress =progress;
                });
            } finishHandler:^(NSError * error, UIImage * image) {
                
            }];
            self.gifImageView.frame = cellFrame.gifFrame;
        }
            break;
        case LBNHHomeServiceDataMediaTypeVideo:
        {
            LBNHHomeServiceDataElementGroupLargeImageUrl *urlModel = group.large_image.url_list.firstObject;
            [self.videoImageView setImagePath:urlModel.url placeHolder:nil];
            self.videoImageView.frame = cellFrame.videoCoverFrame;
        }
            break;
        case LBNHHomeServiceDataMediaTypeLittleImages:
        {
            for (int i =0 ; i<group.large_image_list.count; i++) {
                LBNHBaseImageView *iv = [[LBNHBaseImageView alloc] init];
                NSString *rectString = cellFrame.littleFrames[i];
                iv.frame = CGRectFromString(rectString);
                [iv addTapBlock:^{
                    
                }];
                iv.tag =i +100;
                [self.scrollView addSubview:iv];
            }
        }
            break;
            
        default:
            break;
    }
    
    //举报
    self.reportButton.frame = cellFrame.reportFrame;
    
    self.likeIV.frame = cellFrame.likeIVFrame;
    self.likeLabel.frame = cellFrame.likeLabelFrame;
    
    self.dislikeIV.frame = cellFrame.dislikeIVFrame;
    self.dislikeLabel.frame = cellFrame.dislikeLabelFrame;
    
    self.scrollView.frame = cellFrame.scrollViewFrame;
    self.scrollView.contentSize = cellFrame.contentSize;
    
    [self removeBar];
    self.progressBar.frame = cellFrame.animationBarFrame;
}

//移除别的cell显示的cell
-(void)removeImageViews{
    LBNHHomeServiceDataElementGroup *group = _cellFrame.element.group;
    for (int i =0; i<group.large_image_list.count; i++) {
        LBNHBaseImageView *iv = [self.scrollView viewWithTag:100+i];
        [iv removeFromSuperview];
        iv = nil ;
    }
    [self.largeImageView removeFromSuperview];
    [self.videoImageView removeFromSuperview];
    [self.gifImageView removeFromSuperview];
    self.largeImageView = nil;
    self.videoImageView = nil;
    self.gifImageView = nil;
}

-(void)removeBar{
    [self.progressBar removeFromSuperview];
    self.progressBar = nil;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        [self.contentView addSubview:_scrollView];
    }
    return _scrollView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(15);
        _titleLabel.textColor = kCommonBlackColor;
        _titleLabel.numberOfLines = 0;
        [self.scrollView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(LBNHBaseImageView *)largeImageView{
    if (!_largeImageView) {
//        _largeImageView = [[LBNHBaseImageView alloc] init];
//        [self.scrollView addSubview:_largeImageView];
        
        LBNHBaseImageView *largeImageView = [[LBNHBaseImageView alloc] init];
        [self.scrollView addSubview:largeImageView];
        _largeImageView = largeImageView;
        _largeImageView.backgroundColor = kCommonBgColor;
        WS(weakSelf);
        LBNHHomeServiceDataElementGroupLargeImageUrl *imageModel= _cellFrame.element.group.large_image.url_list.firstObject;
        [_largeImageView addTapBlock:^{
            if ([weakSelf.delegate respondsToSelector:@selector(checkCell:imageView:currentIndex:urls:)]) {
                [weakSelf.delegate checkCell:weakSelf imageView:weakSelf.largeImageView currentIndex:0 urls:@[[NSURL URLWithString:imageModel.url]]];
            }
        }];
        
    }
    return  _largeImageView;
}

-(LBCustomGifImageView *)gifImageView{
    if (!_gifImageView) {
//        _gifImageView = [[LBCustomGifImageView alloc] init];
//        [self.scrollView addSubview:_gifImageView];
        
        LBCustomGifImageView *gifImageView = [[LBCustomGifImageView alloc] init];
        [self.scrollView addSubview:gifImageView];
        WS(weakSelf);
        LBNHHomeServiceDataElementGroupLargeImageUrl *imageModel= _cellFrame.element.group.large_image.url_list.firstObject;
        [_gifImageView addTapBlock:^{
            if ([weakSelf.delegate respondsToSelector:@selector(checkCell:imageView:currentIndex:urls:)]) {
                [weakSelf.delegate checkCell:weakSelf imageView:weakSelf.gifImageView currentIndex:0 urls:@[[NSURL URLWithString:imageModel.url]]];
            }
        }];
        _gifImageView = gifImageView;
        _gifImageView.backgroundColor = kCommonBgColor;
        
    }
    return  _gifImageView;
}

-(LBNHHomeVideoCoverImageView *)videoImageView{
    if (!_videoImageView) {
//        _videoImageView = [[LBNHHomeVideoCoverImageView alloc] init];
        LBNHHomeVideoCoverImageView *videoImage = [[LBNHHomeVideoCoverImageView alloc] init];
        [self.scrollView addSubview:videoImage];
        _videoImageView  = videoImage;
        _videoImageView.backgroundColor = kCommonBgColor;
        _videoImageView.LBNHHomeVideoPlayButtonHandler = ^(UIButton *playButton){
        
        };
//        [self.scrollView addSubview:_videoImageView];
    }
    return _videoImageView;
}

-(UIButton *)reportButton{
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] init];
        _reportButton.layerBorderColor = kCommonTintColor;
        _reportButton.layerBorderWidth = 1;
        _reportButton.layerCornerRadius = 5;
        [_reportButton setTitleColor:kCommonTintColor forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(reportButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
        [self.scrollView addSubview:_reportButton];
    }
    return _reportButton;
}

-(UIView *)whiteBackView{
    if (!_whiteBackView) {
        _whiteBackView = [[UIView alloc] init];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_whiteBackView];
    }
    return _whiteBackView;
}



-(UIImageView *)likeIV{
    if (!_likeIV) {
        _likeIV = [[UIImageView alloc] init];
        _likeIV.layerCornerRadius = 22;
        _likeIV.image = ImageNamed(@"digupicon_review_press_1");
        WS(weakSelf);
        [_likeIV addTapBlock:^{
            weakSelf.isLikeFlag = YES;
            [weakSelf showPercentAnimationWithLeftScale:(weakSelf.cellFrame.element.group.digg_count + 1)* 1.0f/(weakSelf.cellFrame.element.group.digg_count + 1 + weakSelf.cellFrame.element.group.bury_count)];
        }];
        [self.scrollView addSubview:_likeIV];
    }
    return _likeIV;
}

-(UILabel *)likeLabel{
    if (!_likeLabel) {
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.font = kFont(12);
        _likeLabel.textColor = kCommonBlackColor;
        _likeLabel.text = @"喜欢";
        _likeLabel.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:_likeLabel];
    }
    return _likeLabel;
}

-(UIImageView *)dislikeIV{
    if (!_dislikeIV) {
        _dislikeIV = [[UIImageView alloc] init];
        _dislikeIV.layerCornerRadius = 22;
        _dislikeIV.image = ImageNamed(@"digdownicon_review_press_1");
        WS(weakSelf);
        [_dislikeIV addTapBlock:^{
            weakSelf.isLikeFlag = NO;
            [weakSelf showPercentAnimationWithLeftScale:(weakSelf.cellFrame.element.group.digg_count)* 1.0f/(weakSelf.cellFrame.element.group.digg_count + weakSelf.cellFrame.element.group.bury_count +1)];
        }];
        [self.scrollView addSubview:_dislikeIV];
    }
    return _dislikeIV;
}

-(UILabel *)dislikeLabel{
    if (!_dislikeLabel) {
        _dislikeLabel = [[UILabel alloc] init];
        _dislikeLabel.font = kFont(12);
        _dislikeLabel.textColor = kCommonBlackColor;
        _dislikeLabel.textAlignment = NSTextAlignmentCenter;
        _dislikeLabel.text = @"不喜欢";
        [self.scrollView addSubview:_dislikeLabel];
    }
    return _dislikeLabel;
}

-(LBNHCheckCellViewProgressBar *)progressBar{
    if (!_progressBar) {
        _progressBar = [LBNHCheckCellViewProgressBar bar];
        [self.scrollView addSubview:_progressBar];
        WS(weakSelf);
        _progressBar.finishAnimationBlock = ^(){
            if ([weakSelf.delegate respondsToSelector:@selector(checkCell:didFinishLoadingWithFlag:)]) {
                [weakSelf.delegate checkCell:weakSelf didFinishLoadingWithFlag:YES];
            }
        };
    }
    return _progressBar;
}

//喜欢不喜欢的点击动画
-(void)showPercentAnimationWithLeftScale:(CGFloat)leftScale{
    self.progressBar.leftScale = leftScale;
    self.progressBar.rightScale = 1 - leftScale;
}

#pragma mark 举报按钮事件
-(void)reportButtonHandler:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(checkCell:reportClicked:)]) {
        [self.delegate checkCell:self reportClicked:YES];
    }
}

-(void)dealloc{
    NSLog(@"lb cell deall0c ===========");
}

@end
