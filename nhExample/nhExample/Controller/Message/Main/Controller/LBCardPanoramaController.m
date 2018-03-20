//
//  LBCardPanoramaController.m
//  nhExample
//
//  Created by liubin on 17/4/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCardPanoramaController.h"
#import "SCAdView.h"
#import "LBHeroModel.h"
#import "LBCardPanaromaCell.h"
#import "LBPayTextField.h"

@interface LBCardPanoramaController ()<SCAdViewDelegate>

@property (nonatomic, strong) LBPayTextField *textField;

@property (nonatomic, copy) NSString *testName;

@end

@implementation LBCardPanoramaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showAdHorizontally];
//    self.testName = @"33";
//    self.textField = [[LBPayTextField alloc] init];
//    [self.view addSubview:_textField];
//    self.textField.view = self.view.superview;
    
}




#pragma mark --垂直模式
/**
 *  @brief 垂直显示
 */
-(void)showAdVertically{
    
    SCAdView *adView = [[SCAdView alloc] initWithBuilder:^(SCAdViewBuilder *builder) {
        
        //必须参数
        builder.adArray = @[@"刘备",@"李白",@"嬴政",@"韩信"];
        builder.viewFrame = (CGRect){0,0,self.view.bounds.size.width,self.view.bounds.size.height/1.5f};
        builder.adItemSize = (CGSize){self.view.bounds.size.width/2.5f,self.view.bounds.size.width/4.f};
        builder.secondaryItemMinAlpha = 0.6;//非必要参数，设置非主要广告的alpa值
        builder.autoScrollDirection = SCAdViewScrollDirectionTop;//设置垂直向下滚动
        builder.itemCellClassName = NSStringFromClass([LBCardPanaromaCell class]);
        
        //非必要参数
        //        builder.allowedInfinite = NO;  //非必要参数 ：设置不无限循环轮播,默认为Yes
        //        builder.minimumLineSpacing = 40; //非必要参数: 如需要可填写，默认会自动计算
        //        builder.scrollEnabled = NO;//非必要参数
        builder.threeDimensionalScale = 1.45;//非必要参数: 若需要使用threeD效果，则需要填写放大或缩小倍数
        //        builder.allowedInfinite = NO;//非必要参数 : 如设置为NO，则按所需显示，不会无限轮播,也不具备轮播功能,默认为yes
        
    }];
    adView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.2];
    adView.delegate = self;
//    _adView = adView;
    [self.view addSubview:adView];
}
#pragma mark -水平模式
/**
 *  @brief 水平显示
 */
-(void)showAdHorizontally{
    NSArray *testArray =@[@"刘备",@"李白",@"嬴政",@"韩信"];
    //模拟服务器获取到的数据
    NSMutableArray *arrayFromService  = [NSMutableArray array];
    for (NSString *text in testArray) {
        LBHeroModel *hero = [LBHeroModel new];
        hero.imageName = text;
        hero.introduction = [NSString stringWithFormat:@"我是王者农药的:---->%@",text];
        [arrayFromService addObject:hero];
    }
    
    SCAdView *adView = [[SCAdView alloc] initWithBuilder:^(SCAdViewBuilder *builder) {
        builder.adArray = arrayFromService;
        builder.viewFrame = (CGRect){0,100,self.view.bounds.size.width,self.view.bounds.size.width/2.f};
        builder.adItemSize = (CGSize){self.view.bounds.size.width/2.5f,self.view.bounds.size.width/4.f};
        //设置间距的
        builder.minimumLineSpacing = 20;
        builder.secondaryItemMinAlpha = 0.6;
        builder.threeDimensionalScale = 1.45;
//        builder.itemCellNibName = @"SCAdDemoCollectionViewCell";
        builder.itemCellClassName = NSStringFromClass([LBCardPanaromaCell class]);
    }];
    adView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.2];
    adView.delegate = self;
    [adView play];
//    _adView = adView;
    [self.view addSubview:adView];
    
}
#pragma mark -delegate
-(void)sc_didClickAd:(id)adModel{
    NSLog(@"sc_didClickAd-->%@",adModel);
    if ([adModel isKindOfClass:[LBHeroModel class]]) {
        NSLog(@"%@",((LBHeroModel*)adModel).introduction);
    }
}
-(void)sc_scrollToIndex:(NSInteger)index{
    NSLog(@"sc_scrollToIndex-->%ld",index);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    MyLog(@"LBLog cardpanorama dealloc =================");
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
