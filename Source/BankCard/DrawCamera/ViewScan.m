//
//  ViewController.m
//  TestCamera
//
//  Created by zzzili on 13-9-24.
//  Copyright (c) 2013年 zzzili. All rights reserved.
//

#import "ViewScan.h"
#include "IOSOCRAPI.h"
#include "Globaltypedef.h"
#import "targetconditionals.h"
#define TOP_LINE_EXIST		(1<<0)//0x0001上边线
#define LEFT_LINE_EXIST		(1<<1)//0x0010左边线
#define BOTTOM_LINE_EXIST	(1<<2)//0x0100下边线
#define RIGHT_LINE_EXIST	(1<<3)//0x1000右边线
int width =0;
int height = 0;
BOOL isRun = FALSE;
@interface ViewScan ()

@end

@implementation ViewScan
- (id)initWithFrame:(CGRect)frame {
//    if ((self = [super initWithFrame:frame])) {
//        // Initialization code
//       
//        self.drawView = [[CameraBankDrawView alloc]initWithFrame:frame];
//        self.drawView.backgroundColor = [UIColor clearColor];
//        self.cameraView = [[UIView alloc] initWithFrame:frame];
//        self.cameraView.backgroundColor = [UIColor blueColor];
//        
//        [self addSubview:self.cameraView];
//        [self addSubview:self.drawView];
//        UIButton *pop = [UIButton buttonWithType:UIButtonTypeCustom];
//        pop.frame = CGRectMake(80, 20, 50, 50);
//        [pop setTitle:@"返回" forState:UIControlStateNormal];
//        [pop addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
//        [self.drawView addSubview:pop];
//        [self initialize];
//        isRun = FALSE;
//    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = [[UIScreen mainScreen] bounds];
    int width = frame.size.width;
    int height = frame.size.height;
    CGRect frame1 = CGRectMake(0, 0, width, height);
    if (width > height) {
        frame1 = CGRectMake(0, 0, height, width);
    }
    TREC_StartUP();
    self.drawView = [[CameraDrawView alloc]initWithFrame:frame1];
    self.drawView.backgroundColor = [UIColor clearColor];
    self.cameraView = [[UIView alloc] initWithFrame:frame1];
    self.cameraView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:self.cameraView];
    [self.view addSubview:self.drawView];
    UIButton *pop = [UIButton buttonWithType:UIButtonTypeCustom];
    pop.frame = CGRectMake(80, 20, 50, 50);
    [pop setTitle:@"返回" forState:UIControlStateNormal];
    [pop addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.drawView addSubview:pop];
    [self initialize];
    isRun = FALSE;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
//iOS6+
- (BOOL)shouldAutorotate
{
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //    return [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationPortrait;
}
#endif
- (void)pop:(UIButton *)button {
    [self cancelAction];
}
- (void)cancelAction {
    [_session stopRunning];
    [_session removeInput:_captureInput];
    [_session removeOutput:_captureOutput];
    
//    [_customLayer release];
//    [_session release];
    
    
    
    [self.drawView removeFromSuperview];
    [self.cameraView removeFromSuperview];
    
    //[self removeFromSuperview];
//    if (self.navigationController) {
//        if (self.navigationController.viewControllers.count == 1) {
//            [self.navigationController dismissModalViewControllerAnimated:YES];
//        } else {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } else {
//        [self dismissModalViewControllerAnimated:YES];
//    }
    TREC_ClearUP();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 
                                 (int64_t)(0.01 * NSEC_PER_SEC)),
                   
                   dispatch_get_main_queue(), ^{
                       if (![self.presentedViewController isBeingDismissed]) {
                           
                           [self dismissViewControllerAnimated:YES completion:nil];
                           
                       }});
                    
}



