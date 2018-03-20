//
//  LBPublishPictureViewCell.m
//  nhExample
//
//  Created by liubin on 17/3/29.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBPublishPictureViewCell.h"
#import "LBButtonUtils.h"
#import "UIView+LBTap.h"
@interface LBPublishPictureViewCell()

@property (nonatomic, strong) UIImageView *imageView;

/** 删除的按钮 */
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, assign) BOOL isRemoveDel;
@end

@implementation LBPublishPictureViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        [self showBlueBorder];
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

/** 计算按钮位置 */
-(void)layoutSubviews{
    [super layoutSubviews];
    //是否显示删除按钮
    if (!_isRemoveDel) {
        CGFloat delW = self.deleteBtn.currentImage.size.width;
        CGFloat delH = self.deleteBtn.currentImage.size.height;
        self.deleteBtn.frame = CGRectMake(self.width-delW, 0, delW, delH);
        
        CGFloat margin = 2.5;
        CGFloat imgW = self.width -2 *margin;
        CGFloat imgH = self.height - 2*margin;
        self.imageView.frame = CGRectMake(margin, margin, imgW, imgH);
    }
    //最后一个按钮的大小减小点
    else{
        self.x = self.x +2.5;
        self.y = self.y +2.5;
        self.imageView.frame = self.bounds;
    }

    
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [LBButtonUtils creatButtonImage:@"publish_delete" title:nil addTarget:self selector:@selector(deleteButtonClicked:) FontSize:0];
        [self.contentView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        WS(weakSelf);
        [_imageView addTapBlock:^{
            if ([weakSelf.delegate respondsToSelector:@selector(pictureCell:isDeleteBtnClicked:)]) {
                [weakSelf.delegate pictureCell:weakSelf isDeleteBtnClicked:NO];
            }
        }];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

-(void)removeDeleteBtn{
    _isRemoveDel = YES;
}


-(void)deleteButtonClicked:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(pictureCell:isDeleteBtnClicked:)]) {
        [self.delegate pictureCell:self isDeleteBtnClicked:YES];
    }
}

@end
