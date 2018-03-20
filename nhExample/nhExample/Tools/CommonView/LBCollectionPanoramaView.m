//
//  LBCollectionPanoramaView.m
//  nhExample
//
//  Created by liubin on 17/4/5.
//  Copyright © 2017年 liubin. All rights reserved.
//
#import "LBCollectionPanoramaView.h"


NSTimeInterval const kScrollTimeMargin = 2.f;
NSInteger   const kMaxSections = 10; //一个设置最大indexpath的section的值的  用来滑动显示时用的

@interface LBCollectionPanoramaView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation LBCollectionPanoramaView

-(void)layoutSubviews{
    self.collectionView.frame = self.bounds;
    CGFloat pagWidth = self.viewsArray.count *15;
    self.pageControl.frame = CGRectMake(self.width-pagWidth - 5, self.height-15 - 10, pagWidth, 15);
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setViewsArray:(NSArray *)viewsArray{
    _viewsArray = viewsArray;
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = viewsArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:_pageControl];
    
    //设置collectionView默认显示中间那组
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:kMaxSections/2];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self.collectionView reloadData];
    [self bringSubviewToFront:_pageControl];
    [self addTimer];
}

/** 添加定时器  默认滚动无线轮播的 */
-(void)addTimer{
    self.timer = [NSTimer timerWithTimeInterval:kScrollTimeMargin target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


/** 重置中间组的indexpath索引 让一直使用kMaxSections/2 和比他大1的indexpath */
-(NSIndexPath *)resetMiddleIndexPath{
    //获取当前正在展示的索引
    NSIndexPath *currenIndexPath = [self.collectionView indexPathsForVisibleItems].lastObject;
    //获取中间的indexpath用来设置的
    NSIndexPath *resetMiddleIndexPath = [NSIndexPath indexPathForItem:currenIndexPath.item inSection:kMaxSections/2];
    //设置显示中间的sections
    [self.collectionView scrollToItemAtIndexPath:resetMiddleIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    return resetMiddleIndexPath;
}
-(void)nextPage{
    NSIndexPath *currentIndexPath = [self resetMiddleIndexPath];
    //计算下组显示的内容
    NSInteger nextItem = currentIndexPath.item + 1;
    NSInteger nextSection = currentIndexPath.section;
    //如果滚到当前section最后一个 切换到下组第一个显示
    if(currentIndexPath.item == self.viewsArray.count-1){
        nextItem = 0;
        nextSection ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

/** 手拖动的时候  移除定时器 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

/** 手停止拖动的时候开始定时器 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}


#pragma mark colletionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView{
    return nil;
}
/** 设置layout的delegate 的每个item的大小 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.collectionView.size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //1.创建collectionView的约束
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        //2.设置约束条件
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) collectionViewLayout:layout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = NO;
        //3.注册colletionview重复利用的对象
//        [_collectionView registerClass:[LBNHCheckCell class] forCellWithReuseIdentifier:@"LBNHCheckCell"];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

@end
