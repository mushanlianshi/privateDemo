//
//  LBNHBaseTableView.m
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseTableView.h"

@implementation LBNHBaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //1.让底部脚view高度为0 的
        self.tableFooterView = [UIView new];
    }
    return self;
}

/**
 在block中更新tableview
 */
-(void)lb_updateWithBlock:(void (^)(LBNHBaseTableView *tableView))updateBlock{
    if(updateBlock){
        //处理批量更新的  等到endUpdates后才会更新
        [self beginUpdates];
        updateBlock(self);
        [self endUpdates];
    }
}

/** 注册cell */
-(void)lb_registerCellClass:(Class)cellClass identifier:(NSString *)identifier{
    if (cellClass && identifier.length ) {
        [self registerClass:cellClass forCellReuseIdentifier:identifier];
    }
}

-(void)lb_registerHeaderFooterClass:(Class)headerFooterClass identifiere:(NSString *)idenfitier{
    if (headerFooterClass && idenfitier.length) {
        [self registerClass:headerFooterClass forHeaderFooterViewReuseIdentifier:idenfitier];
    }
}


/** 注册一个从xib中加载的UITableViewCell*/
- (void)lb_registerCellNib:(Class)cellNib nibIdentifier:(NSString *)nibIdentifier{
    
}

/** 注册一个普通的UITableViewHeaderFooterView*/
- (void)lb_registerHeaderFooterClass:(Class)headerFooterClass identifier:(NSString *)identifier{
    
}

/** 注册一个从xib中加载的UITableViewHeaderFooterView*/
- (void)lb_registerHeaderFooterNib:(Class)headerFooterNib nibIdentifier:(NSString *)nibIdentifier{
    
}



#pragma mark - 只对已经存在的cell进行刷新，没有类似于系统的 如果行不存在，默认insert操作
/** 刷新单行、动画默认*/
- (void)lb_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

/** 刷新单行、动画默认*/
- (void)lb_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBNHTableViewRowAnimation)animation{
    
}

/** 刷新多行、动画默认*/
- (void)lb_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    
}

/** 刷新多行、动画默认*/
- (void)lb_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBNHTableViewRowAnimation)animation{
    
}

/** 刷新某个section、动画默认*/
- (void)lb_reloadSingleSection:(NSInteger)section{
    
}

/** 刷新某个section、动画自定义*/
- (void)lb_reloadSingleSection:(NSInteger)section animation:(LBNHTableViewRowAnimation)animation{
    
}

/** 刷新多个section、动画默认*/
- (void)lb_reloadSections:(NSArray <NSNumber *>*)sections{
    
}

/** 刷新多个section、动画自定义*/
- (void)lb_reloadSections:(NSArray <NSNumber *>*)sections animation:(LBNHTableViewRowAnimation)animation{
    
}

#pragma mark - 对cell进行删除操作
/** 删除单行、动画默认*/
- (void)lb_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

/** 删除单行、动画自定义*/
- (void)lb_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBNHTableViewRowAnimation)animation{
    
}

/** 删除多行、动画默认*/
- (void)lb_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    
}

/** 删除多行、动画自定义*/
- (void)lb_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBNHTableViewRowAnimation)animation{
    
}

/** 删除某个section、动画默认*/
- (void)lb_deleteSingleSection:(NSInteger)section{
    
}

/** 删除某个section、动画自定义*/
- (void)lb_deleteSingleSection:(NSInteger)section animation:(LBNHTableViewRowAnimation)animation{
    
}

/** 删除多个section*/
- (void)lb_deleteSections:(NSArray <NSNumber *>*)sections{
    
}

/** 删除多个section*/
- (void)lb_deleteSections:(NSArray <NSNumber *>*)sections animation:(LBNHTableViewRowAnimation)animation{
    
}

#pragma mark - 对cell进行插入操作
/** 增加单行 动画无*/
- (void)lb_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath{
    [self lb_insertSingleRowAtIndexPath:indexPath animation:LBNHTableViewRowAnimationNone];
}

/** 增加单行，动画自定义*/
- (void)lb_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBNHTableViewRowAnimation)animation{
    if (!indexPath.row) return;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger sectionNumbers = [self numberOfSections];
    NSInteger rowNumbers = [self numberOfRowsInSection:section];
    if (section + 1 > sectionNumbers || section < 0 ) {
        NSLog(@"LBLog error section  越界 ======");
    }else if (row +1 > rowNumbers || row < 0){
        NSLog(@"LBLog error row 越界 : %ld", row);
    }else{
        [self beginUpdates];
        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 增加单section，动画无*/
- (void)lb_insertSingleSection:(NSInteger)section{
    [self lb_insertSingleSection:section animation:LBNHTableViewRowAnimationNone];
}

/** 增加单section，动画自定义*/
- (void)lb_insertSingleSection:(NSInteger)section animation:(LBNHTableViewRowAnimation)animation{
    NSInteger sectionNumbers = self.numberOfSections;
    if (section + 1 > sectionNumbers || section <0) {
        NSLog(@"LBLog error section越界=======");
    }else{
        [self beginUpdates];
        [self insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}
/** 增加多行，动画无*/
- (void)lb_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    if (!indexPaths.count) return;
    [self lb_insertRowsAtIndexPaths:indexPaths animation:LBNHTableViewRowAnimationNone];
}

/** 增加多行，动画自定义*/
- (void)lb_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBNHTableViewRowAnimation)animation{
    if (indexPaths.count == 0) return;
    WS(weakSelf);
    if (indexPaths.count) {
        [self beginUpdates];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf lb_insertSingleRowAtIndexPath:obj animation:animation];
        }];
        [self endUpdates];
    }
}

/** 增加多section，动画无*/
- (void)lb_insertSections:(NSArray <NSNumber *>*)sections{
    [self lb_insertSections:sections animation:LBNHTableViewRowAnimationNone];
}

/** 增加多section，动画自定义*/
- (void)lb_insertSections:(NSArray <NSNumber *>*)sections animation:(LBNHTableViewRowAnimation)animation{
    if (sections.count == 0) return;
    WS(weakSelf);
    [sections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf lb_insertSingleSection:obj.integerValue animation:animation];
    }];
}

@end
