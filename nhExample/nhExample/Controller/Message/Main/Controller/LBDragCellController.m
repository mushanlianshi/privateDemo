//
//  LBDragCellController.m
//  nhExample
//
//  Created by liubin on 17/4/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBDragCellController.h"

@interface LBDragCellController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSArray *titleArray;

/** 记录开始拽动时的Y 用来判断是上移还是下移的 */
@property (nonatomic, assign) CGFloat beginY;

/** 记录开始拽动时的起点  用来判断的 */
@property (nonatomic, assign) CGPoint beginPoint;

/** 拖拽的cell */
@property (nonatomic, strong) UITableViewCell *selectCell;

/** 记录cellHeight */
@property (nonatomic, assign) CGFloat cellHeight;

/** 记录拖动的cell的indexpath */
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
/** 记录保存上次拖动的cell的indexpath */
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation LBDragCellController

- (void)viewDidLoad {
    self.navigationItem.title = @"长按拽动cell";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self.tableview action:@selector(reloadData)];
    [super viewDidLoad];
    [self initData];
    [self.tableview reloadData];
    
}

-(void)initData{
    self.dataArray = @[@"interaction",@"messageicon_profile",@"vermicelli",@"godcomment",@"interaction",@"messageicon_profile",@"vermicelli"];
    self.titleArray = @[@"商品0",@"商品1",@"商品2",@"商品3",@"商品4",@"商品5",@"商品6"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableView *)tableview{
    if (!_tableview) {
        _tableview=[[UITableView alloc] init];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        [self.view addSubview:_tableview];
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(40);
        }];
    }
    return _tableview;
}


#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"homeTableCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        UILongPressGestureRecognizer *panGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDragGesture:)];
        [cell addGestureRecognizer:panGesture];
        
    }
    cell.imageView.image = ImageNamed(self.dataArray[indexPath.row]);
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark 长按拽动事件
-(void)longPressDragGesture:(UILongPressGestureRecognizer *)longGesture{
    CGPoint point = [longGesture locationInView:self.tableview];
    MyLog(@"LBLog poin tis %@ ",NSStringFromCGPoint(point));
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        _beginPoint = point;
        self.beginY = point.y;
        self.selectCell = (UITableViewCell *)[longGesture view];
        _cellHeight = _selectCell.height;;
        _selectIndexPath = [self.tableview indexPathForCell:self.selectCell];
    }else if (longGesture.state == UIGestureRecognizerStateChanged){
        //计算需要移动的距离
//        CGFloat offsetY = point.y - _beginPoint.y;
        //-_cellHeight/2 是为了调整刚选中到时候下移一半的问题
        _selectCell.y = point.y-_cellHeight/2;
        
        //计算刚开始距离下载的位移y
        CGFloat offsetOriginalY = _selectCell.y - _beginY;
        //向下拽动大于30  交换cell
        if (offsetOriginalY>30 && _selectIndexPath.row <= self.dataArray.count-2) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectIndexPath.row +1 inSection:_selectIndexPath.section];
//            [self.tableview moveRowAtIndexPath:_selectIndexPath toIndexPath:indexPath];
            [self repleceCellModelAtIndexpath:_selectIndexPath toIndexPath:indexPath];
            //更新当前选中cell的indexpath
            _selectIndexPath = indexPath;
            //cell的位置变了  起始的y也需要变
            _beginY += _cellHeight;
            //记录最后做完交换的indexpath  当手势结束  回复到正常位置时用的
            _lastIndexPath = indexPath;
        }//向上拽动大于30  需要注意不要越界
        else if(offsetOriginalY < -30 && _selectIndexPath.row >= 1){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectIndexPath.row -1 inSection:_selectIndexPath.section];
//            [self.tableview moveRowAtIndexPath:_selectIndexPath toIndexPath:indexPath];
            [self repleceCellModelAtIndexpath:_selectIndexPath toIndexPath:indexPath];
            _selectIndexPath = indexPath;
            _beginY -= _cellHeight;
            _lastIndexPath = indexPath;
        }
//        NSLog(@"");
        //更新位置点
//        _beginPoint = point;
    }else if (longGesture.state == UIGestureRecognizerStateEnded){
        //手势结束时需要 手动处理下位置  以免不上不下的  调整位置用的
        NSIndexPath *currentIndexPath = [self.tableview indexPathForCell:_selectCell];
        [self.tableview moveRowAtIndexPath:currentIndexPath toIndexPath:_lastIndexPath];
//        [self repleceCellModelAtIndexpath:currentIndexPath toIndexPath:_lastIndexPath];
    }
}

/** 交换cell的位置  也交换数据 */
-(void)repleceCellModelAtIndexpath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath{
    [self.tableview moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    [self replaceDataOneIndex:indexPath.row twoIndex:newIndexPath.row];
}

/** 交换tableview 数据源数组中的数据  不能只是改变界面不改变modal */
-(void)replaceDataOneIndex:(NSInteger)index twoIndex:(NSInteger)twoIndex{
    id firstObject = self.dataArray[index];
    id secondObject = self.dataArray[twoIndex];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataArray];
    [array replaceObjectAtIndex:index withObject:secondObject];
    [array replaceObjectAtIndex:twoIndex withObject:firstObject];
    self.dataArray = array.copy;
}

@end
