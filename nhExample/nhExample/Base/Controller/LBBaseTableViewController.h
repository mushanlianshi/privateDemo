//
//  LBBaseTableViewController.h
//  nhExample
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBaseViewController.h"
@class LBNHBaseTableView;


/**
 tableViewController 的刷新类型
 */
typedef NS_ENUM(NSInteger, LBBaseTableControllRefreshType){
    LBBaseTableControllRefreshTypeNone = 0, //不刷新不加载的
    LBBaseTableControllRefreshTypeRefresh,// 只有下拉刷新
    LBBaseTableControllRefreshTypeLoadMore,//只有上啦加载
    LBBaseTableControllRefreshTypeBoth,   //上啦加载 下拉刷新都有
};


/**
 tableViewController 的基类 在这里面提供常用的方法
 * 子类必须实现我们最下面的 tableView代理转换的方法
 */
@interface LBBaseTableViewController : LBBaseViewController

/** 刚才执行的是刷新*/
@property (nonatomic, assign) NSInteger isRefresh;

/** 刚才执行的是上拉加载*/
@property (nonatomic, assign) NSInteger isLoadMore;

/** statusBar风格*/
@property (nonatomic, assign) BOOL hiddenStatusBar;

/** statusBar风格*/
@property (nonatomic, assign) UIStatusBarStyle barStyle;

/** 导航右边Item*/
@property (nonatomic, strong) UIBarButtonItem *navRightItem;

/** 导航左边Item*/
@property (nonatomic, strong) UIBarButtonItem *navLeftItem;

/** 标题*/
@property (nonatomic, copy) NSString *navItemTitle;

@property (nonatomic, strong) LBNHBaseTableView *tableView;

/** 分割线颜色*/
@property (nonatomic, assign) UIColor *sepLineColor;

/** 数据源数量*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 加载刷新类型*/
@property (nonatomic, assign) LBBaseTableControllRefreshType refreshType;

/** 是否需要系统的cell的分割线*/
@property (nonatomic, assign) BOOL needCellSepLine;

/** 是否在下拉刷新*/
@property (nonatomic, assign, readonly) BOOL isHeaderRefreshing;

/** 是否在上拉加载*/
@property (nonatomic, assign, readonly) BOOL isFooterRefreshing;


/**
 * 是否显示右下角的刷新按钮
 */
@property (nonatomic, assign) BOOL showRefreshIcon;

@property (nonatomic, weak, readonly) UIView *refreshHeader;

/** 刷新数据*/
- (void)lb_reloadData;

/** 开始下拉*/
- (void)lb_beginRefresh;

/** 停止刷新*/
- (void)lb_endRefresh;

/** 停止上拉加载*/
- (void)lb_endLoadMore;

/** 隐藏刷新*/
- (void)lb_hiddenRrefresh;

/** 隐藏上拉加载*/
- (void)lb_hiddenLoadMore;

/** 提示没有更多信息*/
- (void)lb_noticeNoMoreData;



#pragma mark tableViewDelegate的代理方法  我们这里都有子类去实现了  需要子类复写

/** 分组数量*/
- (NSInteger)lb_numberOfSections;

/** 某个分组的cell数量*/
- (NSInteger)lb_numberOfRowsInSection:(NSInteger)section;

/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath;

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell;

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath;

/** 某个组头*/
- (UIView *)lb_headerAtSection:(NSInteger)section;

/** 某个组尾*/
- (UIView *)lb_footerAtSection:(NSInteger)section;

/** 某个组头高度*/
- (CGFloat)lb_sectionHeaderHeightAtSection:(NSInteger)section;

/** 某个组尾高度*/
- (CGFloat)lb_sectionFooterHeightAtSection:(NSInteger)section;

/** 分割线偏移*/
- (UIEdgeInsets)lb_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath;


/** 哪行可以高亮 */
-(BOOL)lb_showHightLigthRowAtIndexPath:(NSIndexPath *)indexPath;



#pragma mark - 子类去继承  子类记得super 父类的方法 我们这方法里有处理
/** 刷新方法*/
- (void)lb_refresh;

/** 上拉加载方法*/
- (void)lb_loadMore;



//需要子类在刷新数据成功后  调用 消失动画
- (void)endRefreshIconAnimation;



#pragma mark - loading & alert
- (void)nh_showLoading;

- (void)nh_hiddenLoading;

- (void)nh_showTitle:(NSString *)title after:(NSTimeInterval)after;

#pragma mark 设置naviBar的一些方法


/** 设置naviBar右边显示的文字以及回调 */
- (void)setRightNaviItemTitle:(NSString *)title rightHandler:(void(^)(NSString *titleString))rightHandler;

/** 设置naviBar坐边显示的文字以及回调 */
- (void)setLeftNaviItemTitle:(NSString *)title leftHandler:(void(^)(NSString *titleString))leftHandler;

@end
