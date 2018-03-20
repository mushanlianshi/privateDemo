//
//  LBAvPlayerLightView.m
//  LBSamples
//
//  Created by liubin on 16/12/7.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "LBAvPlayerLightView.h"
#define Width 155
#define Height 155
@interface LBAvPlayerLightView()
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIImageView *ivLight;
@property (nonatomic, strong) UIView *lightViews;
@property (nonatomic, strong) UIView *longViews;
@property (nonatomic, strong) NSTimer *timer;//用来定时关闭显示的
@end
@implementation LBAvPlayerLightView

+(instancetype)sharedLightView{
    static LBAvPlayerLightView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LBAvPlayerLightView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:instance];
        [instance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo([UIApplication sharedApplication].keyWindow);
            make.centerY.equalTo([UIApplication sharedApplication].keyWindow).offset(-5);
            make.width.mas_equalTo(Width);
            make.height.mas_equalTo(Height);
        }];
    });
    return instance;
}

-(instancetype)init{
    if (self=[super init]) {
        self.layer.cornerRadius=10;
        self.clipsToBounds=YES;

        // 使用UIToolbar实现毛玻璃效果，背景色 简单粗暴，支持iOS7+
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
        toolbar.alpha = 0.97;
        [self addSubview:toolbar];
        
        self.lbTitle.frame=CGRectMake(0, 0, Width, 30);
        
        self.ivLight.frame=CGRectMake((Width-100)/2, 30, 100, 100);
        self.lightViews.frame=CGRectMake(0, 130, Width, 20);
        
        [self createTips];
        [self observerLightLevel];
        [self addOrientationChangeNotification];
        
        self.alpha=0.0f;
    }
    return self;
}

/** 创建底部15个指示等级的view */
-(void)createTips{
    CGFloat yOffset=1.f;
    NSInteger ivCounts=15;
    CGFloat margin=15;
    CGFloat ivWidth=(self.lightViews.bounds.size.width-margin*2-yOffset*(ivCounts+1))/ivCounts;
    CGFloat ivHieght=5.f;
    self.longViews.bounds=CGRectMake(0, 0, self.lightViews.bounds.size.width-2*margin, ivHieght+2*yOffset);
    self.longViews.center=CGPointMake(self.lightViews.bounds.size.width/2, self.lightViews.bounds.size.height/2);
    
    for (int i=0; i<ivCounts; i++) {
        UIView *iv=[[UIView alloc] initWithFrame:CGRectMake((i+1)*yOffset+i*ivWidth, yOffset, ivWidth, ivHieght)];
        iv.backgroundColor=[UIColor whiteColor];
        [self.longViews addSubview:iv];
    }
}
/** 监视亮度等级变化 */
-(void)observerLightLevel{
    [[UIScreen mainScreen] addObserver:self forKeyPath:@"brightness" options:NSKeyValueObservingOptionNew context:nil];
}
/** 添加屏幕旋转的通知 由于我们在这里布局使用的aotulayout 所以会自动相对改变 */
-(void)addOrientationChangeNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"change birghtness is %@ ",change[@"new"]);
    [self showLightnessWithValue:[change[@"new"] floatValue]];
}
-(void)orientationChanged:(NSNotification *)notification{
    
}

-(void)showLightnessWithValue:(CGFloat)value{
    [self appearLightView];
    [self updateLongView:value];
}
-(void)updateLongView:(CGFloat)value{
    NSInteger showCount=value*self.longViews.subviews.count;
    for (int i=0; i<self.longViews.subviews.count; i++) {
        UIView *iv=self.longViews.subviews[i];
        if (i<showCount) {
            iv.hidden=NO;
        }else{
            iv.hidden=YES;
        }
    }
}
-(void)appearLightView{
    if (self.alpha==0.0) {
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
        self.alpha=1.0f;
        [self updateTimer];
    }
    
}
-(void)disappearLightView{
    if (self.alpha==1.0f) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha=0.0f;
        }];
    }
}
-(void)updateTimer{
    [self removeTimer];
    [self addTimer];
}
-(void)removeTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer=nil;
    }
}
-(void)addTimer{
    if (!self.timer) {
        self.timer=[NSTimer timerWithTimeInterval:3.f target:self selector:@selector(disappearLightView) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}
#pragma mark view初始化
-(UILabel *)lbTitle{
    if (!_lbTitle) {
        _lbTitle=[[UILabel alloc] init];
        _lbTitle.textAlignment=NSTextAlignmentCenter;
        _lbTitle.textColor=[UIColor blackColor];
        _lbTitle.text=@"亮度";
        [self addSubview:_lbTitle];
    }
    return _lbTitle;
}

-(UIImageView *)ivLight{
    if (!_ivLight) {
        _ivLight=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LBAvPlayer.bundle/icon_brightness"]];
        [self addSubview:_ivLight];
    }
    return _ivLight;
}

-(UIView *)lightViews{
    if (!_lightViews) {
        _lightViews=[[UIView alloc] init];
        [self addSubview:_lightViews];
    }
    return _lightViews;
}

-(UIView *)longViews{
    if (!_longViews) {
        _longViews=[[UIView alloc] init];
        _longViews.backgroundColor=[UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        [self.lightViews addSubview:_longViews];
    }
    return _longViews;
}

-(void)dealloc{
    NSLog(@"lblight view deall0c=============");
    [self removeTimer];
    [[UIScreen mainScreen] removeObserver:self forKeyPath:@"brightness"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
