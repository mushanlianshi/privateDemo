//
//  LBNHHomeVideoCoverImageView.m
//  nhExample
//
//  Created by liubin on 17/3/17.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomeVideoCoverImageView.h"

@interface LBNHHomeVideoCoverImageView()

@property (nonatomic, strong) UIButton *playButton;

@end

@implementation LBNHHomeVideoCoverImageView

-(instancetype)init{
    self=[super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.playButton = [[UIButton alloc] init];
        [self addSubview:self.playButton];
        [self.playButton setImage:ImageNamed(@"play") forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(44);
        }];
    }
    return self;
}

-(void)playButtonClicked:(UIButton *)button{
    if (self.LBNHHomeVideoPlayButtonHandler) {
        self.LBNHHomeVideoPlayButtonHandler(button);
    }
}



@end
