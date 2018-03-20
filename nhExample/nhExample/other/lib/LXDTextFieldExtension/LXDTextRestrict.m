//
//  LXDTextRestrict.m
//  LXDTextFieldAdjust
//
//  Created by linxinda on 16/9/23.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

#import "LXDTextRestrict.h"

@interface LXDTextRestrict ()
{
  
}
@property (nonatomic, readwrite) LXDRestrictType restrictType;

@end

@interface LXDNumberTextRestrict : LXDTextRestrict

@end

@interface LXDDecimalTextRestrict : LXDTextRestrict

@end

@interface LXDCharacterTextRestrict : LXDTextRestrict

@end
@interface LXDNoneLimitTextRestrict : LXDTextRestrict

@end


@implementation LXDTextRestrict

+ (instancetype)textRestrictWithRestrictType: (LXDRestrictType)restrictType
{
    LXDTextRestrict * textRestrict;
    switch (restrictType) {
        case LXDRestrictTypeOnlyNumber:
            textRestrict = [[LXDNumberTextRestrict alloc] init];
            break;
            
        case LXDRestrictTypeOnlyDecimal:
            textRestrict = [[LXDDecimalTextRestrict alloc] init];
            break;
            
        case LXDRestrictTypeOnlyCharacter:
            textRestrict = [[LXDCharacterTextRestrict alloc] init];
            break;
            
        default:
            break;
    }
    textRestrict.maxLength = NSUIntegerMax;
    textRestrict.restrictType = restrictType;
    return textRestrict;
}
+ (instancetype)textRestrictWithRestrictType: (LXDRestrictType)restrictType maxLength:(NSUInteger)maxLength{
    LXDTextRestrict * textRestrict;
    switch (restrictType) {
        case LXDRestrictTypeOnlyNumber:
            textRestrict = [[LXDNumberTextRestrict alloc] init];
            break;
            
        case LXDRestrictTypeOnlyDecimal:
            textRestrict = [[LXDDecimalTextRestrict alloc] init];
            break;
            
        case LXDRestrictTypeOnlyCharacter:
            textRestrict = [[LXDCharacterTextRestrict alloc] init];
            break;
        case LXDRestrictTypeNoneLimit:
            textRestrict = [[LXDNoneLimitTextRestrict alloc] init];
            break;
            
        default:
            break;
    }
    
    textRestrict.maxLength = maxLength;
    textRestrict.max=maxLength;
    textRestrict.restrictType = restrictType;
    return textRestrict;
}

-(void)setMaxLength:(NSUInteger)maxLength{
    _maxLength=maxLength;
}

-(void)setMax:(NSUInteger)max{
    _max=max;
}

- (void)textDidChanged: (UITextField *)textField
{
    
}

- (NSString *)restrictMaxLength: (NSString *)text
{
    if (text.length > _max) {
       
        text = [text substringToIndex: _max];
    }
    return text;
}

@end


static inline NSString * kFilterString(NSString * handleString, LXDStringFilter subStringFilter)
{
    NSMutableString * modifyString = handleString.mutableCopy;
    for (NSInteger idx = 0; idx < modifyString.length;) {
        NSString * subString = [modifyString substringWithRange: NSMakeRange(idx, 1)];
        if (subStringFilter(subString)) {
            idx++;
        } else {
            [modifyString deleteCharactersInRange: NSMakeRange(idx, 1)];
        }
    }
    return modifyString;
}

static inline BOOL kMatchStringFormat(NSString * aString, NSString * matchFormat)
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject: aString];
}


@implementation LXDNumberTextRestrict

- (void)textDidChanged: (UITextField *)textField
{
    NSString * filterText = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^\\d$");
    });
    //防止中文的时候 有联想词截取字符串崩溃的情况
    if ([textField markedTextRange]==nil) {
        textField.text = [super restrictMaxLength: filterText];
    }
//    textField.text = [super restrictMaxLength: filterText];
}

@end


@implementation LXDDecimalTextRestrict

- (void)textDidChanged: (UITextField *)textField
{
    NSString * filterText = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^[0-9.]$");
    });
    //防止中文的时候 有联想词截取字符串崩溃的情况
    if ([textField markedTextRange]==nil) {
        textField.text = [super restrictMaxLength: filterText];
    }
//    textField.text = [super restrictMaxLength: filterText];
}

@end


@implementation LXDCharacterTextRestrict

- (void)textDidChanged: (UITextField *)textField
{
    NSString * filterText = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^[^[\\u4e00-\\u9fa5]]$");
    });
    //防止中文的时候 有联想词截取字符串崩溃的情况
    if ([textField markedTextRange]==nil) {
        textField.text = [super restrictMaxLength: filterText];
    }
//    textField.text = [super restrictMaxLength: filterText];
}
@end

@implementation LXDNoneLimitTextRestrict

- (void)textDidChanged: (UITextField *)textField
{
//    NSString * filterText = kFilterString(textField.text, ^BOOL(NSString *aString) {
//        return kMatchStringFormat(aString, @"^[^[\\u4e00-\\u9fa5]]$");
//    });
    //防止中文的时候 有联想词截取字符串崩溃的情况
    if ([textField markedTextRange]==nil) {
        textField.text = [super restrictMaxLength: textField.text];
    }
    //    textField.text = [super restrictMaxLength: filterText];
}

@end



