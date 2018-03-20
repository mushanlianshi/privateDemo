//
//  LBMessageViewController.m
//  LBSamples
//
//  Created by liubin on 16/11/29.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "LBMessageViewController.h"
#import "LBMessageModel.h"
#import "LBMessageCell.h"
@interface LBMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *dataSources;
    NSMutableArray *deleteArray;
    //记录是否在正在选择状态
    BOOL isSelecting;
    
    UIButton *leftButton;
}
@end

@implementation LBMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}
-(void)initUI{
    self.title=@"信息";
    //1.设置导航栏的背景颜色
    leftButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    leftButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:0.00 green:0.48 blue:1.00 alpha:1.00] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(chooseButton)];
    
//    UIImageView *imageView=[[UIImageView alloc] initWithImage:ImageNamed(@"musiccircle_square_icon")];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:ImageNamed(@"musiccircle_square_icon") style:UIBarButtonItemStyleDone target:self action:@selector(chooseButton)];
    
//    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavibarHeight) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    // 设置分割线距离左右距离为0 0
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView delegate 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"messageCell";
    LBMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[LBMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.model=dataSources[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LBMessageModel *model=dataSources[indexPath.row];
    if (model.isSelecting) {
        model.isSelected=!model.isSelected;
//        NSIndexPath *selectPath=[NSIndexPath indexPathForRow:inde inSection:<#(NSInteger)#>];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}



//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleInsert;
//}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action1=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除***" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除***========");
        LBMessageModel *model=dataSources[indexPath.row];
        [dataSources removeObject:model];
//        NSIndexSet
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//        NSMutableIndexSet *set=[[NSMutableIndexSet alloc] init];
//        [set addIndex:0];
//        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }];
    action1.backgroundColor=[UIColor lightGrayColor];
    return @[action1];
}
//实现可编辑协议  才可以左滑出现菜单界面
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"BtnClick_ %zd",indexPath.row);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)initData{
    dataSources=[[NSMutableArray alloc] init];
    deleteArray=[[NSMutableArray alloc] init];
    NSArray *array=@[@{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户集成了Facebook且使用了v2.8版本Facebook开放平台应用的用户",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"18531651998",@"content":@"你好，你的积分即将过期",@"date":@"昨天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10001",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView，在实际显示时文字宽度怎么弄都感觉少了一部分。原因就是因为我是在tableView:cellForRowAtIndexPath:中调用",@"date":@"星期二",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1093802837",@"content":@"这个时候的size还是你这个cell在StoryBoard/Xib中的设计视图中的大小。想要显示cell在屏幕上展示的实际大小",@"date":@"星期天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"7198474619",@"content":@"这帮助我解决了另一个问题，我在Cell中增加了一个DTAttributedTextContentView",@"date":@"前天",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"10086",@"content":@"修复分享WebPage类型时，URL和网络图片URL可能被截断的问题；修复Facebook API v2.8的应用在获取用户信息时的报错问",@"date":@"星期六",@"isSelecting":@(false),@"isSelected":@(false)},
                     @{@"icon":@"head",@"telephone":@"1009090",@"content":@"ShareSDK模块中的设置邮件、SMS和Google+的风格的接口移到平台的Connector模块。",@"date":@"星期三",@"isSelecting":@(false),@"isSelected":@(false)}];
    for (NSDictionary *dic in array) {
        LBMessageModel *model=[[LBMessageModel alloc] initWithDic:dic];
        [dataSources addObject:model];
    }
}


#pragma mark 导航栏处理事件
-(void)dismiss{
    //1.要删除的数组清空
    [deleteArray removeAllObjects];
    if ([leftButton.titleLabel.text isEqualToString:@"返回"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }//删除选项
    else{
        for (LBMessageModel  *model in dataSources) {
            if (model.isSelected) {
//                [dataSources removeObject:model];
                [deleteArray addObject:model];
            }
        }
        for (LBMessageModel *model in deleteArray) {
            [dataSources removeObject:model];
        }
        [_tableView reloadData];
    }
    
}
-(void)chooseButton{
    isSelecting=!isSelecting;
    if (isSelecting) {
        [leftButton setTitle:@"删除" forState:UIControlStateNormal];
        for (LBMessageModel *model in dataSources) {
            model.isSelecting=YES;
        }
    }else{
        [leftButton setTitle:@"返回" forState:UIControlStateNormal];
        for (LBMessageModel *model in dataSources) {
            model.isSelecting=NO;
        }
    }
    [_tableView reloadData];
}

-(void)dealloc{
    NSLog(@"LBmessage Viewcontroller dealloc=============");
}
@end
