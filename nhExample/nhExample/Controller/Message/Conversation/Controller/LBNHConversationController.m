//
//  LBNHConversationController.m
//  nhExample
//
//  Created by liubin on 17/4/1.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHConversationController.h"
#import "LBNHCustomNoDataEmptyView.h"

@interface LBNHConversationController ()

@end

@implementation LBNHConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItemTitle = @"投稿互动";
    [self loadData];
}

-(void)loadData{
    [self showLoadingAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLoadingAnimation];
        LBNHCustomNoDataEmptyView *emptyView = [[LBNHCustomNoDataEmptyView alloc] initWithFrame:self.view.bounds];
        emptyView.imageView.image = ImageNamed(@"nocontent");
        [self.view addSubview:emptyView];
    });
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
