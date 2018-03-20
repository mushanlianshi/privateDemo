//
//  LBNHSearchController.m
//  nhExample
//
//  Created by liubin on 17/4/6.
//  Copyright © 2017年 liubin. All rights reserved.
//
NSString  *const searchTableName = @"searchHistory";
#import "LBNHSearchController.h"
#import "LBCustomTextField.h"
#import "LBNHCustomNoDataEmptyView.h"
#import "LBNHSearchRequest.h"
#import "LBNHUserInfoModel.h"
#import "LBNHHomeServiceDataModel.h"
#import "LBNHDiscoveryModel.h"
#import "LBNHSearchFriendsCell.h"
#import "LBNHBaseTableView.h"
#import "LBNHDiscoveryHotCell.h"
#import "LBNHSearchPostsCell.h"
#import "LBNHSearchLimitFriendsCell.h"
#import "LBNHPersonalCenterController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "LBNHSearchPostsCellFrame.h"
#import "BGFMDB.h"
#import "LBNHSearchModel.h"
#import "LBCustomSearchHistoryView.h"
#import "LBDiscoveryCategoryController.h"
#import "LBNHDetailViewController.h"

@interface LBNHSearchController ()<UITextFieldDelegate,LBNHHomeTableViewCellDelegate,LBNHSearchLimitFriendsCellDelegate>

@property (nonatomic, copy) NSString *keyWords;

@property (nonatomic, strong) LBCustomTextField *leftTextField;

@property (nonatomic, strong) LBNHCustomNoDataEmptyView  *emptyView;

/** 热吧栏目搜索的结果 */
@property (nonatomic, strong) NSMutableArray *hotColumnsArray;


/** 搜索到的文字帖子数组 */
@property (nonatomic, strong) NSMutableArray *textPostsArray;
@property (nonatomic, strong) NSMutableArray *textPostsCellFrameArray;

/** 搜索到的图片帖子数组 */
@property (nonatomic, strong) NSMutableArray *imagePostsArray;
@property (nonatomic, strong) NSMutableArray *imagePostsCellFrameArray;

/** 搜索到的视频帖子数组 */
@property (nonatomic, strong) NSMutableArray *videoPostsArray;
@property (nonatomic, strong) NSMutableArray *videoPostsCellFrameArray;

/** 好友是否展开   如果展开只显示他自己  否则都显示 */
@property (nonatomic, assign) BOOL isFirendLineExpand;

/** 历史搜索记录view */
@property (nonatomic, strong) LBCustomSearchHistoryView *historyView;

@end

@implementation LBNHSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNaviItems];
    [self showNoDataView];
    [self addObserverNotifications];
    [self.tableView registerClass:[LBNHHomeTableViewCell class] forCellReuseIdentifier:@"LBNHHomeTableViewCell"];
}





-(void)initNaviItems{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftTextField];
    WS(weakSelf);
    [self setRightNaviItemTitle:@"取消" rightHandler:^(NSString *titleString) {
        //如果展开就闭上
        if (weakSelf.isFirendLineExpand) {
            weakSelf.isFirendLineExpand = NO;
            [weakSelf lb_reloadData];
        }else{
            [weakSelf pop];
        }
    }];
}

-(void)showNoDataView{
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.emptyView.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.centerY.equalTo(self.emptyView).offset(-self.emptyView.imageView.image.size.height/2 - 10);
    }];
    
    [self.emptyView.bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.centerY.equalTo(self.emptyView).offset(20);
        make.width.mas_lessThanOrEqualTo(kScreenWidth - 100);
    }];
}

