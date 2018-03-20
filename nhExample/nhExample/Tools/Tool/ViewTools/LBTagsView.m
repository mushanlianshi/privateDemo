//
//  LBTagsView.m
//  nhExample
//
//  Created by baletu on 2017/7/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBTagsView.h"

/** 默认item的高为20 */
static CGFloat const kItemHeight = 20;
/** item的开始tag */
static NSInteger const kItemStartTag = 100;
/** 标签的文字大小 */
static NSInteger const kTagFontSize = 12;

/** 两个item 左右之间的间距 */
static CGFloat const kItemMargin = 10;

/** item上下方向的间距 */
static CGFloat const kItemTopMargin = 15;

/** 字体两边的间距 */
static CGFloat const kItemInsetMargin = 10;

@interface LBTagsView ()

@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,strong) UIColor *tagBackgroundColor;

//@property (nonatomic,copy) NSArray *tagsTitle;

@end


@implementation LBTagsView

-(instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor tagBackgroundColor:(UIColor *)tagBackgroundColor{
    return [self initWithFrame:frame tagsTitle:nil titleColor:titleColor tagBackgroundColor:tagBackgroundColor];
}

-(instancetype)initWithFrame:(CGRect)frame tagsTitle:(NSArray *)tagsTitle titleColor:(UIColor *)titleColor tagBackgroundColor:(UIColor *)tagBackgroundColor{
    self = [super initWithFrame:frame];
    if (self) {
        _tagsTitle = tagsTitle;
        _titleColor = titleColor;
        _tagBackgroundColor = tagBackgroundColor;
        [self configUI];
    }
    return self;
}


-(void)setTagsTitle:(NSArray *)tagsTitle{
    if (_tagsTitle == tagsTitle) return;
    _tagsTitle = tagsTitle;
    [self configUI];
}

-(void)configUI{
    if (!_tagsTitle.count) return;
    CGFloat width = self.frame.size.width;
    CGFloat height = 0;
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    for (int i=0 ; i < _tagsTitle.count ; i++) {
        NSString *title = _tagsTitle[i];
        if (!title || title.length ==0 || (![title isKindOfClass:[NSString class]])) continue;
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:kTagFontSize];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:_titleColor forState:UIControlStateNormal];
        button.backgroundColor = _tagBackgroundColor;
        button.tag = i;
        [self addSubview:button];
        CGFloat itemW = [self widthForString:title limitHeight:kItemHeight font:button.titleLabel.font] + kItemInsetMargin;
        if (itemX + itemW + kItemMargin < width) {
            button.frame = CGRectMake(itemX, itemY, itemW, kItemHeight);
            itemX += itemW  + kItemMargin;
        }else{
            itemY += kItemHeight + kItemTopMargin;
            itemX = 0;
            button.frame = CGRectMake(itemX, itemY, itemW, kItemHeight);
            itemX += itemW + kItemMargin;
        }
        height = itemY + kItemHeight;
    }
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


#pragma mark 标签的点击事件
-(void)itemClicked:(UIButton *)button{
    NSLog(@"LBLog item clicked : index %zd",button.tag);
    if (self.itemBlock) {
        self.itemBlock(button.tag, self);
    }
}

-(CGFloat) widthForString:(NSString *)title limitHeight:(CGFloat)limitHeight font:(UIFont *)font{
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, limitHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil];
    return rect.size.width + 2;
    
}

@end
