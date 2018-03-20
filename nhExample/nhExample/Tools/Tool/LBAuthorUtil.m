//
//  LBAuthorUtil.m
//  nhExample
//
//  Created by liubin on 17/5/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBAuthorUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LBAlertController.h"
#define IOS10Later [[[UIDevice currentDevice] systemVersion] floatValue] > 10

@implementation LBAuthorUtil
+(BOOL)isHasPhotoLibraryAuthority:(BOOL)showAlert{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
        MyLog(@"LBLog 没有访问图库的权限==============");
        if (showAlert) {
            [LBAlertController showAlertTitle:@"无法使用相册" content:@"请在iPhone的\"设置-隐私-照片\"中允许访问照片。" cancelString:@"取消" cancleBlock:nil sureString:@"去设置" sureBlock:^{
                // 需要在info.plist中添加 URL types 并设置一项URL Schemes为prefs  IOS10 以后不起作用 else的方法
                NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } currentController:nil];
        }

        
        return NO;
    }else if(status == ALAuthorizationStatusNotDetermined){
        
    }

    return  YES;
}

+(BOOL)isHasCameraAuthority:(BOOL)showAlert{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        MyLog(@"LBLog 没有访问相机的权限");
        if (showAlert) {
            [LBAlertController showAlertTitle:@"无法使用相机" content:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机。" cancelString:@"取消" cancleBlock:nil sureString:@"去设置" sureBlock:^{
                // 需要在info.plist中添加 URL types 并设置一项URL Schemes为prefs  IOS10 以后不起作用
                NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } currentController:nil];
            return NO;
        }else if (status == AVAuthorizationStatusNotDetermined){
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    MyLog(@"LBLog 获取相机权限正常==============");
                    
                }else{
                    MyLog(@"LBLog 获取相机权限不正常==============");
                }
            }];
        }
    }
    MyLog(@"LBLog 有访问相机的权限 =============");
    return YES;
}


+(BOOL)isHasLocationAuthority:(BOOL)showAlert{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        MyLog(@"LBLog 没有获取地理位置的权限");
        if (showAlert) {
            [LBAlertController showAlertTitle:@"无法使用定位" content:@"请在iPhone的\"设置-隐私-定位\"中允许访问地理位置。" cancelString:@"取消" cancleBlock:nil sureString:@"去设置" sureBlock:^{
                
                // 需要在info.plist中添加 URL types 并设置一项URL Schemes为prefs  IOS10 以后不起作用
                NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } currentController:nil];
        }
        return NO;
    }else if (status == kCLAuthorizationStatusNotDetermined){
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        if([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [manager requestWhenInUseAuthorization];
        };
    }
    
    MyLog(@"LBLog 获取位置权限正常==============");
    return YES;
}

+(void)isHasMicrophoneAuthority:(void (^)(BOOL isAuthority))hasAuthority showAlert:(BOOL)showAlert{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            MyLog(@"LBLog 访问麦克风权限正常==========");
            if (hasAuthority) {
                hasAuthority(YES);
            }
        }else{
            if (showAlert) {
                [LBAlertController showAlertTitle:@"无法使用麦克风" content:@"请在iPhone的\"设置-隐私-麦克风\"中允许访问麦克风。" cancelString:@"取消" cancleBlock:nil sureString:@"去设置" sureBlock:^{
                    
                    // 需要在info.plist中添加 URL types 并设置一项URL Schemes为prefs   IOS10 以后不起作用
                    NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
//                    if (IOS10Later) {
//                        url =[NSURL URLWithString:@"Prefs:root=Privacy&path=CAMERA"];
//                    }
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                } currentController:nil];

            }
            if (hasAuthority) {
                hasAuthority(NO);
            }
            MyLog(@"LBLog 没有权限访问麦克风 ==========");
        }
        
    }];
}
@end
