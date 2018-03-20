//
//  LBNHCheckCellFrame.m
//  nhExample
//
//  Created by liubin on 17/3/22.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHCheckCellFrame.h"
#import "LBNHHomeServiceDataModel.h"
#import "NSString+Size.h"

const NSInteger kLeftMaring = 16 ;
const NSInteger kCheckCol = 3;
@interface LBNHCheckCellFrame ()

@end

@implementation LBNHCheckCellFrame

-(void)setElement:(LBNHHomeServiceDataElement *)element{
    if (!element || element == _element || element.group == nil ) {
        return;
    }
    _element = element;
    LBNHHomeServiceDataElementGroup *group = element.group;
    
    CGFloat titleX = kLeftMaring;
    CGFloat titleY = kLeftMaring;
    CGFloat titleW = kScreenWidth - 2*kLeftMaring;
    CGFloat titleH = [group.content heightWithLimitWidth:titleW fontSize:15];
    self.titleFrame = CGRectMake(titleX, titleY, titleW, titleH);
    if (group.content.length == 0) {
        titleY = 0.5 *kLeftMaring;
    }
    
    CGFloat reportY = CGRectGetMaxY(self.titleFrame) + kLeftMaring;
    
    switch (group.media_type) {
        case LBNHHomeServiceDataMediaTypeLargeImage:
            {
                CGFloat largeX = titleX;
                CGFloat largeY = CGRectGetMaxY(self.titleFrame)+10;
                CGFloat largeW = kScreenWidth - 2*kLeftMaring;
                CGFloat largeH = largeW * group.large_image.r_height/group.large_image.r_width;
                self.largeFrame = CGRectMake(largeX, largeY, largeW, largeH);
                reportY = CGRectGetMaxY(self.largeFrame) + 10;
            }
            break;
        case LBNHHomeServiceDataMediaTypeGif:
        {
            CGFloat gifX = titleX;
            CGFloat gifY = CGRectGetMaxY(self.titleFrame)+10;
            CGFloat gifW = kScreenWidth - 2*kLeftMaring;
            CGFloat gifH = gifW * group.large_image.r_height/group.large_image.r_width;
            self.gifFrame = CGRectMake(gifX, gifY, gifW, gifH);
            reportY = CGRectGetMaxY(self.gifFrame) + 10;
        }
            break;
        case LBNHHomeServiceDataMediaTypeVideo:
        {
            CGFloat videoX = titleX;
            CGFloat videoY = CGRectGetMaxY(self.titleFrame)+10;
            CGFloat videoW = kScreenWidth - 2*kLeftMaring;
            CGFloat videoH = videoW * group.video_720P.height/group.video_720P.width;
            self.videoCoverFrame = CGRectMake(videoX, videoY, videoW, videoH);
            reportY = CGRectGetMaxY(self.videoCoverFrame) + 10;
        }
            break;
        case LBNHHomeServiceDataMediaTypeLittleImages:
        {
            for (int i=0; i<group.large_image_list.count; i++) {
                CGFloat littleW = (kScreenWidth - 2*kLeftMaring - (kCheckCol-1)*10)/group.large_image_list.count;
                CGFloat littleH = littleW;
                NSInteger row = i/kCheckCol;
                NSInteger col = i%kCheckCol;
                CGFloat littleX = col*(littleW +10);
                CGFloat littleY = row*(littleH +10);
                CGRect littleFrame = CGRectMake(littleX, littleY, littleW, littleH);
                [self.littleFrames addObject:NSStringFromCGRect(littleFrame)];
                reportY = CGRectGetMaxY(littleFrame)+10;
            }
        }
            break;
        default:
            break;
    }
    
    CGFloat reportX= titleX;
    CGFloat reportW = 50;
    CGFloat reportH = 30;
    self.reportFrame = CGRectMake(reportX, reportY, reportW, reportH);
    
    //白色区域
    CGFloat whiteX= 0;
    CGFloat whiteY = 0;
    CGFloat whiteW = kScreenWidth;
    CGFloat whiteH = CGRectGetMaxY(self.reportFrame) + 10;
    self.whiteBackFrame = CGRectMake(whiteX, whiteY, whiteW, whiteH);
    
    CGFloat grayY = CGRectGetMaxY(self.reportFrame);
    
    CGFloat likeX= kLeftMaring;
    CGFloat likeY = CGRectGetMaxY(self.whiteBackFrame) + 10;
    CGFloat likeW = 50;
    CGFloat likeH = 50;
    self.likeIVFrame = CGRectMake(likeX, likeY, likeW, likeH);
    
    CGFloat likeLX= kLeftMaring;
    CGFloat likeLY = CGRectGetMaxY(self.likeIVFrame) + 5;
    CGFloat likeLW = 50;
    CGFloat likeLH = 20;
    self.likeLabelFrame = CGRectMake(likeLX, likeLY, likeLW, likeLH);
    
    CGFloat dislikeX= kScreenWidth - kLeftMaring - 50;
    CGFloat dislikeY = likeY;
    CGFloat dislikeW = 50;
    CGFloat dislikeH = 50;
    self.dislikeIVFrame = CGRectMake(dislikeX, dislikeY, dislikeW, dislikeH);
    
    CGFloat dislikeLX= dislikeX;
    CGFloat dislikeLY = CGRectGetMaxY(self.dislikeIVFrame) + 5;
    CGFloat dislikeLW = 50;
    CGFloat dislikeLH = 20;
    self.dislikeLabelFrame = CGRectMake(dislikeLX, dislikeLY, dislikeLW, dislikeLH);
    
    CGFloat barX= CGRectGetMaxX(self.likeIVFrame)+10;
    CGFloat barY = likeY;
    CGFloat barW = kScreenWidth - barX * 2;
    CGFloat barH = likeH;
    self.animationBarFrame = CGRectMake(barX, barY, barW, barH);
    
    
    CGFloat scrollX= 0;
    CGFloat scrollY = 0;
    CGFloat scrollW = kScreenWidth;
    CGFloat scrollH = kScreenHeight - kNavibarHeight - kTabbarHeight;
    self.scrollViewFrame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
    
    self.cellHeight = scrollH;
    
    self.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(self.likeLabelFrame)+10);
    
}

-(NSMutableArray *)littleFrames{
    if (_littleFrames) {
        _littleFrames = [NSMutableArray new];
    }
    return _littleFrames;
}

@end
