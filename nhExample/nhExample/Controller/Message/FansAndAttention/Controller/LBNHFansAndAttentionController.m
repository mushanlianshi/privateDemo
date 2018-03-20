//
//  LBNHFansAndAttentionController.m
//  nhExample
//
//  Created by liubin on 17/3/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHFansAndAttentionController.h"
#import "LBNHAttentionAndFansView.h"
#import "LBCustomSlideViewController.h"
#import "LBNHAttetionListRequest.h"
#import "LBNHAttetionListViewController.h"


@interface LBNHFansAndAttentionController ()<LBCustomSlideViewControllerDelegate,LBCustomSlideViewControllerDataSource>

@property (nonatomic, assign) NSInteger userID;

@property (nonatomic, assign) LBAttentionAndFansType type;

@property (nonatomic, strong) LBNHAttentionAndFansView *attentionBar;

@property (nonatomic, strong) LBCustomSlideViewController *slideController;

@end

@implementation LBNHFansAndAttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviItems];
    [self initAttentionBar];
}

-(void)initNaviItems{
    self.navigationItem.title = @"粉丝与关注";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"推荐" style:UIBarButtonItemStylePlain target:self action:@selector(recommendItemClicked)];
}

-(void)initAttentionBar{
    [self.attentionBar defaultClickedIndex:self.type];
    [self.slideController reloadSlideVC];
}


-(instancetype)initWithUserId:(NSInteger)userID attentionType:(LBAttentionAndFansType)type{
    self=[super init];
    if (self) {
        self.userID = userID;
        self.type = type;
    }
    return self;
}


/**
 * 布局sliderController的位置
 */
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.slideController.view.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-64-44);
}

#pragma mark 推荐事件处理
-(void)recommendItemClicked{
    LBNHAttetionListRequest *request = [[LBNHAttetionListRequest alloc] init];
    request.offset = 0;
    request.lb_url = kNHDiscoverRecommendUserListAPI;
    LBNHAttetionListViewController *vc = [[LBNHAttetionListViewController alloc] initWithRequest:request];
    [self pushToVc:vc];
}

-(LBNHAttentionAndFansView *)attentionBar{
    if (!_attentionBar) {
        _attentionBar = [[LBNHAttentionAndFansView alloc] initWithTitles:@[@"关注",@"粉丝"]];
        _attentionBar.frame = CGRectMake(0, 0, kScreenWidth, 44);
        WS(weakSelf);
        _attentionBar.itemHandler = ^(UIButton *button, NSInteger index){
            weakSelf.slideController.selectedIndex = index;
        };
        [self.view addSubview:_attentionBar];
    }
    return _attentionBar;
}

-(LBCustomSlideViewController *)slideController{
    if (!_slideController) {
        _slideController = [[LBCustomSlideViewController alloc] init];
        _slideController.dataSource = self;
        _slideController.delegate = self;
        [self addChildVc:_slideController];
    }
    return _slideController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark slideController 的数据源方法
/** 索引对应的Controller */
-(UIViewController *)slideViewController:(LBCustomSlideViewController *)slideController viewControllerAtIndex:(NSInteger)index{
    LBNHAttetionListRequest *request = [LBNHAttetionListRequest lb_request];
    request.offset = 0;
    request.homepage_user_id = self.userID;
    if (index == 0) {
        request.lb_url = kNHUserFansListAPI;
    }else if (index == 1){
        request.lb_url = kNHUserAttentionListAPI;
    }
    LBNHAttetionListViewController *vc = [[LBNHAttetionListViewController alloc] initWithRequest:request];
    return vc;
}

/** 总的子controller的个数 */
-(NSInteger)numbersOfChildViewControllerInSlideController:(LBCustomSlideViewController *)slideController{
    return 2;
}


#pragma mark slideController 的代理方法

-(void)slideViewController:(LBCustomSlideViewController *)slideController slideIndex:(NSInteger) slideIndex{
    [self.attentionBar defaultClickedIndex:slideIndex];
}

@end
