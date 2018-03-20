//
//  LBTips.m
//  LBSamples
//
//  Created by liubin on 16/11/18.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "LBTips.h"
#import "Masonry.h"
#define ANIMATION_DURATION 0.5
#define ANIMATION_PAUSETIME 1.0
#define TIPS_FONT  [UIFont systemFontOfSize:14]
@interface LBTips()
{
    UILabel *label;
}
@end
@implementation LBTips

-(void)showTips:(NSString *)message{
    CGFloat width=[self getWidthByString:message limitHeight:30 font:TIPS_FONT];
    label=[[UILabel alloc] init];
    label.text=message;
    label.font=TIPS_FONT;
//    label.backgroundColor=[UIColor colorWithRed:0.7 green:0.7 blue:07 alpha:0.7];
//    label.textColor=[UIColor blackColor];
    UIWindow *keyWindow=[UIApplication sharedApplication].keyWindow;
    label.layer.cornerRadius=5;
//    label.clipsToBounds=YES;
    label.numberOfLines=0;
    [label sizeToFit];
    
    label.textAlignment=NSTextAlignmentCenter;
//    label.center=CGPointMake(keyWindow.center.x, keyWindow.bounds.size.height*0.85);
//    label.bounds=CGRectMake(0, 0, label.bounds.size.width+20, label.bounds.size.height+12);
    [keyWindow addSubview:label];
    if (width>keyWindow.bounds.size.width-40) {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(keyWindow).offset(20);
            make.right.equalTo(keyWindow).offset(-20);
            make.bottom.equalTo(keyWindow).offset(-20);
        }];
    }else{
            label.center=CGPointMake(keyWindow.center.x, keyWindow.bounds.size.height*0.85);
            label.bounds=CGRectMake(0, 0, label.bounds.size.width+20, label.bounds.size.height+12);
    }
    
    label.backgroundColor=[UIColor lightGrayColor];
    label.textColor=[UIColor blackColor];
    
    CABasicAnimation *theAnimation;
    //1.创建一个透明度动画
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=ANIMATION_DURATION;
    theAnimation.fromValue=[NSNumber numberWithFloat:0.0];
    theAnimation.toValue=[NSNumber numberWithFloat:1.0];
//    theAnimation.delegate=self;
    //2.动画的key我们可以根据key来暂停移除动画等。
//    [label.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    CABasicAnimation *disAnimation;
    //1.创建一个透明度动画
    disAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    disAnimation.duration=ANIMATION_DURATION;
    disAnimation.beginTime=ANIMATION_DURATION+ANIMATION_PAUSETIME;
    disAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    disAnimation.toValue=[NSNumber numberWithFloat:0.0];
    //2.动画的key我们可以根据key来暂停移除动画等。
//    [label.layer addAnimation:disAnimation forKey:@"disAnimation"];
    CAAnimationGroup *group=[[CAAnimationGroup alloc] init];
    group.duration=ANIMATION_DURATION*2+ANIMATION_PAUSETIME;
    group.animations=@[theAnimation,disAnimation];
    //3.设置代理是为了监控动画结束的时候 移除label
    group.delegate=self;
    //保证这个animation结束后不要被移除出layer 这样回调里才能判断
    group.removedOnCompletion = NO;
    [label.layer addAnimation:group forKey:@"group"];
    [self performSelector:@selector(dismissLabel) withObject:nil afterDelay:3.95];
    [label layoutIfNeeded];
    NSLog(@"label frame is %@ ",NSStringFromCGRect(label.frame));
}

-(CGFloat)getWidthByString:(NSString *)content limitHeight:(CGFloat)limitHeight font:(UIFont *)font{
    CGRect rect=[content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, limitHeight) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}
/** 用定时器移除label  是为了防止代理中移除会出现一闪的情况 */
-(void)dismissLabel{
    [label removeFromSuperview];
}
//-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    //判断最后一个动画结束  移除view
//    if ([label.layer animationForKey:@"group"]==anim){
//        [label removeFromSuperview];
//    }else{
//        NSLog(@"animationDidStop ========other");
//        
//    }
//}
+(void)showTips:(NSString *)message{
    [[[[LBTips class] alloc] init] showTips:message];
}

+(void)showTipsTotally{
    NSLog(@"渐变回去=================label ");
//    CABasicAnimation *animation=(CABasicAnimation *)[label.layer animationForKey:@"animateOpacity"];
//    if (animation) {
//        [label.layer removeAllAnimations];
//    }
}
+(void)showCancelAlert:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)dealloc{
    NSLog(@"LBTips dealloc======================");
}
@end
