//
//  LBNHFansAndAttentionController.h
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBaseViewController.h"

typedef NS_ENUM(NSInteger, LBAttentionAndFansType){
    LBAttentionAndFansTypeAttention = 0, //关注
    LBAttentionAndFansTypeFans,     //粉丝
};

@interface LBNHFansAndAttentionController : LBBaseViewController

-(instancetype)initWithUserId:(NSInteger)userID attentionType:(LBAttentionAndFansType)type;

@end
