//
//  LBNHMessageViewController.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHMessageViewController.h"
#import "LBNHBaseImageView.h"
#import "LBNHUserInfoManager.h"
#import "LBNHUserInfoModel.h"
#import "UIView+LBTap.h"
#import "LBNHUserIconView.h"
#import "LBNHMessageModel.h"
#import "LBNHBaseTableView.h"
#import "LBNHCustomNoDataEmptyView.h"
#import "LBNHFansAndAttentionController.h"
#import "LBNHSystemMessageController.h"
#import "LBNHConversationController.h"
#import "LBUtils.h"
#import "NSFileManager+LBPath.h"
#import "NSString+Size.h"
#import "LBCustomAlertView.h"
#import "LBAnimationController.h"
#import "LBCircleAnimationController.h"
#import "LBDragCellController.h"
#import "LBCardPanoramaController.h"
#import "LBMessageViewController.h"
#import "LBLoginController.h"
#import "UIImageView+LBGIF.h"
#import "LBSDImageCache.h"
#import "LBPayTextField.h"
#import "LBAlipaySearchAnimationController.h"
#import "LBSnakeViewController.h"
#import "LBScanBarcodeController.h"
#import "LBAlertController.h"
#import "LBCustomTableViewSheet.h"
#import "YPLoginController.h"
#import "YPUserInfoController.h"

static NSString *messageCellID = @"LBNHMessageCell";
NSString *const LBGIFURLPath = @"http://172.16.20.232:8080/image/18.gif";


@interface LBNHMessageViewController ()

@property (nonatomic, copy) NSString *cachesSizeString;

/** 头GIF的imageview */
@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UIImageView *snapImageView;

@property (nonatomic, assign) CGFloat headerHeight;


@property (nonatomic, strong) LBPayTextField *payTextField;

@end

@implementation LBNHMessageViewController

- (void)viewDidLoad {
    
    MyLog(@"self.view frame si %@ ",NSStringFromCGRect(self.view.frame));
    [super viewDidLoad];
    [self initNaviUI];
    [self loadData];
    self.view.layerName = @"layerName first";
    MyLog(@"self.view.layername is %@ ",self.view.layerName);
//    [self performSelector:@selector(addName) withObject:nil];
    
    //1.开启摇一摇
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
//    [self becomeFirstResponder];
}

-(void)viewDidLayoutSubviews{
    MyLog(@"self.view frame is %@ ",NSStringFromCGRect(self.view.frame));
    [super viewDidLayoutSubviews];
    //让tableview在上面  因为在父controller里的这个方法中我们设置了他在后面
    [self.view bringSubviewToFront:self.tableView];
    [self.view bringSubviewToFront:self.snapImageView];
//    [self.view bringSubviewToFront:self.payTextField];
//    [[UINavigationBar appearance] setTranslucent:YES];
}

//-(void)viewWillAppear:(BOOL)animated
-(void)viewWillAppear:(BOOL)animated{
    MyLog(@"self.view frame si %@ ",NSStringFromCGRect(self.view.frame));
    [super viewWillAppear:animated];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [LBAlertController showSheetTitle:@"title" content:@"content" firstTitle:@"first" firstBlock:nil secondTitle:nil secondBlock:nil cancelString:@"cancel" cancelBlock:nil currentController:self];
//        LBCustomTableViewSheet *sheet=[[LBCustomTableViewSheet alloc] initWithTitleView:nil optionsArray:@[@"1111",@"2",@"33333333333333"] optionsBlock:^(NSInteger index) {
//            MyLog(@"LBlog index is %d ",index);
//        } cancelTitle:@"确定取消" cancelBlock:^{
//            MyLog(@"LBlog index 确定 ");
//        }];
//        [sheet show];
//    });
}

