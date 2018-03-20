//
//  LBNHHomeCellFrame.h
//  nhExample
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBNHHomeServiceDataModel.h"

/**
 home 界面的cellFrame  计算了各个空间的cellFrame
 */
@interface LBNHHomeCellFrame : NSObject



/** 热门label的frame */
@property (nonatomic, assign) CGRect hotLabelFrame;

/** 头像Icon的frame */
@property (nonatomic, assign) CGRect iconViewFrame;

/** 标题label的frame */
@property (nonatomic, assign) CGRect titleLabelFrame;

/** 关注按钮的frame */
@property (nonatomic, assign) CGRect careBtnFrame;

/** 搞笑按钮的frame */
@property (nonatomic, assign) CGRect laughButtonFrame;

/** 文字内容的frame */
@property (nonatomic, assign) CGRect contentLabelFrame;

/** 大图的frame */
@property (nonatomic, assign) CGRect bigPictureFrame;

/** gif图的frame */
@property (nonatomic, assign) CGRect gifPictureFrame;

/** 视频缩略图的frame */
@property (nonatomic, assign) CGRect videoCoverFrame;


/** 保存小图的位置的数组 */
@property (nonatomic, strong) NSMutableArray *littleImagesFrameArray;



/** 神评的frame数组 */
@property (nonatomic, strong) NSMutableArray *commentsFrameArray;

/** 赞按钮的位置 */
@property (nonatomic, assign) CGRect thumButtonFrame;

/** 踩按钮的位置 */
@property (nonatomic, assign) CGRect stepButtonFrame;

/** 评论钮的位置 */
@property (nonatomic, assign) CGRect commentButtonFrame;

/** 分享钮的位置 */
@property (nonatomic, assign) CGRect shareButtonFrame;

/** 最后分隔栏的位置 */
@property (nonatomic, assign) CGRect bottomViewFrame;


/** 底部赞状态栏的frame */
//@property (nonatomic, assign) CGRect thumBottomFrame;



/** 用来记录cell的高度的 */
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) LBNHHomeServiceDataElement *model;


/** 记录是不是详情页的 */
@property (nonatomic, assign) BOOL isDetail;



/** 设置模型 是不是详情页   详情页有关注  没有神评 */
-(void)setModel:(LBNHHomeServiceDataElement *)model isDetail:(BOOL)isDetail;

@end
