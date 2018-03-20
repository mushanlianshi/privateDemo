//
//  LBNHHomeCellFrame.m
//  nhExample
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomeCellFrame.h"
#import "NSString+Size.h"

static const CGFloat kMargin = 5;
static const CGFloat kBigMargin = 20;

static const NSInteger kColumnCount = 3;//默认一行显示3张小图


@implementation LBNHHomeCellFrame

-(void)setModel:(LBNHHomeServiceDataElement *)model isDetail:(BOOL)isDetail{
    _model = model;
    _isDetail = isDetail;
    self.hotLabelFrame = CGRectMake(0, kBigMargin, 15, 30);
    //头像
    CGFloat iconX = 4*kMargin;
    CGFloat iconY = 15;
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    self.iconViewFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //title
    CGFloat titleX = CGRectGetMaxX(self.iconViewFrame) + 2*kMargin;
    CGFloat titleY = iconY +(iconH - 20)/2;
    CGFloat titleW = kScreenWidth - CGRectGetMaxX(self.iconViewFrame) - 2*kMargin;
    CGFloat titleH = 20;
    self.titleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
    
    //详情页
    if (isDetail) {
        CGFloat careX = kScreenWidth - 10 -50;
        CGFloat careY = iconY;
        CGFloat careW = 50;
        CGFloat careH = 30;
        self.careBtnFrame = CGRectMake(careX, careY, careW, careH);
    }
    
    //content
    CGFloat contentX = iconX;
    CGFloat contentY = CGRectGetMaxY(self.iconViewFrame) ;
    CGFloat contentW = kScreenWidth - 2*20;
    CGFloat contentH = [model.group.content heightWithLimitWidth:contentW fontSize:16];
    //判断有么有content 调整距离
    if (model.group.content.length) {
        contentY =  CGRectGetMaxY(self.iconViewFrame) +2*kMargin;
    }else{
        contentH = 0;
    }
    self.contentLabelFrame = CGRectMake(contentX, contentY, contentW, contentH);
    
    //laughButtonFrame 的frame
    CGFloat laughtBtnX = contentX;
    CGFloat laughtBtnY = CGRectGetMaxY(self.contentLabelFrame) +2*kMargin;
    CGFloat laughtBtnW = [model.group.category_name widhtWithLimitHeight:20 fontSize:15] +15;
    CGFloat laughtBtnH = 20;
    self.laughButtonFrame = CGRectMake(laughtBtnX, laughtBtnY, laughtBtnW, laughtBtnH);
    
    //每次记得移除
    [self.littleImagesFrameArray removeAllObjects];
    //用来记录点赞栏的起始Y
    CGFloat thumY = CGRectGetMaxY(self.laughButtonFrame)+1.5*kMargin;
    //大图  计算宽高  等比例拉伸 以免被拉伸或则压缩
    if (model.group.media_type == LBNHHomeServiceDataMediaTypeLargeImage) {
        CGFloat bigImageX = iconX;
        CGFloat bigImageY = CGRectGetMaxY(self.laughButtonFrame) +  1.8*kMargin;
        CGFloat bigImageW = kScreenWidth - 20 *2;
        CGFloat bigImageH = bigImageW * model.group.large_image.r_height/model.group.large_image.r_width ;
        bigImageH = bigImageH > 501 ? 501 :bigImageH;
        self.bigPictureFrame = CGRectMake(bigImageX, bigImageY, bigImageW, bigImageH);
        thumY = CGRectGetMaxY(self.bigPictureFrame) + 1.5*kMargin;
    }else if (model.group.media_type == LBNHHomeServiceDataMediaTypeGif){
        CGFloat gifImageX = iconX;
        CGFloat gifImageY = CGRectGetMaxY(self.laughButtonFrame) +  1.8*kMargin;
        CGFloat gifImageW = kScreenWidth - 20 *2;
        CGFloat gifImageH = gifImageW * model.group.large_image.r_height/model.group.large_image.r_width;
        self.gifPictureFrame = CGRectMake(gifImageX, gifImageY, gifImageW, gifImageH);
        thumY = CGRectGetMaxY(self.gifPictureFrame) + 1.5*kMargin;
    }else if (model.group.media_type == LBNHHomeServiceDataMediaTypeVideo){
        CGFloat videoImageX = iconX;
        CGFloat videoImageY = CGRectGetMaxY(self.laughButtonFrame) +  1.8*kMargin;
        CGFloat videoImageW = kScreenWidth - 20 *2;
        CGFloat videoImageH = videoImageW * model.group.video_720P.height/model.group.video_720P.width;
        self.videoCoverFrame = CGRectMake(videoImageX, videoImageY, videoImageW, videoImageH);
        thumY = CGRectGetMaxY(self.videoCoverFrame) + 1.5*kMargin;
    }else if (model.group.media_type == LBNHHomeServiceDataMediaTypeLittleImages){
        //小图
        NSInteger count = model.group.large_image_list.count;
        if (count) {
            CGFloat margin = 15;
            //图片的kuandu
            CGFloat imageW = (kScreenWidth - kBigMargin*2 - margin*(kColumnCount-1))/kColumnCount;
            CGFloat imageH = imageW;
            for (int i =0; i<count; i++) {
                NSInteger row = count/kColumnCount;
                NSInteger col = count % kColumnCount;
                CGFloat imageX = col*(imageW + margin) +kBigMargin;
                CGFloat imageY = row*(imageH + margin) +CGRectGetMaxY(self.laughButtonFrame)+2*margin;
                CGRect rect = CGRectMake(imageX, imageY, imageW, imageH);
                [self.littleImagesFrameArray addObject:NSStringFromCGRect(rect)];
                thumY = CGRectGetMaxY(rect) + 1.5*kMargin;
            }
        }
    }
    
    //不是详情页  可能有神评
    if (!isDetail) {
        if (model.comments && model.comments.count) {
            for (int i=0; i<model.comments.count; i++) {
                CGFloat commentX = iconX;
                CGFloat commentY = thumY;
                CGFloat commentW = kScreenWidth - iconX*2 ;
                NSString *commentString = model.comments[i].text;
                CGFloat commentStrH = [commentString heightWithLimitWidth:commentW - 20 -35-10*2 fontSize:14];
                CGFloat commentH = 10 +35  +commentStrH +10;
                CGRect commentRect = CGRectMake(commentX, commentY, commentW, commentH);
                [self.commentsFrameArray addObject:NSStringFromCGRect(commentRect)];
                thumY = CGRectGetMaxY(commentRect)+10;
            }
        }
    }
    
    
    //底部赞栏
    CGFloat thumX = kBigMargin;
    CGFloat thumW = (kScreenWidth - 20)/5;
    CGFloat thumH = 35;
    self.thumButtonFrame = CGRectMake(thumX, thumY, thumW, thumH);
    
    //踩
    CGFloat stepX = CGRectGetMaxX(self.thumButtonFrame);
    CGFloat stepY = thumY;
    CGFloat stepW = (kScreenWidth - 20)/5;
    CGFloat stepH = 35;
    self.stepButtonFrame = CGRectMake(stepX, stepY, stepW, stepH);
    
    //评论
    CGFloat commentX = CGRectGetMaxX(self.stepButtonFrame);
    CGFloat commentY = thumY;
    CGFloat commentW = (kScreenWidth - 20)/5;
    CGFloat commentH = 35;
    self.commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
    
    
    //分享
    CGFloat shareW = (kScreenWidth - 20)/5;
    CGFloat shareX = kScreenWidth - 20 -shareW;
    CGFloat shareY = thumY;
    CGFloat shareH = 35;
    self.shareButtonFrame = CGRectMake(shareX, shareY, shareW, shareH);
    
    self.bottomViewFrame = CGRectMake(0, CGRectGetMaxY(self.shareButtonFrame), kScreenWidth, 15);
    
    self.cellHeight = CGRectGetMaxY(self.shareButtonFrame) + 15;
}

-(void)setModel:(LBNHHomeServiceDataElement *)model{
    [self setModel:model isDetail:NO];
}

-(NSMutableArray *)littleImagesFrameArray{
    if (!_littleImagesFrameArray) {
        _littleImagesFrameArray = [[NSMutableArray alloc] initWithCapacity:9];
    }
    return _littleImagesFrameArray;
}

-(NSMutableArray *)commentsFrameArray{
    if (!_commentsFrameArray) {
        _commentsFrameArray = [NSMutableArray new];
    }
    return _commentsFrameArray;
}

@end
