//
//  LBNHTabbarViewController.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHTabbarViewController.h"
#import "LBNHHomeViewController.h"
#import "LBNHDiscoveryViewController.h"
#import "LBNHCheckViewController.h"
#import "LBNHMessageViewController.h"
#import "LBBaseNavigationViewController.h"
#import "LBNHHomeTitleRequest.h"
#import "LBNHHomeTitleModel.h"
#import "LBTabBar.h"
#import "LBAlertController.h"
#import "LBNHRequestManager.h"
//#import "LBAppStoreCheckManager.h"
@interface LBNHTabbarViewController ()<UITabBarControllerDelegate>

/**  记录上次选中的索引  防止重复动画 的 */
@property (nonatomic, assign) NSInteger selectedFlag;

@end

@implementation LBNHTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self initTabbar];
    [self addChildViewControllers];
//    [self rechangedCenterTabBar];
    [self requestTitlesData];
    
}

-(void)requestTitlesData{
    LBNHHomeTitleRequest *request = [[LBNHHomeTitleRequest alloc] init];
    request.lb_url = kNHHomeServiceListAPI;
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        if (success) {
            LBBaseNavigationViewController *navi = (LBBaseNavigationViewController *)self.childViewControllers.firstObject;
            LBNHHomeViewController *homeVC = (LBNHHomeViewController *)navi.viewControllers.firstObject;
            homeVC.modelsArray = [LBNHHomeTitleModel modelArrayWithArray:response];
        }else{
            [LBTips showTips:@"获取数据失败"];
        }
    }];
    
    NSString *url = @"http://api.baletu.com/App401/House/getList378.html?P=1&S=10&area_ids=&city_id=530&device_id=15F62781-9664-4F71-B693-A2FFBB4A7020&distance=0&end_price=99999&from=2&has_yangtai=0&hire_way=2&house_type_ids=0&ind_bathroom=0&is_appliance_complete=0&is_charter=0&is_duchu=0&is_elevator=0&is_groundfloor=0&is_index=1&is_jingzhuang=0&is_meter=0&is_monthly_pay=0&is_yuanfang=0&lat=&lon=&new_shelves=0&no_house=2&room_direction=0&room_type=0&searchStr=&sort_way=0&start_price=0&subway_ids=&udid=93a6548376521533c5d10999d3fe6018&user_id=299617&ut=8eac25a9bd4c2f647343fa198976386f2b0b41cc&v=4.1.6&walking_time=0";
    [LBNHRequestManager GET:url parameters:nil responseSerializerType:LBResponseSerializerTypeJSON successHandler:^(id response, NSURLSessionTask *task) {
        NSLog(@"LBLog response is %@ ",response);
    } failureHandler:^(NSError *error, NSURLSessionTask *task) {
        NSLog(@"LBLog error is %@ ",error);
    }];
}

/**
 设置tabbar显示的样式
 */
-(void)initTabbar{
    //1.获取全局的tabbat
    UITabBar *tabbar = [UITabBar appearance];
    // 设置为不透明
    [tabbar setTranslucent:NO];
    //设置1px的横线不显示  两一起设置才有效果
    [tabbar setBackgroundImage:[UIImage new]];
    [tabbar setShadowImage:[UIImage new]];
    //主题颜色
    tabbar.barTintColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    
    //2.拿到整个显示的tabbarItem // 拿到整个导航控制器的外观
    UITabBarItem * item = [UITabBarItem appearance];
    item.titlePositionAdjustment = UIOffsetMake(0, 1.5);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize: 13],NSForegroundColorAttributeName:[UIColor colorWithRed:0.62f green:0.62f blue:0.63f alpha:1.00f]};
    //3.设置普通的状态
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary *selectDic = @{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName : [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f]};
    //4.设置选中的状态
    [item setTitleTextAttributes:selectDic forState:UIControlStateSelected];
}

-(void)addChildViewControllers{
    [self addChildViewController:[LBNHHomeViewController description] title:@"首页" image:@"home"];
    [self addChildViewController:[LBNHDiscoveryViewController description] title:@"发现" image:@"Found"];
    [self addChildViewController:[LBNHCheckViewController description] title:@"审核" image:@"audit"];
    [self addChildViewController:[LBNHMessageViewController description] title:@"消息" image:@"newstab"];
}

#pragma mark 利用kvc 换成中间凸起的tabbar
//-(void)rechangedCenterTabBar{
//    LBTabBar *tabbar = [[LBTabBar alloc] init];
//    WS(weakSelf);
//    tabbar.centerClick = ^(LBTabBar *tabbar){
//        [LBAlertController showAlertTitle:@"提示" content:@"此功能暂未开发" currentController:weakSelf];
//    };
//    //利用kvc替换tabbar  更换属性控件
//    [self setValue:tabbar forKey:@"tabBar"];
//}

-(void)addChildViewController:(NSString *)viewController title:(NSString *)title image:(NSString *)image{
    LBBaseNavigationViewController *navi = [[LBBaseNavigationViewController alloc] initWithRootViewController:[[NSClassFromString(viewController) alloc] init]];
    navi.tabBarItem.title = title;
    navi.tabBarItem.image = ImageNamed(image);
    //不使用系统默认的染色方式  UIImageRenderingModeAlwaysOriginal 使用原来的
    navi.tabBarItem.selectedImage = [ImageNamed([image stringByAppendingString:@"_press"]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:navi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return NO;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - tabbar选中的动画
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index =[self.tabBar.items indexOfObject:item];
    NSLog(@"LBLog index is %zd %zd ",index, self.selectedIndex);
    if (self.selectedFlag != index) {
        [self animationWithIndex:index];
    }
}

// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    self.selectedFlag = index;
    
}

#pragma mark 拦截tabbar的点击事件  处理跳转不跳转
//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    LBBaseNavigationViewController *navi = (LBBaseNavigationViewController *)viewController;
//    if ([navi.viewControllers.firstObject isKindOfClass:[LBNHMessageViewController class]]) {
//        NSLog(@"LBNHMessageViewController vc  不跳转");
//        return NO;
//    }else{
//        NSLog(@"不是 LBNHMessageViewController vc  跳转");
//        return  YES;
//        
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
