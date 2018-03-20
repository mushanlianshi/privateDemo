//
//  LBNHCheckCellFrame.h
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBNHHomeServiceDataElement;

@interface LBNHCheckCellFrame : NSObject

@property (nonatomic, assign) CGRect titleFrame;


/** 视频缩略图 */
@property (nonatomic, assign) CGRect videoCoverFrame;

/** gif缩略图 */
@property (nonatomic, assign) CGRect gifFrame;

/** 大图 */
@property (nonatomic, assign) CGRect largeFrame;

/** 小图数组 */
@property (nonatomic, strong) NSMutableArray *littleFrames;

/** 举报 */
@property (nonatomic, assign) CGRect reportFrame;

/** 上面白色区域 */
@property (nonatomic, assign) CGRect whiteBackFrame;



/** 喜欢图片 */
@property (nonatomic, assign) CGRect likeIVFrame;

/** 喜欢label */
@property (nonatomic, assign) CGRect likeLabelFrame;

@property (nonatomic, assign) CGRect dislikeIVFrame;

@property (nonatomic, assign) CGRect dislikeLabelFrame;



/**
 * 动画区域的frame
 */
@property (nonatomic, assign) CGRect animationBarFrame;

/** 高度 */
@property (nonatomic, assign) CGFloat cellHeight;


/** scrollView的frame  因为内容的高会超过collectionView  会出错  需要scrollView来包裹内容 */
@property (nonatomic, assign) CGRect  scrollViewFrame;

/** scrollView的contentSize */
@property (nonatomic, assign) CGSize contentSize;


@property (nonatomic, strong) LBNHHomeServiceDataElement *element;

@end