-(void)searchWithText:(NSString *)searchText{
    self.keyWords = searchText;
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
    [self showLoadingView];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    //段友搜索
    LBNHSearchRequest *personRequest = [LBNHSearchRequest lb_request];
    personRequest.lb_url = kNHDiscoverSearchUserListAPI;
    personRequest.keyword = searchText;
    [personRequest lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        NSLog(@"LBLog  11111  search 段友搜索结束");
        if (success) {
            [self.dataArray removeAllObjects];
            self.dataArray = [LBNHUserInfoModel modelArrayWithArray:response];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    //帖子搜索
    LBNHSearchRequest *contentRequest = [LBNHSearchRequest lb_request];
    contentRequest.lb_url = kNHDiscoverSearchDynamicListAPI;
    contentRequest.keyword = searchText;
    [contentRequest lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        NSLog(@"LBLog 22222 search 段友帖子结束");
        if (success && [response isKindOfClass:[NSDictionary class]]) {
            [self clearArrays];
            self.textPostsArray = [LBNHHomeServiceDataElementGroup modelArrayWithArray:response[@"text"]];
            self.imagePostsArray = [LBNHHomeServiceDataElementGroup modelArrayWithArray:response[@"image"]];
            self.videoPostsArray = [LBNHHomeServiceDataElementGroup modelArrayWithArray:response[@"video"]];
            for (LBNHHomeServiceDataElementGroup *group in self.textPostsArray) {
                LBNHSearchPostsCellFrame *cellFrame = [[LBNHSearchPostsCellFrame alloc] init];
                cellFrame.group = group;
                [self.textPostsCellFrameArray addObject:cellFrame];
            }
            
            for (LBNHHomeServiceDataElementGroup *group in self.imagePostsArray) {
                LBNHSearchPostsCellFrame *cellFrame = [[LBNHSearchPostsCellFrame alloc] init];
                cellFrame.group = group;
                [self.imagePostsCellFrameArray addObject:cellFrame];
            }
            
            for (LBNHHomeServiceDataElementGroup *group in self.videoPostsArray) {
                LBNHSearchPostsCellFrame *cellFrame = [[LBNHSearchPostsCellFrame alloc] init];
                cellFrame.group = group;
                [self.videoPostsCellFrameArray addObject:cellFrame];
            }
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    //栏目搜索 热吧的cell
    LBNHSearchRequest *columnRequest = [[LBNHSearchRequest alloc] init];
    columnRequest.lb_url = kNHDiscoverSearchHotDraftListAPI;
    columnRequest.keyword = searchText;
    [columnRequest lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        NSLog(@"LBLog 33333333 search 段友栏目结束");
        if (success) {
            self.hotColumnsArray = [LBNHDiscoveryCategoryElement modelArrayWithArray:response];
        }
        dispatch_group_leave(group);
    }];
    
    //请求都结束了  处理数据结果
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"LBLog search 所有ALL搜索结束");
        [self hiddenLoadingView];
        [self lb_reloadData];
    });
    

}


/** 清除帖子所有数组中的内容 */
-(void)clearArrays{
    [self.textPostsArray removeAllObjects];
    [self.imagePostsArray removeAllObjects];
    [self.videoPostsArray removeAllObjects];
    [self.textPostsCellFrameArray removeAllObjects];
    [self.imagePostsCellFrameArray removeAllObjects];
    [self.videoPostsCellFrameArray removeAllObjects];
}



#pragma mark cell的数据源

-(NSInteger)lb_numberOfSections{
    if (self.isFirendLineExpand) {
        return 1;
    }
    //利用三目运算符来计算有多少sections  也可以都算上  高度的时候在=0一样的效果
//    NSInteger sections = self.hotColumnsArray.count ? 1 :0 +self.dataArray.count ? 1 : 0 +self.textPostsArray.count ? 1 :0 +self.imagePostsArray.count ? 1 : 0 +self.videoPostsArray.count ? 1 : 0;
//    return sections;
    return 5;
}

/** 某个分组的cell数量*/
- (NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    if (self.isFirendLineExpand) {
        return self.dataArray.count;
    }
    if (section == 0) {
        return self.hotColumnsArray.count;
    }
    //缩略显示好友的个数 只显示一个
    if (section ==1) {
        return 1;
    }
    
//#warning 可能存在bug 当数组为0 时  section少1 导致对齐错乱  所以用三目来算下是否有 没有返回下一个  //不用这种方式  用高度来控制
    if (section == 2) {
//        return self.textPostsArray.count ? self.textPostsArray.count:(self.imagePostsArray.count ? self.imagePostsArray.count :self.videoPostsArray.count);
        return self.textPostsArray.count;
    }
    if (section == 3) {
//        return self.imagePostsArray.count ? self.imagePostsArray.count :self.videoPostsArray.count;
        return self.imagePostsArray.count;
    }
    if (section == 4) {
        return self.imagePostsArray.count;
    }
    return 0;
}

