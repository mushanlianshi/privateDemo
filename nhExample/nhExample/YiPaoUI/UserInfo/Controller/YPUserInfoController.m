//
//  YPUserInfoController.m
//  nhExample
//
//  Created by liubin on 17/5/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "YPUserInfoController.h"
#import "LBNHBaseTableView.h"
#import "YPUserInfoModel.h"
#import "YPUserInfoTableviewCell.h"
#import "LBAuthorUtil.h"
#import "LBEmitterAnimationView.h"

static NSString *kCellIndentifer = @"YPUserInfoTableviewCell";

@interface YPUserInfoController ()

@property (nonatomic, strong) NSMutableArray *accountArray;

@property (nonatomic, strong) NSMutableArray *infosArray;

@end

@implementation YPUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)initData{
    YPUserInfoModel *model1 = [[YPUserInfoModel alloc] init];
    model1.title = @"账号管理";
    model1.image = ImageFiled(@"yp_usrIcon@2x.png");
    
    YPUserInfoModel *model2 = [[YPUserInfoModel alloc] init];
    model2.title = @"手机号码";
    model2.subTitle = @"未绑定";
    
    YPUserInfoModel *model3 = [[YPUserInfoModel alloc] init];
    model3.title = @"QQ达人";
    model3.image = ImageFiled(@"yp_userInfo@2x.png");
    model3.subTitle = @"980天";
    [self.accountArray addObject:model1];
    [self.accountArray addObject:model2];
    [self.accountArray addObject:model3];
    
    YPUserInfoModel *model5 = [[YPUserInfoModel alloc] init];
    model5.title = @"性别";
    model5.subTitle = @"男";
    
    YPUserInfoModel *model6 = [[YPUserInfoModel alloc] init];
    model6.title = @"出生年月";
    model6.subTitle = @"1990-06-13";
    
    YPUserInfoModel *model7 = [[YPUserInfoModel alloc] init];
    model7.title = @"身高";
    model7.subTitle = @"175cm";
    
    YPUserInfoModel *model8 = [[YPUserInfoModel alloc] init];
    model8.title = @"体重";
    model8.subTitle = @"60kg";
    [self.infosArray addObject:model5];
    [self.infosArray addObject:model6];
    [self.infosArray addObject:model7];
    [self.infosArray addObject:model8];
    [self.tableView registerClass:[YPUserInfoTableviewCell class] forCellReuseIdentifier:kCellIndentifer];
    [self.tableView reloadData];
}

/** 分组数量*/
- (NSInteger)lb_numberOfSections{
    return 2;
}

/** 某个分组的cell数量*/
- (NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.accountArray.count;
    }else if (section == 1){
        return self.infosArray.count;
    }
    return 0;
}

/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    YPUserInfoTableviewCell *cell = (YPUserInfoTableviewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIndentifer forIndexPath:indexPath];
    if (!cell) {
        cell = [[YPUserInfoTableviewCell alloc] init];
    }
    if (indexPath.section == 0) {
        [cell setModel:self.accountArray[indexPath.row]];
    }else if (indexPath.section == 1){
        [cell setModel:self.infosArray[indexPath.row]];
    }
    return cell;
}

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [LBAuthorUtil isHasPhotoLibraryAuthority:YES];
        }else if (indexPath.row == 1){
            [LBAuthorUtil isHasCameraAuthority:YES];
        }else if (indexPath.row == 2){
            [LBAuthorUtil isHasLocationAuthority:YES];
        }else{
            [LBAuthorUtil isHasMicrophoneAuthority:^(BOOL isAuthority) {
                
            } showAlert:YES];
        }
    }
    
    [LBEmitterAnimationView show];
}

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

/** 某个组头*/
- (UIView *)lb_footerAtSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

/** 某个组尾高度*/
- (CGFloat)lb_sectionFooterHeightAtSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.01;
}

-(NSMutableArray *)accountArray{
    if (!_accountArray) {
        _accountArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _accountArray;
}

-(NSMutableArray *)infosArray{
    if (!_infosArray) {
        _infosArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _infosArray;
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