//- (void)dealloc {
//    
//    [super dealloc];
//}
- (CGRect) calcRect:(CGSize)imageSize cropRect:(CGRect) cpRect{
    NSString* gravity = _preview.videoGravity;
    CGRect cropRect = cpRect;
    CGSize screenSize = _preview.bounds.size;
    
    CGFloat screenRatio = screenSize.height / screenSize.width ;
    CGFloat imageRatio = imageSize.height /imageSize.width;
    
    CGRect presentImageRect = _preview.bounds;
    CGFloat scale = 1.0;
    
    
    if([AVLayerVideoGravityResizeAspect isEqual: gravity]){
        
        CGFloat presentImageWidth = imageSize.width;
        CGFloat presentImageHeigth = imageSize.height;
        if(screenRatio > imageRatio){
            presentImageWidth = screenSize.width;
            presentImageHeigth = presentImageWidth * imageRatio;
            
        }else{
            presentImageHeigth = screenSize.height;
            presentImageWidth = presentImageHeigth / imageRatio;
        }
        
        presentImageRect.size = CGSizeMake(presentImageWidth, presentImageHeigth);
        presentImageRect.origin = CGPointMake((screenSize.width-presentImageWidth)/2.0, (screenSize.height-presentImageHeigth)/2.0);
        
    }else if([AVLayerVideoGravityResizeAspectFill isEqual:gravity]){
        
        CGFloat presentImageWidth = imageSize.width;
        CGFloat presentImageHeigth = imageSize.height;
        if(screenRatio > imageRatio){
            presentImageHeigth = screenSize.height;
            presentImageWidth = presentImageHeigth / imageRatio;
        }else{
            presentImageWidth = screenSize.width;
            presentImageHeigth = presentImageWidth * imageRatio;
        }
        
        presentImageRect.size = CGSizeMake(presentImageWidth, presentImageHeigth);
        presentImageRect.origin = CGPointMake((screenSize.width-presentImageWidth)/2.0, (screenSize.height-presentImageHeigth)/2.0);
        
    }else{
        NSAssert(0, @"dont support:%@",gravity);
    }
    
    scale = CGRectGetWidth(presentImageRect) / imageSize.width;
    
    CGRect rect = cropRect;
    rect.origin = CGPointMake(CGRectGetMinX(cropRect)-CGRectGetMinX(presentImageRect), CGRectGetMinY(cropRect)-CGRectGetMinY(presentImageRect));
    
    rect.origin.x /= scale;
    rect.origin.y /= scale;
    rect.size.width = imageSize.width - rect.origin.x;
    rect.size.height  = imageSize.height - rect.origin.y;
    
    return rect;
}
//初始化
- (void) initialize
{
    //1.创建会话层
    _session = [[AVCaptureSession alloc] init];
    width = [[UIScreen mainScreen] bounds].size.width;
    height = [[UIScreen mainScreen] bounds].size.height;
    if (height < 568 ) {
        [_session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    else
    {
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    //2.创建、配置输入设备
	
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == AVCaptureDevicePositionBack)
        {
           _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        }
    }
    NSError *error;
	if (!_captureInput)
	{
		NSLog(@"Error: %@", error);
		return;
	}
    [_session addInput:_captureInput];
 

    ///out put
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc]
                                               init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    //captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
//    dispatch_release(queue);
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber
                       numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary
                                   dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [_session addOutput:captureOutput];
    
    ///custom Layer
    self.customLayer = [CALayer layer];
    self.customLayer.frame = [[UIScreen mainScreen] bounds];
    self.customLayer.transform = CATransform3DRotate(
                                                     CATransform3DIdentity, M_PI/2.0f, 0, 0, 1);
    self.customLayer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view.layer addSublayer:self.customLayer];
    //3.创建、配置输出
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [_captureOutput setOutputSettings:outputSettings];
	[_session addOutput:_captureOutput];
    
    ////////////
    CGRect frame = [[UIScreen mainScreen] bounds];
    int width = frame.size.width;
    int height = frame.size.height;
    CGRect frame1 = CGRectMake(0, 0, width, height);
    if (width > height) {
        frame1 = CGRectMake(0, 0, height, width);
    }
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = frame1;
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.cameraView.layer addSublayer:_preview];
    [_session startRunning];
}

//从摄像头缓冲区获取图像
#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (isRun == false) {
        isRun = TRUE;
//    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress,
                                                    width, height, 8, bytesPerRow, colorSpace,
                                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    UIImage *image= [UIImage imageWithCGImage:newImage scale:1 orientation:UIImageOrientationLeftMirrored];
    CGImageRelease(newImage);
    [self performSelectorOnMainThread:@selector(detectInUIImage:)
                           withObject: (id) image waitUntilDone:NO];
    //[image release];
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
//    [pool drain];
    }
    
}

