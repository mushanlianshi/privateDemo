//
//  LBDiscoveryCategoryControllerViewController.m
//  nhExample
//
//  Created by liubin on 17/3/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBDiscoveryCategoryController.h"
#import "LBDiscoverCategoryRequest.h"
#import "LBNHHomeBaseViewController.h"
#import "LBNHDiscoveryModel.h"

@interface LBDiscoveryCategoryController ()

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, strong) LBNHDiscoveryCategoryElement *element;

@end

@implementation LBDiscoveryCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNaviITtem];
    [self loadData];
}
-(void)setUpNaviITtem{
    if (self.element.name) {
        self.navItemTitle = self.element.name;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"submission") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
}

-(void)rightItemClicked{
    
}

-(instancetype)initWithCategoryId:(NSInteger)categoryId{
    self=[super init];
    if (self) {
        self.categoryId = categoryId;
    }
    return self;
}

-(instancetype)initWithCategoryElement:(LBNHDiscoveryCategoryElement *)element{
    self = [super init];
    if (self) {
        self.element = element;
    }
    return self;
}

-(void)loadData{
    LBDiscoverCategoryRequest *request = [LBDiscoverCategoryRequest lb_request];
    request.lb_url = kNHHomeCategoryDynamicListAPI;
    request.category_id =self.element ? self.element.ID : self.categoryId;
    request.count = 30;
    request.level = 6;
    request.message_cursor = 0;
    request.mpic = 1;
    LBNHHomeBaseViewController *vc = [[LBNHHomeBaseViewController alloc] initWithRequest:request];
    vc.isCategory = YES;
    [self addChildVc:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