/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFirendLineExpand) {
        LBNHSearchFriendsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"friendsCell"];
        if (!cell) {
            cell = [[LBNHSearchFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendsCell"];
        }
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    //热门栏目的cell
    if (indexPath.section == 0) {
        LBNHDiscoveryHotCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"hotCell"];
        if (!cell) {
            cell = [[LBNHDiscoveryHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCell"];
        }
        cell.model = self.hotColumnsArray[indexPath.row];
        return cell;
    }
    
    //缩略段友的cell
    if (indexPath.section == 1) {
        LBNHSearchLimitFriendsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"limitCell"];
        if (!cell) {
            cell = [[LBNHSearchLimitFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"limitCell"];
            cell.delegate = self;
        }
        [cell setModelsArray:self.dataArray keyWords:self.keyWords];
        return cell;
    }
    
//    LBNHSearchPostsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell" ];
    LBNHHomeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LBNHHomeTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[LBNHHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LBNHSearchPostsCell"];
    }
    cell.delegate = self;
    LBNHSearchPostsCellFrame *cellFrame;
    if (indexPath.section == 2) {
        cellFrame = self.textPostsCellFrameArray[indexPath.row];
    }else if (indexPath.section ==3){
        cellFrame = self.imagePostsCellFrameArray[indexPath.row];
    }else if (indexPath.section == 4){
        cellFrame = self.videoPostsCellFrameArray[indexPath.row];
    }
    [cell setCellFrame:cellFrame keyWords:self.keyWords];
    return cell;
}

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    if (self.isFirendLineExpand) {
        LBNHPersonalCenterController *personalVC = [[LBNHPersonalCenterController alloc] initWithUserInfo:self.dataArray[indexPath.row]];
        [self pushToVc:personalVC];
        return;
    }
    
    //栏目
    if (indexPath.section == 0) {
        LBDiscoveryCategoryController *categoryVC = [[LBDiscoveryCategoryController alloc] initWithCategoryElement:self.hotColumnsArray[indexPath.row]];
        [self pushToVc:categoryVC];
        return;
    }
    
    if (indexPath.section == 1) {
        return;
    }
    LBNHSearchPostsCellFrame *cellFrame ;
    if (indexPath.section == 2) {
        cellFrame = self.textPostsCellFrameArray[indexPath.row];
    }
    if (indexPath.section == 3) {
        cellFrame = self.imagePostsCellFrameArray[indexPath.row];
    }
    if (indexPath.section ==4) {
        cellFrame = self.videoPostsCellFrameArray[indexPath.row];
    }
    LBNHDetailViewController *detailVC = [[LBNHDetailViewController alloc] initWithSearchCellFrame:cellFrame];
    [self pushToVc:detailVC];
}

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFirendLineExpand) {
        return 75;
    }
    if (indexPath.section == 0) {
        return 75;
    }
    if (indexPath.section == 1) {
        if (self.dataArray.count == 0) return 0;
        if (self.dataArray.count ==1) {
            return 75;
        }else{
            return 150;
        }
    }
    LBNHHomeCellFrame *cellFrame;
    if (indexPath.section == 2) {
        cellFrame = self.textPostsCellFrameArray[indexPath.row];
    }
    if (indexPath.section == 3) {
        cellFrame = self.imagePostsCellFrameArray[indexPath.row];
    }
    if (indexPath.section == 4) {
        cellFrame = self.videoPostsCellFrameArray[indexPath.row];
    }
    NSLog(@"cellFrame is %f ",cellFrame.cellHeight);
    return cellFrame.cellHeight;
}

/** 某个组头*/
- (UIView *)lb_headerAtSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    label.backgroundColor = kCommonGrayTextColor;
    label.textColor = kCommonBlackColor;
    label.font = kFont(14);
    if (self.isFirendLineExpand) {
        label.text = @"段友搜索";
        return label;
    }
    if (section == 0) {
        label.text = @" 热门栏目";
    }
    if (section ==1) {
        label.text = @" 段友";
    }
    if (section == 2) {
        label.text = @"文字帖子";
    }
    if (section == 3) {
        label.text = @"图片帖子";
    }
    if(section == 4){
        label.text = @"视频帖子";
    }
    return label;
    return [UIView new];
}

/** 某个组头高度*/
- (CGFloat)lb_sectionHeaderHeightAtSection:(NSInteger)section{
    if (self.isFirendLineExpand) {
        return 44;
    }
    if (section == 0) {
        return self.hotColumnsArray.count ? 44 :0;
    }
    if (section == 1) {
        return self.dataArray.count ? 44 :0;
    }
    if (section == 2) {
        return self.textPostsArray.count ? 44 :0;
    }
    if (section == 3) {
        return self.imagePostsArray.count ? 44 :0;
    }
    if (section == 4) {
        return self.videoPostsArray.count ? 44 :0;
    }
    
    return 0;
}

#pragma mark limitCell 的点击回调

/** 前面好友点击了 */
-(void)searchLimitFriendsCell:(LBNHSearchLimitFriendsCell *)cell clickedIndex:(NSInteger)index{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LBNHPersonalCenterController *personVC = [[LBNHPersonalCenterController alloc] initWithUserInfo:self.dataArray[indexPath.row]];
    [self pushToVc:personVC];
}


