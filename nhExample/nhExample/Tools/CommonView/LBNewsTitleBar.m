//
//  LBNewsTitleBar.m
//  LBSamples
//
//  Created by liubin on 17/2/24.
//  Copyright © 2017年 liubin. All rights reserved.
//

#define normalFont [UIFont systemFontOfSize:15]
#define normalColor [UIColor blackColor]
#define selectedFont [UIFont systemFontOfSize:16]
//#define selectedColor [UIColor redColor]
#define selectedColor kCommonHighLightRedColor

#import "LBNewsTitleBar.h"
#import "NSString+Size.h"
static const float kItemWidth =60;
static const float kNewsTitleBarHeight =30;
static const NSUInteger kItemStartTag =1000;

@interface LBNewsTitleBar()<UIScrollViewDelegate>

@property (nonatomic, copy)   NSArray *titlesArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSUInteger lastSelectedIndex;
@end


@implementation LBNewsTitleBar

-(instancetype)initWithTitles:(NSArray *)titles{
    self=[super init];
    if (self) {
        _titlesArray=titles;
        NSAssert(_titlesArray, @"_titlesArray 标题是nil 创建控件失败");
        if (_titlesArray) {
            [self initSubViews];
        }
    }
    return self;
}

-(void)initSubViews{
//    [self showBorderWithRedColor];
    //用来计算当item比较少的时候  不够一屏 重设间隔
    NSString *totalString = @"";
    for (NSString *str in _titlesArray) {
        totalString = [totalString stringByAppendingString:str];
    }
    CGFloat width = [totalString widhtWithLimitHeight:25 fontSize:[normalFont pointSize]];
    CGFloat marginCal = (kScreenWidth - width)/(_titlesArray.count +1);
    
    
    self.bounds=CGRectMake(0, 0, kScreenWidth, kNewsTitleBarHeight);
    _lastSelectedIndex=0;
    UIButton *lastButton;
    CGFloat margin = 20;
    margin = marginCal > margin ? marginCal : margin;
    
    for (int i=0;i<_titlesArray.count;i++){
        UIButton *button=[[UIButton alloc] init];
        button.tag=i+kItemStartTag;
        [button setTitle:_titlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
        button.titleLabel.font=normalFont;
        [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        //        button.frame=CGRectMake(i*kItemWidth, 0, kItemWidth, kNewsTitleBarHeight);
//        if (i == 0) {
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.scrollView).offset(margin);
//                make.top.bottom.equalTo(self.scrollView);
//            }];
//        }else if (i == _titlesArray.count - 1){
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(lastButton.mas_right).offset(margin);
//                make.top.bottom.equalTo(lastButton);
//                make.right.equalTo(self.scrollView).offset(-margin);
//            }];
//        }else{
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(lastButton.mas_right).offset(margin);
//                make.top.bottom.equalTo(lastButton);
//            }];
//        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastButton?lastButton.mas_right:button.superview.mas_left).offset(margin);
            //2.最后一个特殊处理
            if (i==_titlesArray.count - 1) {
                make.right.equalTo(button.superview).offset(-margin);;
            }
            make.centerY.equalTo(button.superview);
            make.height.equalTo(button.superview);
        }];
        
        lastButton = button;
    }
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
//    _scrollView.contentSize=CGSizeMake(kItemWidth*_titlesArray.count, kNewsTitleBarHeight);
    //默认选中第一个
    [self setSelectedIndex:0];
}

-(void)itemClicked:(UIButton *)button{
    if (button.isSelected)
        return;
    //1.设置上次选中的按钮状态取消  字体大小改回去
    UIButton *lastButton=[self.scrollView viewWithTag:_lastSelectedIndex+kItemStartTag];
    lastButton.selected=NO;
    lastButton.titleLabel.font=normalFont;
    //2.设置现在选中的按钮的状态
    button.selected=YES;
    button.titleLabel.font=selectedFont;
    _lastSelectedIndex=button.tag-kItemStartTag;
    if (self.itemBlock) {
        self.itemBlock(_lastSelectedIndex);
    }
    [self setItemToCenter:button];
}


/**
 * 调整位置居中
 */
-(void)setItemToCenter:(UIButton *)button{
    CGFloat offsetX = button.centerX - self.scrollView.width*0.5;
    //在中间的左边 不移动
    if (offsetX<0) {
        offsetX = 0;
    }
    //处理最大偏移量  最右边内容离最右边距离比较短的 移动不了的
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.width;
    if (offsetX>maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

#pragma mark 设置默认选中的索引
-(void)setSelectedIndex:(NSUInteger)index{
    UIButton *button=[self.scrollView viewWithTag:index+kItemStartTag];
    [self itemClicked:button];
}
#pragma mark 懒加载
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc] init];
//        _scrollView.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        NSLog(@"LBLog _scrollview frame is %@ ",NSStringFromCGRect(_scrollView.frame));
        _scrollView.delegate=self;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.bounces=NO;
//        [_scrollView showBorderWithBlueColor];
        _scrollView.pagingEnabled=NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    
}
@end
