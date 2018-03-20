//
//  LBNHBaseTableView.h
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 动画的类型
 */
typedef NS_ENUM(NSInteger, LBNHTableViewRowAnimation){
    LBNHTableViewRowAnimationFade = UITableViewRowAnimationFade ,
    LBNHTableViewRowAnimationRight = UITableViewRowAnimationRight ,
    LBNHTableViewRowAnimationLeft = UITableViewRowAnimationLeft ,
    LBNHTableViewRowAnimationTop = UITableViewRowAnimationTop ,
    LBNHTableViewRowAnimationBottom = UITableViewRowAnimationBottom ,
    LBNHTableViewRowAnimationNone = UITableViewRowAnimationNone ,
    LBNHTableViewRowAnimationMiddle = UITableViewRowAnimationMiddle ,
    LBNHTableViewRowAnimationAutomatic = UITableViewRowAnimationAutomatic ,
};

/**
 基础的tableView类  提供我们经常用到的一些方法
 */
@interface LBNHBaseTableView : UITableView


/**
 在block中更新tableview
 */
-(void)lb_updateWithBlock:(void (^)(LBNHBaseTableView *tableView))updateBlock;

/** 注册cell */
-(void)lb_registerCellClass:(Class)cellClass identifier:(NSString *)identifier;

-(void)lb_registerHeaderFooterClass:(Class)headerFooterClass identifiere:(NSString *)idenfitier;


/** 注册一个从xib中加载的UITableViewCell*/
- (void)lb_registerCellNib:(Class)cellNib nibIdentifier:(NSString *)nibIdentifier;

/** 注册一个普通的UITableViewHeaderFooterView*/
- (void)lb_registerHeaderFooterClass:(Class)headerFooterClass identifier:(NSString *)identifier;

/** 注册一个从xib中加载的UITableViewHeaderFooterView*/
- (void)lb_registerHeaderFooterNib:(Class)headerFooterNib nibIdentifier:(NSString *)nibIdentifier;



#pragma mark - 只对已经存在的cell进行刷新，没有类似于系统的 如果行不存在，默认insert操作
/** 刷新单行、动画默认*/
- (void)lb_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 刷新单行、动画默认*/
- (void)lb_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBNHTableViewRowAnimation)animation;

/** 刷新多行、动画默认*/
- (void)lb_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 刷新多行、动画默认*/
- (void)lb_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBNHTableViewRowAnimation)animation;

/** 刷新某个section、动画默认*/
- (void)lb_reloadSingleSection:(NSInteger)section;

/** 刷新某个section、动画自定义*/
- (void)lb_reloadSingleSection:(NSInteger)section animation:(LBNHTableViewRowAnimation)animation;

/** 刷新多个section、动画默认*/
- (void)lb_reloadSections:(NSArray <NSNumber *>*)sections;

/** 刷新多个section、动画自定义*/
- (void)lb_reloadSections:(NSArray <NSNumber *>*)sections animation:(LBNHTableViewRowAnimation)animation;

#pragma mark - 对cell进行删除操作
/** 删除单行、动画默认*/
- (void)lb_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 删除单行、动画自定义*/
- (void)lb_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBNHTableViewRowAnimation)animation;

/** 删除多行、动画默认*/
- (void)lb_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 删除多行、动画自定义*/
- (void)lb_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBNHTableViewRowAnimation)animation;

/** 删除某个section、动画默认*/
- (void)lb_deleteSingleSection:(NSInteger)section;

/** 删除某个section、动画自定义*/
- (void)lb_deleteSingleSection:(NSInteger)section animation:(LBNHTableViewRowAnimation)animation;

/** 删除多个section*/
- (void)lb_deleteSections:(NSArray <NSNumber *>*)sections;

/** 删除多个section*/
- (void)lb_deleteSections:(NSArray <NSNumber *>*)sections animation:(LBNHTableViewRowAnimation)animation;

#pragma mark - 对cell进行删除操作
/** 增加单行 动画无*/
- (void)lb_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 增加单行，动画自定义*/
- (void)lb_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBNHTableViewRowAnimation)animation;

/** 增加单section，动画无*/
- (void)lb_insertSingleSection:(NSInteger)section;

/** 增加单section，动画自定义*/
- (void)lb_insertSingleSection:(NSInteger)section animation:(LBNHTableViewRowAnimation)animation;

/** 增加多行，动画无*/
- (void)lb_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 增加多行，动画自定义*/
- (void)lb_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBNHTableViewRowAnimation)animation;

/** 增加多section，动画无*/
- (void)lb_insertSections:(NSArray <NSNumber *>*)sections;

/** 增加多section，动画自定义*/
- (void)lb_insertSections:(NSArray <NSNumber *>*)sections animation:(LBNHTableViewRowAnimation)animation;
@end
