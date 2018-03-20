//
//  LBCustomTableViewSheet.h
//  nhExample
//
//  Created by liubin on 17/5/9.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 自定义sheet  可以用来actionSheet的title样式的
 * 用tableView实现的
 */
@interface LBCustomTableViewSheet : UIView


/**
 *

 @param titleView 自定义的titleView
 @param optionsArray 选项的titles
 @param optionsBlock 选项的回调 index索引
 @param cancelTitle 取消的title
 @param cancelBlock  取消的回调
 @return 对象
 */
-(instancetype)initWithTitleView:(UIView *)titleView optionsArray:(NSArray *)optionsArray optionsBlock:(void(^)(NSInteger index))optionsBlock cancelTitle:(NSString *)cancelTitle cancelBlock:(dispatch_block_t)cancelBlock;


-(void)show;
-(void)dismiss;
@end
