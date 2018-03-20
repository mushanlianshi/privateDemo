//
//  LBBaseNavigationViewController.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBBaseNavigationViewController.h"

@interface LBBaseNavigationViewController ()

@end

@implementation LBBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaivBar];
}


-(void)initNaivBar{
    //1.设置导航栏不透明
    [[UINavigationBar appearance] setTranslucent:NO];
    [UINavigationBar appearance].barTintColor = kCommonBgColor;
//    [UINavigationBar appearance].tintColor = kCommonBgColor;
    
    //2.设置导航栏显示的标题颜色和字体
    NSDictionary *titleDic = @{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName :[UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleDic];
    
    
    //3.设置全局的naviBarItem
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    item.tintColor = [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f];
    
    NSDictionary *itemDic = @{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName :[UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f] };
    [item setTitleTextAttributes:itemDic forState:UIControlStateNormal];
    
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    
}

/**
 重写push方法  判断viewcontrollers的个数是否显示左侧的返回按钮

 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //已经有一个了   显示返回按钮
    if(self.viewControllers.count > 0){
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [leftButton setImage:ImageNamed(@"back_neihan") forState:UIControlStateNormal];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        leftButton.tintColor = [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f];
        [leftButton addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        viewController.navigationItem.leftBarButtonItem = leftItem;
    }else{
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }
    [super pushViewController:viewController animated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
