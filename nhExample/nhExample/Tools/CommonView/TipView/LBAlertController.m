////
////  LBAlertController.m
////  nhExample
////
////  Created by liubin on 17/4/24.
////  Copyright © 2017年 liubin. All rights reserved.
////
//
#import "LBAlertController.h"

@implementation LBAlertController

+(void)showAlertTitle:(NSString *)title content:(NSString *)content currentController:(UIViewController *)currentController{
    [self showAlertTitle:title content:content cancelString:nil cancleBlock:nil sureString:@"确定" sureBlock:nil currentController:currentController];
    
}

+(void)showAlertTitle:(NSString *)title content:(NSString *)content currentController:(UIViewController *)currentController sureBlock:(dispatch_block_t)sureBlock{
    
    [self showAlertTitle:title content:content cancelString:@"取消" cancleBlock:nil sureString:@"确定" sureBlock:sureBlock currentController:currentController];
}

+(void)showAlertTitle:(NSString *)title content:(NSString *)content cancelString:(NSString *)cancelString cancleBlock:(dispatch_block_t)cancelBlock sureString:(NSString *)sureString sureBlock:(dispatch_block_t)sureBlock currentController:(UIViewController *)currentController{
    // 可以在别的封装里 使用  脱离VC
    currentController = currentController ? currentController : [self getCurrentVC];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelString && cancelString.length) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alertController addAction:cancelAction];
    }
    
    if (sureString && sureString.length) {
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sureBlock) {
                sureBlock();
            }
        }];
        [alertController addAction:sureAction];
    }
    
    [currentController presentViewController:alertController animated:YES completion:nil];
}


+(void)showSheetTitle:(NSString *)title content:(NSString *)content firstTitle:(NSString *)firstTitle firstBlock:(dispatch_block_t)firstBlock secondTitle:(NSString *)secondTitle secondBlock:(dispatch_block_t)secondBlock cancelString:(NSString *)cancelString cancelBlock:(dispatch_block_t)cancelBlock currentController:(UIViewController *)currentController{
    currentController = currentController ? currentController : [self getCurrentVC];
    // 可以在别的封装里 使用  脱离VC
    UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (firstTitle && firstTitle.length) {
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (firstBlock) {
                firstBlock();
            }
        }];
        [sheetController addAction:firstAction];
    }
    
    if (secondTitle && secondTitle.length) {
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (secondBlock) {
                secondBlock();
            }
        }];
        [sheetController addAction:secondAction];
    }
    
    NSString *cancelStr = cancelString.length ? cancelString : @"取消";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    [sheetController addAction:cancelAction];
    
    [currentController presentViewController:sheetController animated:YES completion:nil];
}

/** 获取当前正在显示的控制器 */
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


//
//+(void)showSureAlertView:(NSString *)title description:(NSString *)description surelTitle:(NSString *)surelTitle sureBlock:(LBAlertBlock)sureBlock currentController:(UIViewController *)currentController{
//    [self showSureAlertView:title description:description surelTitle:surelTitle sureBlock:sureBlock currentController:currentController type:LBAlertViewTypeDefault];
//}
//+(void)showSureAlertView:(NSString *)title description:(NSString *)description surelTitle:(NSString *)surelTitle sureBlock:(LBAlertBlock)sureBlock currentController:(UIViewController *)currentController type:(LBAlertViewType)type textFieldBlock:(LBAlertTextFieldBlock)textFieldBlock{
//    [self showAlertView:title description:description cancelTitle:nil sureString:surelTitle cancelBlock:nil sureBlock:sureBlock currentController:currentController type:type];
//}
//
//+(void)showAlertView:(NSString *)title description:(NSString *)description cancelTitle:(NSString *)cancelString sureString:(NSString *)sureString  cancelBlock:(LBAlertBlock)cancelBlock sureBlock:(LBAlertBlock)sureBlock currentController:(UIViewController *)currentController{
//    
//}
//+(void)showAlertView:(NSString *)title description:(NSString *)description cancelTitle:(NSString *)cancelString sureString:(NSString *)sureString  cancelBlock:(LBAlertBlock)cancelBlock sureBlock:(LBAlertBlock)sureBlock currentController:(UIViewController *)currentController type:(LBAlertViewType)type textFieldBlock:(LBAlertTextFieldBlock)textFieldBlock{
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:description preferredStyle:UIAlertControllerStyleAlert];
//    if (cancelString && cancelString.length) {
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            if (cancelBlock) {
//                cancelBlock(action);
//            }
//        }];
//        [alertController addAction:cancelAction];
//    }
//    
//    if (sureString && sureString.length) {
//        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            if (sureBlock) {
//                sureBlock(action);
//            }
//        }];
//        [alertController addAction:sureAction];
//    }
//    
//    if (type == LBAlertViewTypeInputTextField) {
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            
//        }];
//    }
//    
//}
@end
