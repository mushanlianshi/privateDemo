//
//  LBBaseTableViewController.m
//  nhExample
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBaseTableViewController.h"
#import "LBNHBaseTableView.h"
#import "LBViewUtils.h"
#import "UIView+LBTap.h"
#import "UIView+LBLayer.h"
#import <objc/runtime.h>
#import "YYFPSLabel.h"


//左右naviItem的key
static const char LBNHBaseTableControllLeftHandlerKey;
static const char LBNHBaseTableControllRightHandlerKey;

@interface LBBaseTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *refreshImage;



@end

@implementation LBBaseTableViewController

@synthesize needCellSepLine = _needCellSepLine;
@synthesize sepLineColor = _sepLineColor;
@synthesize navItemTitle = _navItemTitle;
@synthesize barStyle = _barStyle;
@synthesize hiddenStatusBar = _hiddenStatusBar;


- (void)viewDidLoad {
    [super viewDidLoad];
    //自动计算Controller的view的大小  去掉navibar的高度和tabbar的高度
    [self.navigationController.navigationBar setTranslucent:NO];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    YYFPSLabel *fpsLabel = [window viewWithTag:1011];
    
    if (!fpsLabel) {
        fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(kScreenWidth -  80, kNavibarHeight+30, 60, 30)];
        fpsLabel.tag = 1011;
        fpsLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [window addSubview:fpsLabel];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 加载一些属性

-(LBNHBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[LBNHBaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = kSeparatorColor;
//        _tableView.estimatedRowHeight = 200;
//        _tableView.rowHeight=UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return _dataArray;
}


#pragma mark 一些设置的属性
-(void)setRefreshType:(LBBaseTableControllRefreshType)refreshType{
    switch (refreshType) {
        case LBBaseTableControllRefreshTypeNone:
            
            break;
        case LBBaseTableControllRefreshTypeRefresh:
            [self lb_addRefresh];
            break;
        case LBBaseTableControllRefreshTypeLoadMore:
            [self lb_addLoadMore];
            break;
        case LBBaseTableControllRefreshTypeBoth:
            [self lb_addRefresh];
            [self lb_addLoadMore];
            break;
            
        default:
            break;
    }
}

/** 添加下拉刷新 */
-(void)lb_addRefresh{
    WS(weakSelf);
    [LBViewUtils addPullRefreshToScrollView:self.tableView pullRefreshHandler:^{
        //1.    子类实现的方法
        [weakSelf lb_refresh];
    }];
}


/** 添加上啦加载 */
-(void)lb_addLoadMore{
    WS(weakSelf);
    [LBViewUtils addPushLoadMoreToScrollView:self.tableView loadMoreHandler:^{
        [weakSelf lb_loadMore];
    }];
}

#pragma mark 刷新 加载方法  记录上次操作是刷新还是加载
-(void)lb_refresh{
    //如果设置的状态是不可以或则只能加载更多的  返回
    if (self.refreshType == LBBaseTableControllRefreshTypeNone || self.refreshType == LBBaseTableControllRefreshTypeLoadMore) {
        return;
    }
    //记录上次是刷新还是加载的标示
    self.isRefresh = YES;
    self.isLoadMore = NO;
}

-(void)lb_loadMore{
    if (self.refreshType == LBBaseTableControllRefreshTypeNone || self.refreshType == LBBaseTableControllRefreshTypeRefresh) {
        return;
    }
    //如果上次刷新数据没有 只能刷新  加载更多不行
    if (self.dataArray.count == 0) {
        return;
    }
    self.isRefresh = NO;
    self.isLoadMore = YES;
}

-(void)setNavItemTitle:(NSString *)navItemTitle{
    if (navItemTitle && [navItemTitle isKindOfClass:[NSString class]]) {
        _navItemTitle = navItemTitle;
        self.navigationItem.title = navItemTitle;
    }
}

-(NSString *)navItemTitle{
    return self.navigationItem.title;
}


-(UIBarButtonItem *)navRightItem{
    return self.navigationItem.rightBarButtonItem;
}


#pragma mark 状态栏设置  调用刷新  重写状态栏方法
-(void)setHiddenStatusBar:(BOOL)hiddenStatusBar{
    _hiddenStatusBar = hiddenStatusBar;
    //调用刷新状态栏方法
    [self setNeedsStatusBarAppearanceUpdate];
}

-(BOOL)hiddenStatusBar{
    return _hiddenStatusBar;
}

-(void)setBarStyle:(UIStatusBarStyle)barStyle{
    _barStyle = barStyle;
}

-(UIStatusBarStyle)barStyle{
    return _barStyle;
}

/**
* 重写系统的状态栏的隐藏方法
 */
-(BOOL)prefersStatusBarHidden{
    return _hiddenStatusBar;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return _barStyle;
}

-(void)setShowRefreshIcon:(BOOL)showRefreshIcon{
    _showRefreshIcon = showRefreshIcon;
    self.refreshImage.hidden = !showRefreshIcon;
}

-(UIImageView *)refreshImage{
    if (!_refreshImage) {
        WS(weakSelf);
        _refreshImage = [[UIImageView alloc] init];
        _refreshImage.image = ImageNamed(@"refresh");
        [self.view addSubview:_refreshImage];
        [self.view bringSubviewToFront:_refreshImage];
        [_refreshImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-15);
            make.width.height.mas_equalTo(44);
            make.bottom.equalTo(self.view).offset(-20);
        }];
        _refreshImage.layerCornerRadius = 22;
        _refreshImage.backgroundColor = [UIColor whiteColor];
        //点击的时候开始动画
        [_refreshImage addTapBlock:^{
            [weakSelf startRefreshAnimation];
            [weakSelf lb_refresh];
        }];
        
    }
    return _refreshImage;
}



