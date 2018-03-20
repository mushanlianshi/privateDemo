//
//  LBGuideScrollViewController.h
//  UIDemoCollection
//
//  Created by 123 on 16/8/22.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBGuideScrollViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic,strong)NSArray *imageData;

-(id)initGuideVCwithImageArray:(NSArray *)imageArray;

/** 显示guideController 的方法 */
-(void)showGuideController;

/** 判断是否需要显示新特性的方法 */
+(BOOL)isShowNewFeature;

@end
