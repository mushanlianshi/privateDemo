//
//  LBGuideScrollViewController.m
//  UIDemoCollection
//
//  Created by 123 on 16/8/22.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "LBGuideScrollViewController.h"
#import "AppDelegate.h"

@interface LBGuideScrollViewController()
@property (nonatomic,strong) UIScrollView *scrollView;
@end
@implementation LBGuideScrollViewController

-(instancetype)init{
    self=[super init];
    if(self){
        self.view.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
-(id)initGuideVCwithImageArray:(NSArray *)imageArray{
    self = [super init];
    if (self) {
        self.imageData=imageArray;
        for (int i=0; i<imageArray.count; i++) {
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
            imageView.image=[UIImage imageNamed:imageArray[i]];
            //最后一个引导页  设置点击属性  可以跳过进入主界面
            if (i==imageArray.count-1) {
                UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lastGuideImageViewTapped:)];
                [imageView addGestureRecognizer:tapGesture];
                imageView.userInteractionEnabled=YES;
            }
            [self.scrollView addSubview:imageView];
        }
    }
    return self;
}


#pragma mark 最后个引导页点击事件  
/**
 * 最后一个引导页之后  我们持久化一个键值对  用来进入时判断是否显示引导页
 */
-(void)lastGuideImageViewTapped:(UITapGestureRecognizer *)tapGesture{
//    //有时刚启动取值会为nil
    NSString *version = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kApplicationVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kAPPLastVersion];
//    //设置立马同步
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSDictionary *dic =@{kAPPLastVersion:version};
//    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *path = [NSString stringWithFormat:@"%@/%@.plist",docPath,kAPPLastVersion];
//    BOOL result = [dic writeToFile:path atomically:YES];
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setRootHomeViewController];
}

#pragma mark 懒加载
-(UIScrollView *)scrollView{
    if(_scrollView==nil){
        _scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.pagingEnabled=YES;
        _scrollView.contentSize=CGSizeMake(self.imageData.count*kScreenWidth, kScreenHeight);
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.delegate=self;
        [self.view addSubview:_scrollView];
    }
        return _scrollView;
}

#pragma  mark scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offsetX=scrollView.contentOffset.x;
    CGFloat offsetXScale=offsetX/kScreenWidth;
    //如果最后一个引导页滑动超过0.15  进入主界面
    if (offsetXScale>(self.imageData.count-1+0.2)) {
        [self lastGuideImageViewTapped:nil];
    }
}

-(void)showGuideController{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    appDelegate.window.backgroundColor = [UIColor whiteColor];
    appDelegate.window.rootViewController = self;
    [appDelegate.window makeKeyAndVisible];
}

static NSString *kApplicationVersion = @"kApplicationVersion";
#pragma mark 是否显示新特性
+(BOOL)isShowNewFeature{
    NSString *currentVersion=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationVersion];
    if (saveVersion && [saveVersion isEqualToString:currentVersion]) {
        return NO;
    }else{
        
        return YES;
    }
}

@end