/** 更多按钮点击了 */
-(void)searchLimitFriendsMoreClicked:(LBNHSearchLimitFriendsCell *)cell{
    self.isFirendLineExpand = YES;
    [self lb_reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(LBCustomTextField *)leftTextField{
    if (!_leftTextField) {
        _leftTextField = [[LBCustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 80, 30) pleaceHolder:@"输入内容" pleaceHolderColor:kCommonGrayTextColor textColor:kCommonBlackColor leftImage:nil rightImage:nil leftMargin:10.f];
        _leftTextField.delegate = self;
    }
    return _leftTextField;
}

-(LBNHCustomNoDataEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[LBNHCustomNoDataEmptyView alloc] initWithTitle:@"" image:ImageNamed(@"searchmore") desc:@"动动麒麟臂，搜段友，搜更多精彩内容"];
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

-(LBCustomSearchHistoryView *)historyView{
    if (!_historyView) {
        _historyView = [[LBCustomSearchHistoryView alloc] init];
        WS(weakSelf);
        _historyView.searchContent = ^(NSString *content){
            weakSelf.leftTextField.text = content;
        };
    }
    return _historyView;
}


#pragma mark textField的代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self searchWithText:textField.text];
//    LBNHSearchModel *model = [[LBNHSearchModel alloc] init];
//    model.content = textField.text;
//    model.timeStap = [[NSDate date] timeIntervalSince1970];
//    [[BGFMDB intance] saveObject:textField.text complete:^(BOOL isSuccess) {
//        NSLog(@"数据保存成功==== %d ",isSuccess);
//    }];
    if (!textField.text || textField.text.length<1) return YES;
    [self insertToTable:textField.text];
    
    [self.historyView dismiss];
    return YES;
}

-(void)insertToTable:(NSString *)content{
    [[BGFMDB intance] executeSQL:[NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,%@ text unique)",searchTableName,@"content"] complete:^(BOOL isSuccess) {
        NSLog(@"create DB issuccess %d ",isSuccess);
    }];
    [[BGFMDB intance] insertIntoTableName:searchTableName Dict:@{@"content":content} complete:^(BOOL isSuccess) {
        NSLog(@"数据保存成功==== %d ",isSuccess);
    }];
}




- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"数据textFieldDidEndEditing成功====  ");
    [self.historyView dismiss];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    WS(weakSelf);
    [[BGFMDB intance] queryWithTableName:searchTableName complete:^(NSArray *array) {
        NSLog(@"search History is %@ ",array);
        if (array.count>0) {
            NSMutableArray *objects = [NSMutableArray new];
            for (NSDictionary *dic in array) {
                [objects addObject:dic[@"content"]];
            }
            self.historyView.contentsArray = [objects.copy reverseObjectEnumerator].allObjects;
        }
        
        if (array.count > 5) {
            [weakSelf.historyView showWithHeight:5 * 30 upView:self.leftTextField];
        }else{
            [weakSelf.historyView showWithHeight:array.count * 30 upView:self.leftTextField];
        }
    }];
    
//    [[BGFMDB intance] queryAllObject:[NSString class] complete:^(NSArray *array) {
//        if (array.count>0) {
////            NSMutableArray *objects = [NSMutableArray new];
////            for (LBNHSearchModel *model in array) {
////                [objects addObject:model.content];
////            }
//            self.historyView.contentsArray = array.copy;
//            //最多显示5条历史记录
//            if (array.count > 5) {
//                [weakSelf.historyView showWithHeight:5 * 30 upView:self.leftTextField];
//            }else{
//                [weakSelf.historyView showWithHeight:array.count * 30 upView:self.leftTextField];
//            }
//        }
//    }];
    return YES;
}

-(void)textFiledChanged:(NSNotification *)notification{
    //根据textField是不是第一响应来判断
    if ([self.leftTextField isFirstResponder]) {
        self.leftTextField.showRightImage =self.leftTextField.text.length > 0 ? YES : NO;
    }
}

#pragma mark 添加 移除textField改变通知
-(void)addObserverNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)removeObserverNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


-(void)dealloc{
    [self removeObserverNotifications];
}

-(NSMutableArray *)imagePostsCellFrameArray{
    if (!_imagePostsCellFrameArray) {
        _imagePostsCellFrameArray = [NSMutableArray new];
    }
    return _imagePostsCellFrameArray;
}
-(NSMutableArray *)textPostsCellFrameArray{
    if (!_textPostsCellFrameArray) {
        _textPostsCellFrameArray = [NSMutableArray new];
    }
    return _textPostsCellFrameArray;
}
-(NSMutableArray *)videoPostsCellFrameArray{
    if (!_videoPostsCellFrameArray) {
        _videoPostsCellFrameArray = [NSMutableArray new];
    }
    return _videoPostsCellFrameArray;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchBegan ===============");
}

@end