/** 右下角刷新按钮的动画 */
-(void)startRefreshAnimation{
    //根据动画路径创建一个动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = 1.5;
    rotationAnimation.toValue = [NSNumber numberWithDouble:M_PI * 2.0];
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.refreshImage.layer addAnimation:rotationAnimation forKey:@"refreshAnimation"];
}

-(void)endRefreshIconAnimation{
    [self.refreshImage.layer removeAnimationForKey:@"refreshAnimation"];
}


-(void)setNeedCellSepLine:(BOOL)needCellSepLine{
    _needCellSepLine = needCellSepLine;
    self.tableView.separatorStyle = needCellSepLine ? UITableViewCellSeparatorStyleSingleLine: UITableViewCellSeparatorStyleNone;
}

-(BOOL)needCellSepLine{
    return _needCellSepLine;
}


/** 让tableView在后面 */
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    [self.view sendSubviewToBack:self.tableView];
}

-(void)setSepLineColor:(UIColor *)sepLineColor{
    _sepLineColor = sepLineColor;
    if (!self.needCellSepLine) return;//不显示  就不用设置了
    self.tableView.separatorColor = sepLineColor;
}

-(UIColor *)sepLineColor{
    return _sepLineColor;
}

#pragma mark 一些刷新操作
-(void)lb_reloadData{
    [self.tableView reloadData];
}

-(void)lb_beginRefresh{
    if (self.refreshType == LBBaseTableControllRefreshTypeBoth || self.refreshType == LBBaseTableControllRefreshTypeRefresh) {
        [self lb_refresh];
    }
}

-(void)lb_endRefresh{
    [LBViewUtils endPullRefreshScrollView:self.tableView];
}

-(void)lb_endLoadMore{
    [LBViewUtils endPushLoadMoreScrollView:self.tableView];
}

/** 隐藏刷新*/
- (void)lb_hiddenRrefresh{
    [LBViewUtils hiddenRefreshHeaderScrollView:self.tableView];
}

/** 隐藏上拉加载*/
- (void)lb_hiddenLoadMore{
    [LBViewUtils hiddenLoadMoreFooterScrollView:self.tableView];
}

/** 提示没有更多信息*/
- (void)lb_noticeNoMoreData{
    [LBViewUtils noticeNoMoreDataForScrollView:self.tableView];
}

-(BOOL)isHeaderRefreshing{
    return [LBViewUtils isHeaderRefreshScrollView:self.tableView];
}

-(BOOL)isFooterRefreshing{
    return [LBViewUtils isFooterLoadMoreScrollView:self.tableView];
}