-(void)initNaviUI{
//    _payTextField = [[LBPayTextField alloc] init];
//    _payTextField.frame = CGRectMake(0, 0, 200, 40);
//    [self.view addSubview:_payTextField];
    WS(weakSelf);
    [self.headerImageView lb_setGifImage:[NSURL URLWithString:LBGIFURLPath] firstImageBlock:^(UIImage *image) {
        if (image) {
            CGFloat height = kScreenWidth*image.size.height/image.size.width;
            weakSelf.headerHeight = height;
            weakSelf.headerImageView.frame = CGRectMake(0, 0, kScreenWidth, height);
            //为了让他在tablview下正常显示  tablview的内容下移这个高度
            weakSelf.tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
        }
    }];
    
    LBNHUserInfoModel *userInfo = [LBNHUserInfoManager sharedLBNHUserInfoManager].currentLoginUserInfo;
    LBNHUserIconView *iconView = [[LBNHUserIconView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    iconView.image = ImageNamed(@"digdownicon_review_press_1");
    iconView.iconUrl = userInfo.avatar_url;
//    iconView.frame = CGRectMake(0, 0, 35, 35);
    iconView.tapHandler = ^(LBNHUserIconView *iv){
        [weakSelf userInfoClicked];
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:iconView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"黑名单" style:UIBarButtonItemStylePlain target:self action:@selector(blackRoomClicked)];
    self.navItemTitle = @"消息";
}

-(void)loadData{
    NSArray *imageArray = @[@"interaction",@"messageicon_profile",@"vermicelli",@"godcomment",@"interaction",@"messageicon_profile",@"vermicelli",@"godcomment",@"interaction",@"messageicon_profile",@"interaction",@"messageicon_profile",@"vermicelli",@"interaction"];
    NSArray *titleArray = @[@"投稿互动",@"系统消息",@"粉丝互助",@"缓存大小",@"动画",@"转盘选择动画",@"可拖动的cell",@"卡片式轮播",@"信息界面",@"用户信息",@"搜索动画",@"贪吃蛇",@"二维码",@"易跑登录"];
    int i = 0;
    for (NSString *title in titleArray){
        LBNHMessageModel *model = [[LBNHMessageModel alloc] init];
        model.title = title;
        model.iconName = imageArray[i];
        i++;
        [self.dataArray addObject:model];
    }
    [self lb_reloadData];
    LBNHCustomNoDataEmptyView *emptyView = [[LBNHCustomNoDataEmptyView alloc] initWithTitle:@"约起来吧" image:ImageNamed(@"around") desc:@"去TA的主页就可以发悄悄话了"];
    emptyView.frame = CGRectMake(0, 44*self.dataArray.count, kScreenWidth, 200);
    [self.tableView addSubview:emptyView];
    //监控tableviewcontentOffset的值
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.tableView.backgroundColor = [UIColor clearColor];
//    [self.view insertSubview:self.headerImageView belowSubview:self.tableView];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    [self.view insertSubview:self.headerImageView belowSubview:self.tableView];
    if ([keyPath isEqualToString:@"contentOffset"]) {
//        NSLog(@"LBlog  change ===== %@ ",change);
        NSValue *value = change[@"new"];
        CGFloat y = [value CGPointValue].y;
        if (y<-self.headerHeight ) {
            self.headerImageView.height = -y;
        }
    }
}

-(void)userInfoClicked{
    NSLog(@"cell userInfoClicked =============");
}

-(void)blackRoomClicked{
    NSLog(@"cell blackRoomClicked =============");
}


-(NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    LBNHMessageModel *model = self.dataArray[indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:messageCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCellID];
    }
    cell.imageView.image = ImageNamed(model.iconName);
    cell.textLabel.text = model.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectedBackgroundView = [UIView new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 3) {
        UILabel *label = [cell viewWithTag:101];
        if (!label) {
            label = [[UILabel alloc] init];
            label.font = kFont(13);
            label.tag = 101;
            label.textColor = kCommonTintColor;
            label.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:label];
        }
        label.hidden = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CGFloat cacheSize = [LBUtils folderSizeAtPath:[NSFileManager cachesPath]];
            //        CGFloat librarySize = [LBUtils folderSizeAtPath:[NSFileManager libraryPath]];
            //判断不是nan数据
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!isnan(cacheSize)){
                    label.text = [NSString stringWithFormat:@"缓存 %.2f M",cacheSize];
                }else{
                    label.text = [NSString stringWithFormat:@"缓存 0 M"];
                }
                
                self.cachesSizeString = label.text;
                NSLog(@"===== %p ",self.cachesSizeString);
                NSLog(@"==label.text=== %p ",label.text);
                CGFloat width = [label.text widhtWithLimitHeight:30 fontSize:13];
                label.frame = CGRectMake(kScreenWidth - width - 40, 7, width, 30);
            });
            
        });
        
    }else{
        UILabel *label = [cell viewWithTag:101];
        if (label) {
            label.hidden = YES;
        }
    }
    
    return cell;
}

