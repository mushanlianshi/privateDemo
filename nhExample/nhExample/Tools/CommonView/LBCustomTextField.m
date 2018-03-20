//
//  LBCustomTextField.m
//  nhExample
//
//  Created by liubin on 17/4/6.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomTextField.h"

@interface LBCustomTextField()<UITextFieldDelegate>
{
    CGFloat _leftMargin;
    UIImage *_leftImage;
}
@end


@implementation LBCustomTextField


-(instancetype)initWithFrame:(CGRect)frame pleaceHolder:(NSString *)pleaceHolder pleaceHolderColor:(UIColor *)holderColor textColor:(UIColor *)textColor leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage leftMargin:(CGFloat)leftMargin{
    return [self initWithFrame:frame pleaceHolder:pleaceHolder pleaceHolderColor:holderColor textColor:textColor leftImage:leftImage rightImage:rightImage ImageSize:CGSizeZero leftMargin:leftMargin];
}

-(instancetype)initWithFrame:(CGRect)frame pleaceHolder:(NSString *)pleaceHolder pleaceHolderColor:(UIColor *)holderColor textColor:(UIColor *)textColor leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage ImageSize:(CGSize )imageSize leftMargin:(CGFloat)leftMargin{
    self= [super initWithFrame:frame];
    if (self) {
        self.maxLength = NSIntegerMax;
        _leftMargin = leftMargin;
        _leftImage = leftImage;
        self.placeholder = pleaceHolder;
        self.layerCornerRadius = 7;
        self.font = kFont(14);
        self.textColor = textColor;
        //        self.textColor = [UIColor redColor];
        //设置键盘的类别
        self.returnKeyType = UIReturnKeySearch;
        self.pleaceHolderColor = holderColor;
        self.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        //        self.pl
        leftImage = leftImage ? leftImage : ImageNamed(@"searchicon");
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:leftImage];
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (!CGSizeEqualToSize(imageSize, CGSizeZero)) {
            leftImageView.frame = CGRectMake(10, (self.bounds.size.height - imageSize.height)/2, imageSize.width, imageSize.height);
        }else{
            leftImageView.frame = CGRectMake(20, 0, leftImage.size.width, leftImage.size.height);
        }
        
        rightImage = rightImage ? rightImage : ImageNamed(@"deleteinput");
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteText)];
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:rightImage];
        if (!CGSizeEqualToSize(imageSize, CGSizeZero)) {
            rightImageView.frame = CGRectMake(self.bounds.size.width - imageSize.width - 20, (self.bounds.size.height - imageSize.height)/2, imageSize.width, imageSize.height);
        }else{
            rightImageView.frame = CGRectMake(frame.size.width - 20, 0, leftImage.size.width, leftImage.size.height);
        }
        
        rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        rightImageView.userInteractionEnabled = YES;
        [rightImageView addGestureRecognizer:tapGesture];
        
        self.leftView = leftImageView;
        //左边图片显示的类型
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightView = rightImageView;
        self.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        /** 用来设置高亮图片用的   不用代理是防止别的地方用顶掉了没效果 */
        [self addTarget:self action:@selector(textFieldBeginEdit:) forControlEvents:UIControlEventEditingDidBegin];
        [self addTarget:self action:@selector(textFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
        // 用来处理字符串长度   以及不能有中文的
        [self addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

/** 右面图片点击的事件  有回调就回调处理  没有就默认清楚字符串 */
-(void)deleteText{
    if (self.rightTapHandler){
        self.rightTapHandler(self);
    }else{
        self.text = @"";
        self.rightViewMode = UITextFieldViewModeNever;
    }
    
}

#pragma mark 设置左右图片的
//-(void)setLeftImage:(UIImage *)leftImage{
//    if (!leftImage) return;
//    _leftImage = leftImage;
//    UIImageView *leftImageView = (UIImageView *)self.leftView;
//    if(leftImageView && [leftImageView isKindOfClass:[UIImageView class]]){
//        leftImageView.image = leftImage;
//    }
//}

-(void)setRightImage:(UIImage *)rightImage{
    if (!rightImage) return;
    _rightImage = rightImage;
    UIImageView *rightImageView = (UIImageView *)self.rightView;
    if (rightImageView && [rightImageView isKindOfClass:[UIImageView class]]) {
        rightImageView.image = rightImage;
    }
}

#pragma mark 是否显示右边的删除按钮 根据显示的mode来设置
-(void)setShowRightImage:(BOOL)showRightImage{
    _showRightImage = showRightImage;
    UITextFieldViewMode mode = showRightImage ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
    self.rightViewMode = mode;
}


#pragma mark 根据key- value设置提示的样色
- (void)setPleaceHolderColor:(UIColor *)pleaceHolderColor{
    _pleaceHolderColor = pleaceHolderColor;
    [self setValue:pleaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
}


#pragma mark 子控件的rect位置

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x += 10;
    return rect;
}
-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect.origin.x -= 10;
    return rect;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x += _leftMargin;
    return rect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x += _leftMargin;
    return rect;
}

#pragma mark 键盘出现消失的处理

-(void)keyBoardWillShow:(NSNotification *)notification{
    MyLog(@"keyBoardWillShow ---- %@ ",notification);
    if (self.isFirstResponder) {
        NSValue *value = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
        CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect rect = [value CGRectValue];
        CGFloat keyBorderH = rect.size.height;
        CGRect tfFrame = [self.superview convertRect:self.frame toView:KeyWindow];
        CGFloat offset =(CGRectGetMaxY(tfFrame) + keyBorderH) - kScreenHeight + 10;
        MyLog(@"offset is %f %@ %f ",offset,NSStringFromCGRect(tfFrame),keyBorderH);
        //判断是否遮盖
        if(offset > 0 ){
            [UIView animateWithDuration:duration animations:^{
                KeyWindow.y =-offset;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

-(void)keyBoardWillHidden:(NSNotification *)notification{
    MyLog(@"keyBoardWillHidden ---- %@ ",notification);
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        KeyWindow.y=0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark textFiled 事件  处理高亮图片的

-(void)textFieldBeginEdit:(UITextField *)textField{
    UIImageView *imageView = (UIImageView *)self.leftView;
    if (self.leftHightImage && imageView && [imageView isKindOfClass:[UIImageView class]]) {
        imageView.image = self.leftHightImage;
    }
    
}

-(void)textFieldEndEdit:(UITextField *)textField{
    UIImageView *imageView = (UIImageView *)self.leftView;
    if (_leftImage && imageView && [imageView isKindOfClass:[UIImageView class]]) {
        imageView.image = _leftImage;
    }
}

-(void)textFieldChanged:(UITextField *)textField{
    if (self.isSecurity) {
        self.secureTextEntry = YES;
    }
    if (self.isNoChinese) {
        textField.text = kFilterString(textField.text, ^BOOL(NSString *filterString) {
            return kMatchStringFormat(filterString, @"^[^[\\u4e00-\\u9fa5]]$");
        });
    }
    
    //防止中文的时候 有联想词截取字符串崩溃的情况
    if ([textField markedTextRange]==nil) {
        textField.text = [self restrictMaxLength:textField.text];
    }
//    if (self.showRightImage && textField.text.length) {
//        self.rightViewMode = UITextFieldViewModeAlways;
//    }
//    if (textField.text.length == 0) {
//        self.rightViewMode = UITextFieldViewModeNever;
//    }
}

/** 截取最长字符串 */
-(NSString *)restrictMaxLength:(NSString *)string{
    if (string.length > self.maxLength) {
        string = [string substringToIndex:self.maxLength];
    }
    return string;
}


#pragma mark 字符串匹配用的
static inline NSString * kFilterString(NSString * handleString, LBStringFilter subStringFilter)
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

@end



