//
//  LBScanView.m
//  nhExample
//
//  Created by liubin on 17/5/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBScanView.h"
#import "LBScanViewStyle.h"
#import "LBScanGridAnimationView.h"
#import "LBScanNative.h"


@interface LBScanView ()

@property (nonatomic, copy) NSString *readyString;

@property (nonatomic, strong) UILabel *readyLabel;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) LBScanViewStyle *scanStyle;

@property (nonatomic, strong) LBScanGridAnimationView *gridAnimationView;

/** 扫描的工具类 */
@property (nonatomic, strong) LBScanNative *scanOBJ;

/**
 * 扫描区域
 */
@property (nonatomic, assign) CGRect scanRect;

@end

@implementation LBScanView

-(instancetype)initWithFrame:(CGRect)frame scanStyle:(LBScanViewStyle *)scanStyle readyString:(NSString *)readyString{
    self = [super initWithFrame:frame];
    if (self) {
        self.scanStyle = scanStyle;
        self.readyString = readyString;
        [self showReadyDeviceState];
    }
    return self;
}



-(void)drawRect:(CGRect)rect{
    MyLog(@"LBLog scanView drawRect===========");
    [self drawScanRect];
    if (_scanStyle.animationStyle == LBScanAnimationStyleGrid) {
        [self.gridAnimationView startScanAnimating];
    }
    [self.scanOBJ startScan];
    
}

// 显示
-(void)showReadyDeviceState{
    
}

// 绘制扫描区域
-(void)drawScanRect{
    
    CGFloat leftMargin  = _scanStyle.offsetSideMargin;
    //默认宽高比为1:1
    CGSize scanSize = CGSizeMake(self.bounds.size.width - leftMargin * 2, self.bounds.size.width - leftMargin * 2);
    if(_scanStyle.whScale != 1){
        CGFloat height = scanSize.width/_scanStyle.whScale;
        scanSize = CGSizeMake(scanSize.width, height);
    }
    
    //计算距离  用来下面填充区域用的
    CGFloat scanMinY = self.bounds.size.height/2 - scanSize.height/2 - _scanStyle.offsetCenterUp;
    CGFloat scanMaxY = scanMinY + scanSize.height;
    CGFloat scanMinX = leftMargin;
    CGFloat scanMaxX = self.bounds.size.width - leftMargin;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //填充非扫描区域
    {
        const CGFloat *components = CGColorGetComponents(_scanStyle.noRecoginzeColor.CGColor);
        CGFloat redColor = components[0];
        CGFloat greenColor = components[1];
        CGFloat blueColor = components[2];
        CGFloat alpha = components[3];
        //设置填充颜色
        CGContextSetRGBFillColor(context, redColor, greenColor, blueColor, alpha);
        
        //填充矩形
        //扫描区域上面的填充
        CGRect upRect = CGRectMake(0, 0, self.bounds.size.width, scanMinY);
        CGContextFillRect(context, upRect);
        
        //扫描区域左边填充
        CGRect leftRect = CGRectMake(0, scanMinY, scanMinX, scanSize.height);
        CGContextFillRect(context, leftRect);
        
        //扫描区域下面的填充
        CGRect downRect = CGRectMake(0, scanMaxY, self.bounds.size.width, self.bounds.size.height-scanMaxY);
        CGContextFillRect(context, downRect);
        
        CGRect rightRect = CGRectMake(scanMaxX, scanMinY, leftMargin, scanSize.height);
        CGContextFillRect(context, rightRect);
    }
    
    //是否需要画边框
    if (_scanStyle.isNeedShowScanViewBorder) {
        CGContextSetStrokeColorWithColor(context, _scanStyle.borderColor.CGColor);
        CGContextSetLineWidth(context, 1.f);
        CGContextAddRect(context, CGRectMake(scanMinX, scanMinY, scanSize.width, scanSize.height));
        CGContextStrokePath(context);
    }
    _scanRect = CGRectMake(scanMinX, scanMinY, scanSize.width, scanSize.height);
    
    //显示4个角
    //
    CGFloat diffWidth = 0.f;
    switch (_scanStyle.cornerStyle) {
        case LBScanFrameCornerStyleOutter:
            {
                diffWidth = _scanStyle.cornerLineBorderWidth/3;
            }
            break;
        case LBScanFrameCornerStyleInner:
            {
                diffWidth = _scanStyle.cornerLineBorderWidth / 2;
            }
            break;
            
        default:
            {
                diffWidth = _scanStyle.cornerLineBorderWidth / 3;
            }
            break;
    }
    
    
    CGContextSetStrokeColorWithColor(context, _scanStyle.cornerColor.CGColor);
    CGContextSetRGBFillColor(context, 1.f, 1.f, 1.f, 1.f);
    
    CGContextSetLineWidth(context, _scanStyle.cornerLineBorderWidth);
    
    // 计算4个角要显示的位置
    CGFloat leftX = scanMinX - diffWidth;
    CGFloat topY = scanMinY - diffWidth;
    CGFloat rightX = scanMaxX + diffWidth;
    CGFloat bottomY = scanMaxY + diffWidth;
    
    //左上角水平线
    CGContextMoveToPoint(context, leftX - _scanStyle.cornerLineBorderWidth/2, topY);
    CGContextAddLineToPoint(context, leftX+_scanStyle.cornerLineW, topY);
    
    //左上角竖直线
    CGContextMoveToPoint(context, leftX, topY-_scanStyle.cornerLineBorderWidth/2);
    CGContextAddLineToPoint(context, leftX, topY+_scanStyle.cornerLineH);
    
    //右上角的水平线
    CGContextMoveToPoint(context, rightX + _scanStyle.cornerLineBorderWidth/2, topY);
    CGContextAddLineToPoint(context, rightX - _scanStyle.cornerLineW, topY);
    
    
    //右上角的竖线
    CGContextMoveToPoint(context, rightX, topY-_scanStyle.cornerLineBorderWidth/2);
    CGContextAddLineToPoint(context, rightX, topY+_scanStyle.cornerLineH);
    
    //左下角的水平下
    CGContextMoveToPoint(context, leftX - _scanStyle.cornerLineBorderWidth/2, bottomY);
    CGContextAddLineToPoint(context, leftX+_scanStyle.cornerLineW, bottomY);
    
    //左下角的竖线
    CGContextMoveToPoint(context, leftX, bottomY+_scanStyle.cornerLineBorderWidth/2);
    CGContextAddLineToPoint(context, leftX, bottomY-_scanStyle.cornerLineH);
    
    //右下角的水平线
    CGContextMoveToPoint(context, rightX + _scanStyle.cornerLineBorderWidth/2, bottomY);
    CGContextAddLineToPoint(context, rightX - _scanStyle.cornerLineW, bottomY);
    
    //右下角的竖线
    CGContextMoveToPoint(context, rightX, bottomY+_scanStyle.cornerLineBorderWidth/2);
    CGContextAddLineToPoint(context, rightX, bottomY-_scanStyle.cornerLineH);
    
    CGContextStrokePath(context);
}