-(CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    NSLog(@"cell selected =============");
    switch (indexPath.row) {
        case 0:
            {
                LBNHConversationController *vc = [[LBNHConversationController alloc] init];
                [self pushToVc:vc];
            }
            break;
        case 1:
            {
                LBNHSystemMessageController *vc = [[LBNHSystemMessageController alloc] init];
                [self pushToVc:vc];
            }
            
            break;
        case 2:
            {
                
                LBNHFansAndAttentionController *vc = [[LBNHFansAndAttentionController alloc] initWithUserId:[LBNHUserInfoManager sharedLBNHUserInfoManager].userID attentionType:LBAttentionAndFansTypeFans];
                [self pushToVc:vc];
            }
            break;
        case 3:
            {
                LBCustomAlertView *alertView = [[LBCustomAlertView alloc] initWithTitle:@"清楚缓存" content:[NSString stringWithFormat:@"你确定要清楚%@缓存吗",self.cachesSizeString] cancel:@"取消" sure:@"确定"];
                [alertView showInSuperView:self.view];
                WS(weakSelf);
                [alertView setSureBlock:^{
                    [LBUtils clearCache:[NSFileManager cachesPath]];
                    [LBUtils clearCache:[NSFileManager libraryPath]];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
            break;
        case 4:{
            LBAnimationController *vc = [[LBAnimationController alloc] init];
            [self pushToVc:vc];
            }
            break;
        case 5:
            {
                LBCircleAnimationController *vc = [[LBCircleAnimationController alloc] init];
                [self pushToVc:vc];
            }
            break;
        case 6:
        {
            LBDragCellController *vc = [[LBDragCellController alloc] init];
            [self pushToVc:vc];
        }
            break;
        case 7:
        {
            LBCardPanoramaController *vc = [[LBCardPanoramaController alloc] init];
            [self pushToVc:vc];
        }
            break;
        case 8:
        {
            LBMessageViewController *vc = [[LBMessageViewController alloc] init];
            [self pushToVc:vc];
        }
            break;
        case 9:
        {
            YPUserInfoController *vc = [[YPUserInfoController alloc] init];
            [self pushToVc:vc];
        }
            break;
        case 10:
        {
            LBAlipaySearchAnimationController *vc = [[LBAlipaySearchAnimationController alloc] init];
            [self pushToVc:vc];
        }
            break;
        case 11:
        {
            LBSnakeViewController  *vc = [[LBSnakeViewController alloc] init];
            [self pushToVc:vc];
        }
            break;
        case 12:
        {
            LBScanBarcodeController  *vc = [[LBScanBarcodeController alloc] init];
            [self pushToVc:vc];
        }
            break;
        case 13:
        {
            YPLoginController  *vc = [[YPLoginController alloc] init];
            [self pushToVc:vc];
        }
            break;
        default:
            break;
    }
}



#pragma mark 摇一摇代理
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    MyLog(@"LBLog motionBegan==========");
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    MyLog(@"LBLog motionCancelled==========");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    [self resignFirstResponder];
    MyLog(@"LBLog motionEnded==========");
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIImage *image = [LBUtils screenshot];
    _snapImageView = [[UIImageView alloc] init];
    _snapImageView.image = image;
    [_snapImageView showRedBorder];
    [self.view addSubview:_snapImageView];
    [_snapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.7);
        make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.7);
    }];
    
    
    [UIView animateWithDuration:1.5 delay:0.f usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_snapImageView layoutIfNeeded];
        [_snapImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
            make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.5);
        }];
    } completion:^(BOOL finished) {
        NSLog(@"LBLog finished ========= ");
        [_snapImageView removeFromSuperview];
    }];
    
    
    
}

-(UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _headerImageView.frame = CGRectMake(0, 0, kScreenWidth, 200);
        [self.view addSubview:_headerImageView];
    }
    return _headerImageView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
