//
//  LBNHHomeViewController.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomeViewController.h"
#import "LBNHUserIconView.h"
#import "LBNHSegmentView.h"
#import "LBNHHomeBaseViewController.h"
#import "LBNewsTitleBar.h"
#import "LBNHHomeTitleModel.h"
#import "LBCustomSlideViewController.h"
#import "LBNHHomeRequest.h"
#import "LBNHHomePublishController.h"
#import "LBNHPersonalCenterController.h"
#import "LBNHLoginController.h"
#import "LBNHUserInfoManager.h"
#import "LBNHUserInfoModel.h"
#import "LBSDImageCache.h"
#import "LBNHFileCacheManager.h"
#import "LBAppStoreCheckManager.h"

#import "LBTagsView.h"


@interface LBNHHomeViewController ()<LBCustomSlideViewControllerDelegate,LBCustomSlideViewControllerDataSource>

@property (nonatomic, strong) LBNewsTitleBar *titleBar;

@property (nonatomic, strong) LBCustomSlideViewController *slideController;

/** 关注的controller */
@property (nonatomic, strong) LBNHHomeBaseViewController *attentionController;


/** 存储controllers的数组 */
@property (nonatomic, strong) NSMutableArray *controllers;

@property (nonatomic, strong) LBNHUserIconView *iconView;

@end

@implementation LBNHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
    [self initTitleUI];
//    [self testAD];
//    [self requestADAndShow];
    [LBAppStoreCheckManager checkNewVersionAppId:@"787130974" currentController:self];
//    [LBAppStoreCheckManager checkNewVersionAppInfoByID:@"787130974" appInfoHandler:^(LBAppStoreInfoModel *infoModel) {
//        MyLog(@"infoModel %@ ",infoModel);
//    }];
}




-(void)viewWillAppear:(BOOL)animated{
    
    LBNHUserInfoModel *userInfo = [LBNHUserInfoManager sharedLBNHUserInfoManager].currentLoginUserInfo;
    //根据用户是否登录状态设置左边的图片
    if ([[LBNHUserInfoManager sharedLBNHUserInfoManager] isLogin]) {
        [_iconView setIconUrl:userInfo.avatar_url];
    }else{
        _iconView.image = ImageNamed(@"defaulthead");
    }
}

-(void)initTitleUI{
//    [self showLoadingView];
    _iconView = [[LBNHUserIconView alloc] init];
    _iconView.image = ImageNamed(@"defaulthead");
    WS(weakSelf);
    _iconView.tapHandler = ^(LBNHUserIconView *iconView){
        NSLog(@"图片点击了   是否跳转到个人信息界面");
        [weakSelf leftItemClicked];
        
    };
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_iconView];
    _iconView.frame = CGRectMake(0, 0, 35, 35);

    LBNHSegmentView *segmentView = [[LBNHSegmentView alloc] initWithItemTitles:@[@"精选",@"关注"]];
    segmentView.frame = CGRectMake(0, 0, 140, 35);
    [segmentView clickDefaultIndex:0];
    self.navigationItem.titleView = segmentView;
    segmentView.SegmentItemSelected = ^(LBNHSegmentView *segment, NSInteger index, NSString *title){
        if (index == 0) {
            self.titleBar.hidden = NO;
            self.attentionController.view.hidden = YES;
        }else{
            self.titleBar.hidden = YES;
            self.attentionController.view.hidden = NO;
        }
    };
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"submission") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
    
//    LBNHHomeBaseViewController *vc = [[LBNHHomeBaseViewController alloc] initWithUrl:kNHHomeAttentionDynamicListAPI];
//    [self addChildVc:vc];
}



//设置标题
-(void)setModelsArray:(NSArray *)modelsArray{
    _modelsArray = modelsArray;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (LBNHHomeTitleModel *model in modelsArray) {
        [array addObject:model.name];
        if ([model.name isEqualToString:@"游戏"]) {
            UIViewController *vc = [UIViewController new];
            vc.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
            [self.controllers addObject:vc];
        }else if([model.name isEqualToString:@"精华"]){
            UIViewController *vc = [UIViewController new];
            [self.controllers addObject:vc];
        }else{
            LBNHHomeRequest *request = [LBNHHomeRequest lb_request];
            request.lb_url = model.url;
            LBNHHomeBaseViewController *childVC = [[LBNHHomeBaseViewController alloc] initWithRequest:request];
            [self.controllers addObject:childVC];
        }
    }
    [self.slideController reloadSlideVC];
    [self.slideController viewDidLayoutSubviews];
    WS(weakSelf);
    _titleBar = [[LBNewsTitleBar alloc] initWithTitles:array];
    [self.view addSubview:_titleBar];
    _titleBar.frame = CGRectMake(0, 0, kScreenWidth, 30);
    _titleBar.itemBlock = ^(NSInteger index){
        weakSelf.slideController.selectedIndex = index;
    };
    
}

#pragma mark 左右导航栏点击事件
-(void)leftItemClicked{
    if ([[LBNHUserInfoManager sharedLBNHUserInfoManager] isLogin]) {
        LBNHUserInfoModel *userInfo = [[LBNHUserInfoManager sharedLBNHUserInfoManager] currentLoginUserInfo];
        LBNHPersonalCenterController *personalVC = [[LBNHPersonalCenterController alloc] initWithUserInfo:userInfo];
        [self pushToVc:personalVC];
    }
    //没有登录 跳转到登录界面
    else{
        LBNHLoginController *loginVC = [[LBNHLoginController alloc] init];
        [self pushToVc:loginVC];
    }
}

-(void)rightItemClicked{
    NSLog(@"编辑按钮点击了=====");
    LBNHHomePublishController *publishVc = [[LBNHHomePublishController alloc] init];
    [self pushToVc:publishVc];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.slideController.view.frame = CGRectMake(0, 30, kScreenWidth, kScreenHeight- kNavibarHeight -30 - kTabbarHeight);
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
-(LBNHHomeBaseViewController *)attentionController{
    if (!_attentionController) {
        LBNHHomeRequest *request = [LBNHHomeRequest lb_request];
        request.lb_url = kNHHomeAttentionDynamicListAPI;
        _attentionController = [[LBNHHomeBaseViewController alloc] initWithRequest:request];
        //保证_attentionController 有navicontroller 可以push
        [self addChildVc:_attentionController];
        //保证在slideController的子controller显示上面
        [self.view addSubview:_attentionController.view];
        
    }
    return _attentionController;
}

#pragma mark slideController的数据源
/** 索引对应的Controller */
-(UIViewController *)slideViewController:(LBCustomSlideViewController *)slideController viewControllerAtIndex:(NSInteger)index{
    return self.controllers[index];
}

/** 总的子controller的个数 */
-(NSInteger)numbersOfChildViewControllerInSlideController:(LBCustomSlideViewController *)slideController{
    return self.modelsArray.count;
}

/**
 * scrollView滚动到index的代理
 */
-(void)slideViewController:(LBCustomSlideViewController *)slideController slideIndex:(NSInteger) slideIndex{
    [self.titleBar setSelectedIndex:slideIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSMutableArray *)controllers{
    if (!_controllers) {
        _controllers = [NSMutableArray new];
    }
    return  _controllers;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
