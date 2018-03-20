//
//  LBCustomTableViewSheet.m
//  nhExample
//
//  Created by liubin on 17/5/9.
//  Copyright © 2017年 liubin. All rights reserved.
//

#define kBackgroundColor [[UIColor blackColor] colorWithAlphaComponent:0.5];

static CGFloat kCornerRaduis = 10.f;
static CGFloat kSpace = 10.f;
static CGFloat kFooterHeight = 7.f;
static NSString * const kActionSheetCell = @"kActionSheetCell";
static NSTimeInterval kAnimationDuration = 0.2;

#import "LBCustomTableViewSheet.h"

@interface LBCustomTableViewSheet ()<UITableViewDelegate, UITableViewDataSource>

/** 背景view */
@property (nonatomic, strong) UIView *maskView;

/**  自定义titleView  tableview的headerView*/
@property (nonatomic, strong) UIView *titleView;

/** 选项view */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *optionsArray;

@property (nonatomic, copy) NSString *cancelTitle;

@property (nonatomic, copy) void(^optionsBlock)(NSInteger index);

@property (nonatomic, copy) dispatch_block_t cancelBlock;

@end

@implementation LBCustomTableViewSheet

-(instancetype)initWithTitleView:(UIView *)titleView optionsArray:(NSArray *)optionsArray optionsBlock:(void (^)(NSInteger))optionsBlock cancelTitle:(NSString *)cancelTitle cancelBlock:(dispatch_block_t)cancelBlock{
    self = [super init];
    if (self) {
        _titleView = titleView;
        _optionsArray = optionsArray;
        _optionsBlock = optionsBlock;
        _cancelBlock = cancelBlock;
        _cancelTitle = cancelTitle;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
}

-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = kBackgroundColor;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.layer.cornerRadius = kCornerRaduis;
        _tableView.layer.masksToBounds = NO;
        _tableView.clipsToBounds = YES;
        _tableView.tableHeaderView = self.titleView;
        _tableView.bounces = NO;
        _tableView.rowHeight = 44;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kActionSheetCell];
        //        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
    }
    return _tableView;
}
#pragma mark tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.optionsArray.count;
    }else if (section == 1){
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kActionSheetCell];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kActionSheetCell];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.optionsArray[indexPath.row];
        //最后一个 下面的两个角有弧度
        if (indexPath.row == self.optionsArray.count-1) {
            CGRect rect = CGRectMake(0, 0, kScreenWidth - 2*kSpace, tableView.rowHeight);
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(kCornerRaduis, kCornerRaduis)];
            
            CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
            shapLayer.path = bezierPath.CGPath;
            shapLayer.frame = cell.contentView.bounds;
            //用maskLayer来显示
            cell.layer.mask = shapLayer;
            
//            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.backgroundColor = [UIColor clearColor];
//            cell.layer.backgroundColor = [UIColor whiteColor].CGColor;
//            cell.layer.cornerRadius = 10;
//            cell.layer.masksToBounds = NO;
//            cell.layer.shouldRasterize = YES;
            
            //第二种加一个layer的形式  不过这种需要背景色透明 切把layer放到最下面 别遮住别的控件
//            shapLayer.fillColor = [UIColor whiteColor].CGColor;
//            shapLayer.strokeColor = [UIColor whiteColor].CGColor;
//            cell.layer.masksToBounds = YES;
//            cell.backgroundColor = [UIColor clearColor];
//            [cell.layer addSublayer:shapLayer];
//            [cell.layer insertSublayer:shapLayer atIndex:0];
            
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = self.cancelTitle;
        cell.layer.cornerRadius = kCornerRaduis;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.optionsBlock) {
            self.optionsBlock(indexPath.row);
        }
    }else if (indexPath.section == 1){
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
    [self dismiss];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kFooterHeight;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)show{
    //tableView 现在外面在移进去
    self.tableView.frame = CGRectMake(kSpace, kScreenHeight, kScreenWidth - 2 * kSpace, self.titleView.height + (self.optionsArray.count +1)*self.tableView.rowHeight + 2 * kFooterHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        CGRect frame = self.tableView.frame;
        frame.origin.y -=self.tableView.height;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)dismiss{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        CGRect frame = self.tableView.frame;
        frame.origin.y =kScreenHeight;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/** 点击了 消失actionSheet */
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

@end