/**
 * 开始扫描
 */
-(void)startScaning{
    [self.scanOBJ startScan];
    [self.gridAnimationView  startScanAnimating];
}


/**
 * 结束扫描
 */
-(void)stopScaning{
    [self.scanOBJ stopScan];
    [self.gridAnimationView stopScanAnimating];
    
}

-(LBScanGridAnimationView *)gridAnimationView{
    if (!_gridAnimationView) {
        _gridAnimationView = [[LBScanGridAnimationView alloc] initScanAnimationFrame:_scanRect superView:self image:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"]];
        [self addSubview:_gridAnimationView];
    }
    return _gridAnimationView;
}

-(LBScanNative *)scanOBJ{
    if (!_scanOBJ) {
        WS(weakSelf);
        CGRect scanR = [LBScanView getScanRectWithPreView:self.superview style:self.scanStyle];
        _scanOBJ = [[LBScanNative alloc] initWithSuperView:self.superview scanRect:scanR scanTypes:nil success:^(NSArray<LBScanResult *> *array) {
            NSLog(@"LBLog scanResult is %@ ",array);
            [weakSelf.gridAnimationView stopScanAnimating];
        }];
    }
    return _scanOBJ;
}

-(BOOL)isFlashAvailbe{
    return [self.scanOBJ isFlashAvalible];
}

-(void)setFlashState:(BOOL)isOn{
    [self.scanOBJ setFlashState:isOn];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc{
    MyLog(@"LBlog LBScanView  dealloc ==============");
}

//根据矩形区域，获取识别区域
+ (CGRect)getScanRectWithPreView:(UIView*)view style:(LBScanViewStyle*)style
{
    int XRetangleLeft = style.offsetSideMargin;
    CGSize sizeRetangle = CGSizeMake(view.frame.size.width - XRetangleLeft*2, view.frame.size.width - XRetangleLeft*2);
    
    if (style.whScale != 1)
    {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / style.whScale;
        
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        
        sizeRetangle = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = view.frame.size.height / 2.0 - sizeRetangle.height/2.0 - style.offsetCenterUp;
    //扫码区域坐标
    CGRect cropRect =  CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    
    
    //计算兴趣区域
    CGRect rectOfInterest;
    
    //ref:http://www.cocoachina.com/ios/20141225/10763.html
    CGSize size = view.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                    cropRect.origin.x/size.width,
                                    cropRect.size.height/fixHeight,
                                    cropRect.size.width/size.width);
        
        
    } else {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                    (cropRect.origin.x + fixPadding)/fixWidth,
                                    cropRect.size.height/size.height,
                                    cropRect.size.width/fixWidth);
        
        
    }
    
    
    return rectOfInterest;
}

@end