#pragma mark tableView delegate

#pragma mark tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self respondsToSelector:@selector(lb_numberOfSections)]) {
        return [self lb_numberOfSections];
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self respondsToSelector:@selector(lb_numberOfRowsInSection:)]) {
        return [self lb_numberOfRowsInSection:section];
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(lb_cellAtIndexPath:)]) {
        return [self lb_cellAtIndexPath:indexPath];
    }
    static NSString *cellIndentifier=@"homeTableCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(lb_heightAtIndexPath:)]) {
        return [self lb_heightAtIndexPath:indexPath];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(lb_didSelectedCellAtIndexPath:tableViewCell:)]) {
        [self lb_didSelectedCellAtIndexPath:indexPath tableViewCell:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self respondsToSelector:@selector(lb_sectionHeaderHeightAtSection:)]) {
        return [self lb_sectionHeaderHeightAtSection:section];
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self respondsToSelector:@selector(lb_sectionFooterHeightAtSection:)]) {
        return [self lb_sectionFooterHeightAtSection:section];
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self respondsToSelector:@selector(lb_footerAtSection:)]) {
        return [self lb_footerAtSection:section];
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self respondsToSelector:@selector(lb_headerAtSection:)]) {
        return [self lb_headerAtSection:section];
    }
    return nil;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(lb_showHightLigthRowAtIndexPath:)]) {
        return [self lb_showHightLigthRowAtIndexPath:indexPath];
    }
    return YES;
}


/** 分组数量*/
- (NSInteger)lb_numberOfSections{
    return 1;
}

/** 某个分组的cell数量*/
- (NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    return 0;
}

/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    
}

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

/** 某个组头*/
- (UIView *)lb_headerAtSection:(NSInteger)section{
    return [UIView new];
}
/** 某个组尾*/
- (UIView *)lb_footerAtSection:(NSInteger)section{
    return [UIView new];
}

/** 某个组头高度*/
- (CGFloat)lb_sectionHeaderHeightAtSection:(NSInteger)section{
    return 0.01;
}

/** 某个组尾高度*/
- (CGFloat)lb_sectionFooterHeightAtSection:(NSInteger)section{
    return 0.01;
}

/** 分割线偏移*/
- (UIEdgeInsets)lb_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath{
    return UIEdgeInsetsZero;
}

-(BOOL)lb_showHightLigthRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark naviBar的一些设置

- (void)setRightNaviItemTitle:(NSString *)title rightHandler:(void(^)(NSString *titleString))rightHandler{
    [self lb_setNaviItemTitle:title handler:rightHandler isLeftFlag:NO];
}

-(void)setLeftNaviItemTitle:(NSString *)title leftHandler:(void (^)(NSString *))leftHandler{
    [self lb_setNaviItemTitle:title handler:leftHandler isLeftFlag:YES];
}


-(void)lb_setNaviItemTitle:(NSString *)title  handler:(void(^)(NSString *title))handler isLeftFlag:(BOOL)isLeftFlag{
    //空标题 以及没有回调  直接显示
    if (title.length == 0 || !handler) {
        if (title==nil) {
            title = @"";
        }else if ([title isKindOfClass:[NSNull class]]){
            title=@"";
        }
        if (isLeftFlag) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
        }else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
        }
    }else{
        if (isLeftFlag) {
            objc_setAssociatedObject(self, &LBNHBaseTableControllLeftHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(lb_naviLeftClicked:)];
        }else{
            objc_setAssociatedObject(self, &LBNHBaseTableControllRightHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(lb_naviRightClicked:)];
        }
    }
}

-(void)lb_naviLeftClicked:(UIBarButtonItem *)item{
    void(^leftHandler)(NSString *) = objc_getAssociatedObject(self, &LBNHBaseTableControllLeftHandlerKey);
    if (leftHandler) {
        leftHandler(item.title);
    }
}
-(void)lb_naviRightClicked:(UIBarButtonItem *)item{
    void(^rightHandler)(NSString *) = objc_getAssociatedObject(self, &LBNHBaseTableControllRightHandlerKey);
    if (rightHandler) {
        rightHandler(item.title);
    }
}



@end

