//
//  LBNHDiscoverHotHeaderView.m
//  nhExample
//
//  Created by liubin on 17/4/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHDiscoverHotHeaderView.h"
#import "LBNHDiscoveryModel.h"
#import "LBNHDiscoveryHotHeaderCell.h"
#import "LBCustomPageControl.h"

NSTimeInterval const kHotScrollTimeMargin = 5.f;
NSInteger   const kHotMaxSections = 100; //一个设置最大indexpath的section的值的  用来滑动显示时用的 大一点是为了避免手动滑完了

@interface LBNHDiscoverHotHeaderView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) LBCustomPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LBNHDiscoverHotHeaderView

-(void)layoutSubviews{
    self.collectionView.frame = self.bounds;
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setModelsArray:(NSArray *)modelsArray{
    _modelsArray = modelsArray;
    if (modelsArray.count == 1) {
        //如果是1 我们默认显示两个
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:modelsArray];
        [array addObjectsFromArray:_modelsArray];
        _modelsArray = array.copy;
    }
    if (!_modelsArray.count) return;
    self.pageControl = [LBCustomPageControl pageControl];
    CGFloat pagWidth = self.modelsArray.count *(20 +5);
    self.pageControl.frame = CGRectMake(self.width-pagWidth - 10, self.height-20, pagWidth, 20);
    self.pageControl.numberOfItems = _modelsArray.count;
    [self addSubview:_pageControl];
    
    [self addTimer];
    
    [self.collectionView reloadData];
    //设置collectionView默认显示中间那组
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:kHotMaxSections/2];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self.collectionView reloadData];
    [self bringSubviewToFront:_pageControl];
    
    
}

/** 添加定时器  默认滚动无线轮播的 */
-(void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kHotScrollTimeMargin target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
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
    NSIndexPath *resetMiddleIndexPath = [NSIndexPath indexPathForItem:currenIndexPath.item inSection:kHotMaxSections/2];
    //设置显示中间的sections 不要动画
    [self.collectionView scrollToItemAtIndexPath:resetMiddleIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    return resetMiddleIndexPath;
}
-(void)nextPage{
    NSIndexPath *currentIndexPath = [self resetMiddleIndexPath];
    //计算下组显示的内容
    NSInteger nextItem = currentIndexPath.item + 1;
    NSInteger nextSection = currentIndexPath.section;
    //如果滚到当前section最后一个 切换到下组第一个显示
    if(currentIndexPath.item == self.modelsArray.count-1){
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

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    //这里特殊处理下 因为sections比较多
//    NSInteger index = (NSInteger)(scrollView.contentOffset.x / (self.width+0.5))%self.modelsArray.count;
//    self.pageControl.currentIndex = index;
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //这里特殊处理下 因为sections比较多
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / scrollView.width +0.5)%self.modelsArray.count;
    self.pageControl.currentIndex = index;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark colletionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelsArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return kHotMaxSections;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    LBNHDiscoveryRotate_bannerElement *element = self.modelsArray[indexPath.row];
    LBNHDiscoveryRotate_bannerElement_urlModel_Url *urlModel = element.banner_url.url_list.firstObject;
    LBNHDiscoveryHotHeaderCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"LBNHDiscoveryHotHeaderCell" forIndexPath:indexPath];
    cell.title = element.banner_url.title;
    cell.imageUrl = urlModel.url;
    return cell;
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
        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.scrollEnabled = NO;
        //3.注册colletionview重复利用的对象
        [_collectionView registerClass:[LBNHDiscoveryHotHeaderCell class] forCellWithReuseIdentifier:@"LBNHDiscoveryHotHeaderCell"];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

@end
