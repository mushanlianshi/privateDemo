//
//  LBNHHomeVideoCoverImageView.h
//  nhExample
//
//  Created by liubin on 17/3/17.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseImageView.h"



/**
 *  视频缩略图显示的ImageView  中间有个播放按钮
 */
@interface LBNHHomeVideoCoverImageView : LBNHBaseImageView

@property (nonatomic, copy) void(^LBNHHomeVideoPlayButtonHandler)(UIButton *playButton);

@end
