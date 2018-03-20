//
//  LBNHSearchPostsCellFrame.m
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHSearchPostsCellFrame.h"
#import "LBNHHomeServiceDataModel.h"
#import "NSString+Size.h"

@interface LBNHSearchPostsCellFrame ()

@end

@implementation LBNHSearchPostsCellFrame

-(void)setGroup:(LBNHHomeServiceDataElementGroup *)group{
    _group = group;
    if (group ==nil) return;
    CGFloat kMargin = 5 ;
    CGFloat kBigMargin = 20;
    //content
    CGFloat contentX = 4 *kMargin;
    CGFloat contentY = CGRectGetMaxY(self.iconViewFrame) ;
    CGFloat contentW = kScreenWidth - 2*20;
    CGFloat contentH = [group.content heightWithLimitWidth:contentW fontSize:16];
    //判断有么有content 调整距离
    if (group.content.length) {
        contentY =  CGRectGetMaxY(self.iconViewFrame) +2*kMargin;
    }else{
        contentH = 0;
    }
    self.contentLabelFrame = CGRectMake(contentX, contentY, contentW, contentH);
    
    //laughButtonFrame 的frame
    CGFloat laughtBtnX = contentX;
    CGFloat laughtBtnY = CGRectGetMaxY(self.contentLabelFrame) +2*kMargin;
    CGFloat laughtBtnW = [group.category_name widhtWithLimitHeight:20 fontSize:15] +15;
    CGFloat laughtBtnH = 20;
    self.laughButtonFrame = CGRectMake(laughtBtnX, laughtBtnY, laughtBtnW, laughtBtnH);
    
    //每次记得移除
    [self.littleImagesFrameArray removeAllObjects];
    //用来记录点赞栏的起始Y
    CGFloat thumY = CGRectGetMaxY(self.laughButtonFrame)+1.5*kMargin;
    //大图  计算宽高  等比例拉伸 以免被拉伸或则压缩
    if (group.media_type == LBNHHomeServiceDataMediaTypeLargeImage) {
        CGFloat bigImageX = 4*kMargin;
        CGFloat bigImageY = CGRectGetMaxY(self.laughButtonFrame) +  1.8*kMargin;
        CGFloat bigImageW = kScreenWidth - 20 *2;
        CGFloat bigImageH = bigImageW * group.large_image.r_height/group.large_image.r_width ;
        self.bigPictureFrame = CGRectMake(bigImageX, bigImageY, bigImageW, bigImageH);
        thumY = CGRectGetMaxY(self.bigPictureFrame) + 1.5*kMargin;
    }else if (group.media_type == LBNHHomeServiceDataMediaTypeGif){
        CGFloat gifImageX = contentX;
        CGFloat gifImageY = CGRectGetMaxY(self.laughButtonFrame) +  1.8*kMargin;
        CGFloat gifImageW = kScreenWidth - 20 *2;
        CGFloat gifImageH = gifImageW * group.large_image.r_height/group.large_image.r_width;
        self.gifPictureFrame = CGRectMake(gifImageX, gifImageY, gifImageW, gifImageH);
        thumY = CGRectGetMaxY(self.gifPictureFrame) + 1.5*kMargin;
    }else if (group.media_type == LBNHHomeServiceDataMediaTypeVideo){
        CGFloat videoImageX = contentX;
        CGFloat videoImageY = CGRectGetMaxY(self.laughButtonFrame) +  1.8*kMargin;
        CGFloat videoImageW = kScreenWidth - 20 *2;
        CGFloat videoImageH = videoImageW * group.video_720P.height/group.video_720P.width;
        self.videoCoverFrame = CGRectMake(videoImageX, videoImageY, videoImageW, videoImageH);
        thumY = CGRectGetMaxY(self.videoCoverFrame) + 1.5*kMargin;
    }else if (group.media_type == LBNHHomeServiceDataMediaTypeLittleImages){
        //小图
        NSInteger kColumnCount = 3;
        NSInteger count = group.large_image_list.count;
        if (count) {
            CGFloat margin = 15;
            CGFloat imageW = (kScreenWidth - kBigMargin*2 - margin*(kColumnCount-1))/kColumnCount;
            CGFloat imageH = imageW;
            for (int i =0; i<count; i++) {
                NSInteger row = i/kColumnCount;
                NSInteger col = i % kColumnCount;
                //图片的kuandu
                
                CGFloat imageX = col*(imageW + margin) +kBigMargin;
                CGFloat imageY = row*(imageH + margin) +CGRectGetMaxY(self.laughButtonFrame)+2*margin;
                CGRect rect = CGRectMake(imageX, imageY, imageW, imageH);
                [self.littleImagesFrameArray addObject:NSStringFromCGRect(rect)];
                thumY = CGRectGetMaxY(rect) + 1.5*kMargin;
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

@end
