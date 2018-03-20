//
//  LBPublishPictureView.m
//  nhExample
//
//  Created by liubin on 17/3/29.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBPublishPictureView.h"
#import "LBPublishPictureViewCell.h"

static NSString *cellId = @"cellId";
static NSString *addCellId = @"addCellId";

@interface LBPublishPictureView ()<UICollectionViewDelegate,UICollectionViewDataSource,LBPublishPictureViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;


@end


@implementation LBPublishPictureView
@synthesize imagesArray = _imagesArray;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setImagesArray:(NSMutableArray <UIImage *> *)imagesArray{
    _imagesArray = imagesArray;
    [self.collectionView reloadData];
}

-(void)addImages:(NSArray<UIImage *> *)images{
    [self.imagesArray addObjectsFromArray:images];
    [self.collectionView reloadData];
}
#pragma mark colletionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imagesArray.count == 0) {
        return 0;
    }else if (self.imagesArray.count<9){
        return self.imagesArray.count+1;//加上一个添加按钮
    }else{
        return self.imagesArray.count;//大于等于9直接返回个数
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //显示加号的cell
    if (indexPath.row == self.imagesArray.count) {
        LBPublishPictureViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell.image = ImageNamed(@"addfile");
        cell.contentView.layerBorderColor = [UIColor lightGrayColor];
        cell.contentView.layerBorderWidth = 1;
        [cell removeDeleteBtn];
        cell.delegate = self;
        return cell;
    }else{
        LBPublishPictureViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:addCellId forIndexPath:indexPath];
        cell.image = self.imagesArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    NSLog(@"self.collectionView frame is %@ ",NSStringFromCGRect(self.collectionView.frame));
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenWidth -5*4)/3;
        //item 的size
        layout.itemSize = CGSizeMake(itemW, itemW);
        //最小的竖向间距
        layout.minimumLineSpacing = 7;
        layout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 0);
        //最小的横向间距为5
        layout.minimumInteritemSpacing = 4.5;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[LBPublishPictureViewCell class] forCellWithReuseIdentifier:cellId];
        [_collectionView registerClass:[LBPublishPictureViewCell class] forCellWithReuseIdentifier:addCellId];
        [self addSubview:_collectionView];
        
    }
    return _collectionView;
}

/** cell的回调事件  ture是删除按钮的点击事件  false是图片的点击事件 */
-(void)pictureCell:(LBPublishPictureViewCell *)pictureCell isDeleteBtnClicked:(BOOL)isDeleteBtn{
    if (isDeleteBtn) {
        if (self.imagesArray.count) {
            if (self.imagesArray.count<9) {
                NSIndexPath *indexPath = [self.collectionView indexPathForCell:pictureCell];
                [self.imagesArray removeObjectAtIndex:indexPath.row-1];
                [self.collectionView reloadData];
            }
        }
    }
}

-(NSMutableArray<UIImage *> *)imagesArray{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray new];
    }
    return _imagesArray;
}

@end
