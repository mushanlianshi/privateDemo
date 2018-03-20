//
//  LBAppStoreCheckManager.m
//  nhExample
//
//  Created by liubin on 17/4/25.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBAppStoreCheckManager.h"
#import <objc/runtime.h>

static NSString *kCancelTipVersion = @"kCancelTipVersion";

@interface LBAppStoreCheckManager ()


@end

@implementation LBAppStoreCheckManager

+(void)checkNewVersionAppId:(NSString *)appId currentController:(UIViewController *)currentController{
    __weak __typeof(self)weakSelf = self;
    [[self sharedInstance] getAppInfoWithAppId:appId success:^(LBAppStoreInfoModel *appInfoModel) {
        NSString *title = [NSString stringWithFormat:@"有新的版本(%@)",appInfoModel.version];
        //如果要自定义字体的颜色  需要使用的kvc alertContoller的attributedTitle 和attributedMessage 属性 action的titleTextColor属性
        UIAlertController *alertContrl = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        //设置样式
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:title];
        [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} range:NSMakeRange(0, title.length-1)];
        [alertContrl setValue:attributeString forKey:@"attributedTitle"];
        
        
        UIAlertAction *upAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[weakSelf sharedInstance] updateNowUrl:appInfoModel.trackViewUrl];
        }];
        
//        objc_geti
//        unsigned int count =0;
        const char * actionClassName = class_getName([NSArray class]);
//        Ivar *ivars=class_copyIvarList([UIAlertAction class], &count);
//        for (int i =0; i<count; i++) {
//            Ivar ivar = ivars[i];
//            const char* ivarName = ivar_getName(ivar);
//            NSString *ivarNameString = [NSString stringWithUTF8String:ivarName];
//            MyLog(@"ivarName is %@ ",ivarNameString);
//        }
//        Ivar ivar =   class_getInstanceVariable([UIAlertAction class], "_titleTextColor");
        UIAlertAction *afterAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [afterAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[weakSelf sharedInstance] cancelTip:appInfoModel.version];
        }];
        
        [alertContrl addAction:upAction];
        [alertContrl addAction:afterAction];
        [alertContrl addAction:cancelAction];
        
        [currentController presentViewController:alertContrl animated:YES completion:nil];
    }];
    
}

+(void)checkNewVersionAppInfoByID:(NSString *)appID appInfoHandler:(LBCheckNewInfoHandler)appInfoHandler{
    [[self sharedInstance] getAppInfoWithAppId:appID success:^(LBAppStoreInfoModel *appInfoModel) {
        if (appInfoHandler) {
            appInfoHandler(appInfoModel);
        }
    }];
}

#pragma mark 处理alert的事件
-(void)updateNowUrl:(NSString *)appStoreUrl{
    NSURL *url = [NSURL URLWithString:appStoreUrl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)after{
    
}
/** 取消提醒的版本 */
-(void)cancelTip:(NSString *)cancelVersion{
    
    [[NSUserDefaults standardUserDefaults] setValue:cancelVersion forKey:kCancelTipVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 判断是否需要提醒   不需要就不回调给信息了 */
-(BOOL)isTipVersion:(NSString *)version{
    MyLog(@"version is %@ ",version);
    NSString *currentString = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *cancelVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kCancelTipVersion];
    if ([currentString isEqualToString:version] || [cancelVersion isEqualToString:version])
        return NO;
    return YES;
    
}


/** 获取app在appstore上信息成功的回调 */
-(void)getAppInfoWithAppId:(NSString *)appId success:(void (^)(LBAppStoreInfoModel *appInfoModel))success{
    __weak __typeof (self)weakSelf = self;
    NSString *appPath = [NSString stringWithFormat:@"https://itunes.apple.com/CN/lookup?id=%@",appId];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:appPath] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && data && data.length > 0) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (dic && [dic[@"resultCount"] integerValue]) {
//                LBAppStoreInfoModel *infoModel = [LBAppStoreInfoModel modelWithDictionary:dic[@"results"][0]];
                //不使用MJExtenstion方法
                LBAppStoreInfoModel *infoModel = [[LBAppStoreInfoModel alloc] init];
                [infoModel setValuesForKeysWithDictionary:dic[@"results"][0]];
                infoModel.AppId = appId;
                //判断是否提醒 以及是否有回调
                if (success && [weakSelf isTipVersion:infoModel.version]) {
                    //确保主线程回调回去
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(infoModel);
                    });
                    
                }
            }else{
                MyLog(@"appid没找到===");
//#ifdef DEBUG    断言在debug中生效  build settings里有设置
                NSAssert(0, @"LBLog APPID 没找到===========");
//#endif
            }
        }
    }];
    [task resume];
}


/** 单例 */
static LBAppStoreCheckManager *instance;
+(id)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

-(void)dealloc{
    NSLog(@"LBAppStoreCheckManager dealloc ======      ====== ");
}
@end
