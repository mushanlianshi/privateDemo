//
//  LBCustomSearchHistoryView.m
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomSearchHistoryView.h"

@interface LBCustomSearchHistoryView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LBCustomSearchHistoryView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView.backgroundView = [UIView new];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

-(void)setContentsArray:(NSArray *)contentsArray{
    _contentsArray = contentsArray;
    [self.tableView reloadData];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.contentsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"contentCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contentCell"];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = self.contentsArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismiss];
    NSString *content = self.contentsArray[indexPath.row];
    if (self.searchContent) {
        self.searchContent(content);
    }
}


-(void)showWithHeight:(CGFloat)height upView:(UIView *)upView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect textFiledFrame = [upView.superview convertRect:upView.frame toView:window];
    self.frame = CGRectMake(textFiledFrame.origin.x, CGRectGetMaxY(textFiledFrame), textFiledFrame.size.width, height);
    [window addSubview:self];
}
/** 消失 */
-(void)dismiss{
    [self removeFromSuperview];
}

@end
