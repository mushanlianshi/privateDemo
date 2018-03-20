//
//  LBScanNative.m
//  nhExample
//
//  Created by liubin on 17/5/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBScanNative.h"
#import <AVFoundation/AVFoundation.h>
#import "LBScanResult.h"

@interface LBScanNative()<AVCaptureMetadataOutputObjectsDelegate>

/** 设备 */
@property (nonatomic, strong) AVCaptureDevice *device;

/** 连接 */
@property (nonatomic, strong) AVCaptureSession *session;

/** 输入 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;

/** 输出 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

/** 拍照用的输出 */
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImaeOutput;

/** 扫描的layer */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

/** 注意用weak不然会循环引用  */
@property (nonatomic, weak) UIView *superView;

/** 扫描区域 */
@property (nonatomic, assign) CGRect scanRect;

/** 扫描二维码的类型的数组 */
@property (nonatomic, copy) NSArray *scanTypes;

@property (nonatomic, copy) void(^successBlock)(NSArray <LBScanResult *> *array);

@property (nonatomic, strong) NSMutableArray *scanResults;

@end

@implementation LBScanNative

-(instancetype)initWithSuperView:(UIView *)superView scanRect:(CGRect)scanRect scanTypes:(NSArray *)scanTypes success:(void (^)(NSArray<LBScanResult *> *))success{
    self = [super init];
    if (self) {
        self.superView = superView;
        self.scanRect = scanRect;
        self.successBlock = success;
        [self initDevice];
    }
    return self;
}

/** 初始化设备 */
-(void)initDevice{
    
    
    
    //1.获取设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_device) {
        return;
    }
    
    //创建输入
    _input = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:nil];
    if (!_input) {
        return;
    }
    
    //创建输出流  设置输出流设置
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描区域
    if (!CGRectEqualToRect(self.scanRect, CGRectZero)) {
        _output.rectOfInterest = self.scanRect;
//        [_output setRectOfInterest:CGRectMake(0.25, 0.25, 0.5, 0.5)];//中心扫描
    }
    

    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    if (!self.scanTypes) {
        self.scanTypes = [self defaultScanTypes];
    }
    _output.metadataObjectTypes = self.scanTypes;
    
    //创建扫描的preview
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.superView.bounds;
    [self.superView.layer insertSublayer:_previewLayer atIndex:0];
    
    _stillImaeOutput = [[AVCaptureStillImageOutput alloc] init];
    //设置拍照输出的 格式jpg等
    [_stillImaeOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    
    AVCaptureConnection *videoConnetction = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImaeOutput] connections]];
    //焦距1
    videoConnetction.videoScaleAndCropFactor = 1.;
    
    //判断是否自动对焦功能 开始
    if (_device.isFocusPointOfInterestSupported && [_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
        [_input.device lockForConfiguration:nil];
        [_input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [_input.device unlockForConfiguration];
    }
    
    //添加屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}


/** 处理屏幕旋转后的扫描方向 */
-(void)orientationChanged:(NSNotification *)notification{
    NSLog(@"LBLog orientationChanged================");
    _previewLayer.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
}
- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    UIInterfaceOrientation orientation=[[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation){
            //    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait: {
            return AVCaptureVideoOrientationPortrait;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            return AVCaptureVideoOrientationLandscapeLeft;
        }
        case UIInterfaceOrientationLandscapeRight: {
            return AVCaptureVideoOrientationLandscapeRight;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
    }
    return AVCaptureVideoOrientationPortrait;
}

#pragma mark 扫描的代理 

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count) {
        MyLog(@"LBLog 扫描结果是 %@ ",metadataObjects);
        [self stopScan];
        for (AVMetadataObject *object in metadataObjects) {
            if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                LBScanResult *result = [[LBScanResult alloc] init];
                result.resultString = [(AVMetadataMachineReadableCodeObject *)object stringValue];
                result.qrCodeType = [(AVMetadataMachineReadableCodeObject *)object type];
                [self.scanResults addObject:result];
            }
        }
        
        if (self.isNeedCaptureImage) {
            [self captureImage];
        }else{
            if (self.successBlock) {
                self.successBlock(self.scanResults);
            }
        }
    }else{
        if (self.successBlock) {
            self.successBlock(nil);
        }
    }
}

/** 捕获图片 */
-(void)captureImage{
    WS(weakSelf);
    AVCaptureConnection *connect = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImaeOutput] connections]];
    [[self stillImaeOutput] captureStillImageAsynchronouslyFromConnection:connect completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        [weakSelf stopScan];
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *img = [UIImage imageWithData:imageData];
            for (LBScanResult *result in weakSelf.scanResults) {
                result.image = img;
            }
        }
        if(weakSelf.successBlock){
            weakSelf.successBlock(weakSelf.scanResults);
        }
    }];
}

-(void)startScan{
    if (_input && !_session.isRunning) {
        [_session startRunning];
        [self.superView.layer insertSublayer:_previewLayer atIndex:0];
    }
}

-(void)stopScan{
    if (_input && _session.isRunning) {
        [_session stopRunning];
    }
}

