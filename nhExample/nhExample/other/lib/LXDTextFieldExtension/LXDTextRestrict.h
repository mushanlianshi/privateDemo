//
//  LXDTextRestrict.h
//  LXDTextFieldAdjust
//
//  Created by linxinda on 16/9/23.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^LXDStringFilter)(NSString * aString);

typedef NS_ENUM(NSInteger, LXDRestrictType)
{
    LXDRestrictTypeOnlyNumber = 1,      ///< 只允许输入数字
    LXDRestrictTypeOnlyDecimal = 2,     ///<  只允许输入实数，包括.
    LXDRestrictTypeOnlyCharacter = 3,  ///<  只允许非中文输入
    LXDRestrictTypeNoneLimit=4,     //没有类型限制的输入
};

/*!
 *  文本限制
 */
@interface LXDTextRestrict : NSObject

@property (nonatomic, assign) NSUInteger maxLength;
/**
 * 自己添加的属性  来记录设置最大长度的
 */
@property (nonatomic, assign) NSUInteger max;
@property (nonatomic, readonly) LXDRestrictType restrictType;

+ (instancetype)textRestrictWithRestrictType: (LXDRestrictType)restrictType;
/**
 * 最好用这个方法初始化 限制长度和输入类型
 */
+ (instancetype)textRestrictWithRestrictType: (LXDRestrictType)restrictType maxLength:(NSUInteger)maxLength;
- (void)textDidChanged: (UITextField *)textField;

@end