/////引擎识别
-(void)detectInUIImage:(UIImage *)image
{
#if TARGET_IPHONE_SIMULATOR == 0
    //NSString *jpgPath = [NSHomeDirectory()
    //                     stringByAppendingPathComponent:@"Documents/Test.jpg"];
    //NSData *imageData1 =  UIImageJPEGRepresentation(image, 1.0);
    //[imageData1 writeToFile:jpgPath atomically:YES];
    int width1 = CGImageGetWidth(image.CGImage);
    int height1 = CGImageGetHeight(image.CGImage);
    int ret1 = TREC_SetSupportEngine(TIDBANK);
    if (ret1 != 1) {
        NSLog(@"引擎不支持");
        [self cancelAction];
        return;
    }
    TBANK_LoadImage(image);
    int bx =self.drawView.beginPoint.x;
    int by =self.drawView.beginPoint.y;
    int ex =self.drawView.endPoint.x ;
    int ey =self.drawView.endPoint.y ;
    int x1 = 0,y1 = 0,x2 = 0,y2 = 0;
    CGRect cprect = CGRectMake((float)by,(float)bx,ey ,ex);
    CGSize rect = [image size];
    CGRect calsize = [self calcRect:rect cropRect:cprect];
    x1 = calsize.origin.y;
    y1 = calsize.origin.x;
    x2 =  calsize.size.height;
    y2 = calsize.size.width;
    // NSLog(@"(%d,%d)  (%d,%d)",x1,y1,x2,y2);
    int result2 =  TBANK_JudgeExist(x1,y1,x2,y2);
    
    int top = (result2 & TOP_LINE_EXIST)==1?1:0;
    int left = (result2 & LEFT_LINE_EXIST) ==2?1:0;
    int bottom = (result2 & BOTTOM_LINE_EXIST) ==4?1:0;
    int right = (result2 & RIGHT_LINE_EXIST) ==8?1:0;
    int ret = 0;
    //NSLog(@"(%d %d %d %d)",top,left,bottom,right);
    //至少三边存在
    [self.drawView showLineUP:left right:top bottom:right left:bottom];
    [self.drawView setNeedsDisplay];
    if (((top + left + bottom + right)>=3) || (top == 1 && bottom == 1) || (left == 1 && bottom == 1)) {
        
        ret = TBANK_OCR();
        if(ret == 100)
        {
            NSLog(@"引擎过期");
        }
       
        if (ret != 0 ) {
            //识别成功
//            if (self.successBlock) {
//                
//                self.numImage = TBANK_GetSmallImage();
//                self.cardInfo = TBANK_GetOcrNumString();
//                self.successBlock();
//            }
//            UIImage *numImage = TBANK_GetSmallImage();
            if (self.ViewScanDelegate && [self.ViewScanDelegate respondsToSelector:@selector(sendBankCardInfo:BANK_NAME:BANK_ORGCODE:BANK_CLASS:CARD_NAME:)]) { // 如果协议响应了sendIDcardValue:方法
                [self.ViewScanDelegate sendBankCardInfo:TBANK_GetBankInfoString(T_GET_BANK_NUM) BANK_NAME:TBANK_GetBankInfoString(T_GET_BANK_NAME) BANK_ORGCODE:TBANK_GetBankInfoString(T_GET_BANK_ORGCODE) BANK_CLASS:TBANK_GetBankInfoString(T_GET_BANK_CLASS) CARD_NAME:TBANK_GetBankInfoString(T_GET_CARD_NAME)]; // 通知执行协议方法
            }
            if (self.ViewScanDelegate && [self.ViewScanDelegate respondsToSelector:@selector(sendBankCardName:)]) { // 如果协议响应了sendIDcardValue:方法
                [self.ViewScanDelegate sendBankCardName:TBANK_GetBankInfoString(T_GET_BANK_NAME)]; // 通知执行协议方法
            }
            if (self.ViewScanDelegate && [self.ViewScanDelegate respondsToSelector:@selector(sendBankCardNum:)]) { // 如果协议响应了sendIDcardValue:方法
                [self.ViewScanDelegate sendBankCardNum:TBANK_GetBankInfoString(T_GET_BANK_NUM)]; // 通知执行协议方法
            }
            if (self.ViewScanDelegate && [self.ViewScanDelegate respondsToSelector:@selector(sendBankCardImage:)]) { // 如果协议响应了sendIDcardValue:方法
                [self.ViewScanDelegate sendBankCardImage:TBANK_GetSmallImage()]; // 通知执行协议方法
            }
//            if (self.ViewScanDelegate && [self.ViewScanDelegate respondsToSelector:@selector(sendCardImageHash:)]) { // 如果协议响应了sendIDcardValue:方法
//                [self.ViewScanDelegate sendCardImageHash:GetSha1NSString(image)]; // 通知执行协议方法
//            }
            
        }
        
        //NSLog(@"ok ------String = %s",BC_Result.cardNum);
        
    }
    TBANK_FreeImage();
    if (ret != 0) {
        isRun = TRUE;
//        if (self.ViewScanDelegate && [self.ViewScanDelegate respondsToSelector:@selector(sendBackAction)]) { // 如果协议响应了sendIDcardValue:方法
//            [self.ViewScanDelegate sendBackAction]; // 通知执行协议方法
//        }
        
        [self cancelAction];
    }
    else
        isRun = false;
    //    [image release];
#endif
}
@end
