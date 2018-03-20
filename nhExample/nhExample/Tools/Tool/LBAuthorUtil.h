//
//  LBAuthorUtil.h
//  nhExample
//
//  Created by liubin on 17/5/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 权限管理的一些工具类
 */
@interface LBAuthorUtil : NSObject


/**
 是否有相册的权限

 @param showAlert 默认显示对话框  跳转到设置界面
 @return 权限
 */
+(BOOL)isHasPhotoLibraryAuthority:(BOOL)showAlert;


/**
 是否有相机的权限

 @param showAlert 默认是否显示对话框  跳转到设置界面
 @return 权限
 */
+(BOOL)isHasCameraAuthority:(BOOL)showAlert;

/**
 是否有定位的权限
 
 @param showAlert 默认是否显示对话框  跳转到设置界面
 @return 权限
 */
+(BOOL)isHasLocationAuthority:(BOOL)showAlert;


/**
 是否有麦克风的权限
 
 @param showAlert 默认是否显示对话框  跳转到设置界面
 */
+(void)isHasMicrophoneAuthority:(void (^)(BOOL isAuthority))hasAuthority showAlert:(BOOL)showAlert;











//其他界面参数配置  跳转界面的设置参数
//
//（2）、得到验证打开设置的路径：
//
//Prefs:root=General&path=About   (关于)
//
//Prefs:root=General&path=ACCESSIBILITY(辅助功能)
//
//Prefs:root=General&path=AUTOLOCK(通用)
//
//Prefs:root=Brightness(找不到，跳到设置页面)
//
//Prefs:root=General&path=DATE_AND_TIME（时间）
//
//Prefs:root=FACETIME(FaceTime)
//
//Prefs:root=General（通用）
//
//Prefs:root=General&path=Keyboard(键盘)
//
//Prefs:root=CASTLE(iCloud)
//
//Prefs:root=CASTLE&path=STORAGE_AND_BACKUP(存储空间)
//
//Prefs:root=General&path=INTERNATIONAL(语言与地区)
//
//Prefs:root=LOCATION_SERVICES(找不到，跳到设置页面)
//
//Prefs:root=MUSIC(音乐)
//
//Prefs:root=MUSIC&path=EQ(音乐均衡器)
//
//Prefs:root=MUSIC&path=VolumeLimit(音乐的音量限制)
//
//Prefs:root=NOTES(备忘录)
//
//Prefs:root=NOTIFICATIONS_ID(通知)
//
//Prefs:root=Phone(电话)
//
//Prefs:root=Photos(照片与相机)
//
//Prefs:root=General&path=ManagedConfigurationList(描述文件)
//
//Prefs:root=General&path=Reset(还原)
//
//Prefs:root=Sounds(声音)
//
//Prefs:root=General&path=SOFTWARE_UPDATE_LINK(软件更新)
//
//Prefs:root=STORE(iTunes Store与App Store)
//
//Prefs:root=TWITTER(Twitter)
//
//Prefs:root=Wallpaper(墙纸)
//
//Prefs:root=WIFI(无线局域网)
//
//Prefs:root=Privacy&path=CONTACTS（通讯录）
//
//（3）、跳转到设置页面关于 （iOS10以后）注意首字母改成了大写，prefs->Prefs
@end