-(void)setFlashState:(BOOL)isOn{
    [self.input.device lockForConfiguration:nil];
    self.input.device.torchMode = isOn ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    [self.input.device unlockForConfiguration];
}

-(BOOL)isFlashAvalible{
    return self.device.torchAvailable;
}

/** 获取一个连接 根据传的类型  和数组 */
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections
{
    for ( AVCaptureConnection *connection in connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}

/** 默认扫描二维码的类型 */
-(NSArray *)defaultScanTypes{
    NSMutableArray *types = [@[AVMetadataObjectTypeQRCode,
                               AVMetadataObjectTypeUPCECode,
                               AVMetadataObjectTypeCode39Code,
                               AVMetadataObjectTypeCode39Mod43Code,
                               AVMetadataObjectTypeEAN13Code,
                               AVMetadataObjectTypeEAN8Code,
                               AVMetadataObjectTypeCode93Code,
                               AVMetadataObjectTypeCode128Code,
                               AVMetadataObjectTypePDF417Code,
                               AVMetadataObjectTypeAztecCode] mutableCopy];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_0)
    {
        [types addObjectsFromArray:@[
                                     AVMetadataObjectTypeInterleaved2of5Code,
                                     AVMetadataObjectTypeITF14Code,
                                     AVMetadataObjectTypeDataMatrixCode
                                     ]];
    }
    
    return types;
}



-(NSMutableArray *)scanResults{
    if (!_scanResults) {
        _scanResults = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _scanResults;
}



+(void)recognizeImage:(UIImage *)image success:(void (^)(NSArray<LBScanResult *> *))success{
    if (!image) {
        return;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
        LBScanResult *result = [[LBScanResult alloc] init];
        result.resultString = @"只支持ios8.0之后系统";
        result.image = image;
        success(@[result]);
        return;
    }
    ////初始化识别器 设置精度高
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *featuresArray = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:1];
    if(featuresArray.count){
        for (CIQRCodeFeature *feature in featuresArray) {
            NSString *string = [feature messageString];
            LBScanResult *result = [[LBScanResult alloc] init];
            result.resultString = string;
            result.image = image;
            [resultArray addObject:result];
        }
    }
    
    if (success) {
        success(resultArray);
    }
    
}

+(UIImage *)createQRCodeString:(NSString *)string QRSize:(CGSize)qrSize{
    /** 生成指定大小的黑白二维码 */
    
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //    NSLog(@"%@",qrFilter.inputKeys);
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    //放大并绘制二维码 (上面生成的二维码很小，需要放大)
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(qrSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //翻转一下图片 不然生成的QRCode就是上下颠倒的
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

+(UIImage *)createQRCodeString:(NSString *)string QRSize:(CGSize)qrSize logoImage:(UIImage *)logoImage logoType:(LBQRCodeLogoType)logoType{
    return [self createQRCodeString:string QRSize:qrSize logoImage:logoImage logoSize:CGSizeZero logoType:logoType];
}

+(UIImage *)createQRCodeString:(NSString *)string QRSize:(CGSize)qrSize logoImage:(UIImage *)logoImage logoSize:(CGSize)logoSize logoType:(LBQRCodeLogoType)logoType{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //    NSLog(@"%@",qrFilter.inputKeys);
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    //放大并绘制二维码 (上面生成的二维码很小，需要放大)
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(qrSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //翻转一下图片 不然生成的QRCode就是上下颠倒的
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    //1.获取到二维码图片
    UIImage *qrImg = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(cgImage);
    UIGraphicsEndImageContext();
    //2.合成图片
    if (logoImage) {
        //获取到图片上下文 此方法画的图片有的不清晰   用下面的图片画的清晰
//        UIGraphicsBeginImageContext(qrImg.size);
        UIGraphicsBeginImageContextWithOptions(qrImg.size, NO, 0.0);
        //1.绘制大图
        [qrImg drawInRect:CGRectMake(0, 0, qrImg.size.width, qrImg.size.height)];
        CGSize imageSize = (CGSizeEqualToSize(logoSize, CGSizeZero)) ? logoImage.size : logoSize;
        
        //2.绘制小图
        if (logoType == LBQRCodeLogoTypeCenter) {
            [logoImage drawInRect:CGRectMake((qrSize.width -imageSize.width)/2, (qrSize.height-imageSize.height)/2, imageSize.width, imageSize.height)];
        }else if (logoType == LBQRCodeLogoTypeRightBottom){
            [logoImage drawInRect:CGRectMake(qrSize.width - imageSize.width -10, qrSize.height - imageSize.height - 10, imageSize.width, imageSize.height)];
        }
        
        qrImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();//关闭上下文
    }
    
    
    return qrImg;
}


+ (UIImage*)createQRWithString:(NSString*)text QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor
{
    
    NSData *stringData = [text dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bkColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}


+ (UIImage*)createBarCodeWithString:(NSString*)text QRSize:(CGSize)size
{
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *barcodeImage = [filter outputImage];
    
    // 消除模糊
    
    CGFloat scaleX = size.width / barcodeImage.extent.size.width; // extent 返回图片的frame
    
    CGFloat scaleY = size.height / barcodeImage.extent.size.height;
    
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    MyLog(@"LBlog LBScanNative  dealloc ==============");
}


@end
