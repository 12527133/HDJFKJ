//
//  SCCaptureSessionManager.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-16.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCCaptureSessionManager.h"
#import <ImageIO/ImageIO.h>
#import "SCCommon.h"

@interface SCCaptureSessionManager ()


@property (nonatomic, strong) UIView *preview;
//@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SCCaptureSessionManager


#pragma mark -
#pragma mark configure
- (id)init {
    self = [super init];
    if (self != nil) {
        _scaleNum = 1.f;
        _preScaleNum = 1.f;
    }
    return self;
}

- (void)dealloc {
    
    [_session stopRunning];
    self.previewLayer = nil;
    self.session = nil;
    self.stillImageOutput = nil;
    self.output = nil;
    self.isRun1 = FALSE;
//    self.stillImage = nil;
}
- (void)SetValuePoint:(CGPoint)begin End:(CGPoint)end
{
    self.beginPoint = CGPointMake(begin.x, begin.y);
    self.endPoint = CGPointMake(end.x, end.y);;
}
- (void)SetCardType:(TCARD_TYPE) iCardType Mode:(BOOL)mode
{
    self.iCardType = iCardType;
    self.ScanMode = TIDC_NORMAL_MODE;
}
- (void)configureWithParentLayer:(UIView*)parent previewRect:(CGRect)preivewRect {
//    CGRect frame = [[UIScreen mainScreen] bounds];
    self.preview = parent;
    
    //1、队列
    [self createQueue];
    
    //2、session
    [self addSession];
    
    //3、previewLayer
    [self addVideoPreviewLayerWithRect:preivewRect];
    [parent.layer addSublayer:_previewLayer];
    
    //4、input
    [self addVideoInputFrontCamera:NO];
    
    //5、output
    [self addStillImageOutput];
    
//    //6、preview imageview
//    [self addPreviewImageView];
    
//    //6、default flash mode
//    [self switchFlashMode:nil];
    
//    //7、default focus mode
//    [self setDefaultFocusMode];
}

/**
 *  创建一个队列，防止阻塞主线程
 */
- (void)createQueue {
	dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
}

/**
 *  session
 */
- (void)addSession {
    AVCaptureSession *tmpSession = [[AVCaptureSession alloc] init];
    self.session = tmpSession;
    //设置质量
  _session.sessionPreset = AVCaptureSessionPresetHigh;
}

/**
 *  相机的实时预览页面
 *
 *  @param previewRect 预览页面的frame
 */
- (void)addVideoPreviewLayerWithRect:(CGRect)previewRect {
    
    AVCaptureVideoPreviewLayer *preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = previewRect;
    self.previewLayer = preview;
}

/**
 *  添加输入设备
 *
 *  @param front 前或后摄像头
 */
- (void)addVideoInputFrontCamera:(BOOL)front {
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        SCDLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                SCDLog(@"Device position : back");
                backCamera = device;
                
            }  else {
                SCDLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    NSError *error = nil;
    
    if (front) {
        AVCaptureDeviceInput *frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!error) {
            if ([_session canAddInput:frontFacingCameraDeviceInput]) {
                [_session addInput:frontFacingCameraDeviceInput];
                self.inputDevice = frontFacingCameraDeviceInput;
                
            } else {
                SCDLog(@"Couldn't add front facing video input");
            }
        }
    } else {
        AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!error) {
            if ([_session canAddInput:backFacingCameraDeviceInput]) {
                [_session addInput:backFacingCameraDeviceInput];
                self.inputDevice = backFacingCameraDeviceInput;
            } else {
                SCDLog(@"Couldn't add back facing video input");
            }
        }
    }
}

/**
 *  添加输出设备
 */
- (void)addStillImageOutput {
    if ((self.iCardType == TIDBANK) || (self.iCardType == TIDCARD2 && self.ScanMode == TIDC_SCAN_MODE)){
        self.output = [[AVCaptureVideoDataOutput alloc]
                       init];
        self.output.alwaysDiscardsLateVideoFrames = YES;
        //captureOutput.minFrameDuration = CMTimeMake(1, 10);
        
        dispatch_queue_t queue;
        queue = dispatch_queue_create("cameraQueue", NULL);
        [self.output setSampleBufferDelegate:self queue:queue];
        
        //    dispatch_release(queue);
        NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
        NSNumber* value = [NSNumber
                           numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary* videoSettings = [NSDictionary
                                       dictionaryWithObject:value forKey:key];
        [self.output setVideoSettings:videoSettings];
        [_session addOutput:self.output];
    }
    else
    {
        AVCaptureStillImageOutput *tmpOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];//输出jpeg
        tmpOutput.outputSettings = outputSettings;
        
        //    AVCaptureConnection *videoConnection = [self findVideoConnection];
        
        [_session addOutput:tmpOutput];
        
        self.stillImageOutput = tmpOutput;
 
    }
    
    
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer    fromConnection:(AVCaptureConnection *)connection {
    
    if (self.isRun1 == false) {
        self.isRun1 = TRUE;
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
        UIImage *image= [UIImage imageWithCGImage:newImage scale:1 orientation:UIImageOrientationUp];
        CGImageRelease(newImage);
        [self performSelectorOnMainThread:@selector(detectInUIImage:)
                               withObject: (id) image waitUntilDone:NO];
        //[image release];
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        //    [pool drain];
    }
    
    // Add your code here that uses the image.
    
    
}
-(void)detectInUIImage:(UIImage *)image
{
#if TARGET_IPHONE_SIMULATOR == 0
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    {
//        CGFloat degree = -90;
//        if (orientation == UIDeviceOrientationPortraitUpsideDown) {
//            degree = 180;// M_PI;
//        } else if (orientation == UIDeviceOrientationLandscapeLeft) {
//            degree = -90;// -M_PI_2;
//        } else if (orientation == UIDeviceOrientationLandscapeRight) {
//            degree = 90;// M_PI_2;
//        }
//        SCDLog(@"xxxxxx:%f",degree);
//        image = [self rotatedByDegrees1:degree size:image.size image:image];
//    }
    int width1 = CGImageGetWidth(image.CGImage);
    int height1 = CGImageGetHeight(image.CGImage);
    //
    //    //if (orientation != UIDeviceOrientationPortrait)
    
//    TBANK_LoadImage(image);
    //    int hhhh = SC_APP_SIZE.height;
    //    CGFloat squareLength = SC_APP_SIZE.width;
    //    CGFloat headHeight = SC_APP_SIZE.height;//_previewLayer.bounds.size.height - squareLength;//_previewLayer的frame是(0, 44, 320, 320 + 44)
    //    CGSize size = CGSizeMake(headHeight, squareLength);
    //
    //    UIImage *scaledImage = [self resizedImageWithContentMode1:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationHigh size: image.size image:image];
    //    SCDLog(@"scaledImage:%@", [NSValue valueWithCGSize:scaledImage.size]);
//    CGPoint beginPoint = CGPointMake(_previewLayer.bounds.size.height / ScanValue,(_previewLayer.bounds.size.width-(_previewLayer.bounds.size.height -_previewLayer.bounds.size.height / ScanValue *2.0)/1.58)*0.5);
//    CGPoint endPoint = CGPointMake(_previewLayer.bounds.size.height-_previewLayer.bounds.size.height / ScanValue, _previewLayer.bounds.size.width - (_previewLayer.bounds.size.width-(_previewLayer.bounds.size.height -_previewLayer.bounds.size.height / ScanValue*2.0)/1.58)*0.5);
    
    int bx = self.beginPoint.x;
    int by = self.beginPoint.y;
    int ex = self.endPoint.x ;
    int ey = self.endPoint.y ;
    CGRect cprect = CGRectMake((float)by,(float)bx,ey ,ex);
    CGSize rect = CGSizeMake(height1, width1);//[image size];
    CGRect calsize = [self calcRect:rect cropRect:cprect];
    int y1 = calsize.origin.y;
    int x1 = calsize.origin.x;
    int y2 =  calsize.size.height;
    int x2 = calsize.size.width;
    CGRect cprect1 = CGRectMake((float)y1,(float)x1,y2 + y1 ,x2 + x1);
    CGRect cprect2 = CGRectMake((float)x1,(float)y1,x2 + x1 ,y2 + y1);
//    CGRect cropFrame = [self calcRect:[image size] cropRect:cprect];
    //        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    //        [UIImageJPEGRepresentation(scaledImage, 1.0) writeToFile:jpgPath atomically:YES];
//    UIImage *croppedImage = [self croppedImage1:cprect1 image:image];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCapturePhoto:rect:)])
    {
        [self.delegate didCapturePhoto:image rect:cprect2]; // 通知执行协议方法
    }
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    
//    //if (orientation != UIDeviceOrientationPortrait)
//    {
//        
//        CGFloat degree = -90;
//        if (orientation == UIDeviceOrientationPortraitUpsideDown) {
//            degree = 180;// M_PI;
//        } else if (orientation == UIDeviceOrientationLandscapeLeft) {
//            degree = -90;// -M_PI_2;
//        } else if (orientation == UIDeviceOrientationLandscapeRight) {
//            degree = 90;// M_PI_2;
//        }
//        SCDLog(@"xxxxxx:%f",degree);
//        croppedImage = [self rotatedByDegrees1:degree size:image.size image:croppedImage];
//    }
    
    
//    int y1 = cropFrame.origin.y;
//    int x1 = cropFrame.origin.x;
//    int y2 =  cropFrame.size.height;
//    int x2 = cropFrame.size.width;
//    NSLog(@"(%d,%d)  (%d,%d)",x1,y1,x2,y2);
//    int result2 =  TBANK_JudgeExist(x1,y1,x2,y2);
//    
//    int top = (result2 & TOP_LINE_EXIST1)==1?1:0;
//    int left = (result2 & LEFT_LINE_EXIST1) ==2?1:0;
//    int bottom = (result2 & BOTTOM_LINE_EXIST1) ==4?1:0;
//    int right = (result2 & RIGHT_LINE_EXIST1) ==8?1:0;
    int ret = 0;
//    {
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDate *now;
//        NSDateComponents *comps = [[NSDateComponents alloc] init];
//        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
//        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//        now=[NSDate date];
//        comps = [calendar components:unitFlags fromDate:now];
//        NSInteger  week = [comps weekday];
//        NSInteger month = [comps month];
//        NSInteger day = [comps day];
//        NSInteger hour = [comps hour];
//        NSInteger min = [comps minute];
//        NSInteger sec = [comps second];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString* pImageName = [NSString stringWithFormat:@"%@/%d%d%d%d%d%@", [paths objectAtIndex:0],month , day , hour , min , sec ,@".jpg"];
//        NSString* pImageName1 = [NSString stringWithFormat:@"%@/A_%d%d%d%d%d%@", [paths objectAtIndex:0],month , day , hour , min , sec ,@".jpg"];
//        //UIImage *croppedImage = [self croppedImage1:calsize image:image];
//        
//        NSData *imageData =  UIImageJPEGRepresentation(croppedImage, 1.0);
//        [imageData writeToFile:pImageName atomically:YES];
//        NSData *imageData1 =  UIImageJPEGRepresentation(image, 1.0);
//        [imageData1 writeToFile:pImageName1 atomically:YES];
//    }
    //NSLog(@"(%d %d %d %d)",top,left,bottom,right);
    //至少三边存在
    //[self.drawView showLineUP:left right:top bottom:right left:bottom];
    //[self.drawView setNeedsDisplay];
//    if (((top + left + bottom + right)>=3) || (top == 1 && bottom == 1) || (left == 1 && bottom == 1)) {
//        
//        ret = TBANK_OCR();
//        if(ret == 100)
//        {
//            NSLog(@"引擎过期");
//        }
//        else if (ret == 0) {
//            NSLog(@"没识别对");
//        }
//        if (ret != 0 ) {
//            NSLog(@"识别成功\n");
//            
//        }
//        
//        //NSLog(@"ok ------String = %s",BC_Result.cardNum);
//        
//    }
//    TBANK_FreeImage();
    //isRun1 = false;
    //    [image release];
#endif
}

- (CGRect) calcRect:(CGSize)imageSize cropRect:(CGRect) cpRect{
    NSString* gravity = self.previewLayer.videoGravity;
    CGRect cropRect = cpRect;
    CGSize screenSize = self.previewLayer.bounds.size;
    
    CGFloat screenRatio = screenSize.height / screenSize.width ;
    CGFloat imageRatio = imageSize.height /imageSize.width;
    
    CGRect presentImageRect = self.previewLayer.bounds;
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
    rect.size.width = imageSize.width - rect.origin.x * 2;
    rect.size.height  = imageSize.height - rect.origin.y * 2;
    
    return rect;
}
/**
 *  拍完照片后预览图片
 */
//- (void)addPreviewImageView {
//    CGFloat headHeight = _previewLayer.bounds.size.height - SC_APP_SIZE.width;
//    CGRect imageFrame = _previewLayer.bounds;
//    imageFrame.origin.y = headHeight;
//    
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:imageFrame];
//    imgView.contentMode = UIViewContentModeScaleAspectFill;
//    [_preview addSubview:imgView];
//    
//    self.imageView = imgView;
//}

#pragma mark - actions
/**
 *  拍照
 */
static inline CGFloat DegreesToRadians1(CGFloat degrees)
{
    return M_PI * (degrees / 180.0);
}
- (UIImage *)rotatedByDegrees1:(CGFloat)degrees size:(CGSize) size image:(UIImage *)image
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,size.width, size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians1(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians1(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
    
}
- (UIImage *)resizedImageWithContentMode1:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality
                                     size:(CGSize) size
                                    image: (UIImage *)image
{
    CGFloat horizontalRatio = bounds.width / size.width;
    CGFloat verticalRatio = bounds.height / size.height;
    CGFloat ratio = 0.0;
    
    switch(contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
    }
    
    CGSize newSize = CGSizeMake(size.width * ratio, size.height * ratio);
    
    return [self resizedImage1:newSize interpolationQuality:quality image:image];
}
- (CGAffineTransform)transformForOrientation1:(CGSize)newSize image:(UIImage *)image{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch(image.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch(image.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}
- (UIImage *)resizedImage1:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality
                     image:(UIImage *)image
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = image.CGImage;
    
    // Fix for a colorspace / transparency issue that affects some types of
    // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8,
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                kCGImageAlphaNoneSkipLast);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}
- (UIImage *)resizedImage1:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality image:(UIImage *)image{
    BOOL drawTransposed;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // In iOS 5 the image is already correctly rotated. See Eran Sandler's
    // addition here: http://eran.sandler.co.il/2011/11/07/uiimage-in-ios-5-orientation-and-resize/
    
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 5.0) {
        drawTransposed = YES;
    }
    else {
        switch(image.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                drawTransposed = YES;
                break;
            default:
                drawTransposed = NO;
        }
        
        transform = [self transformForOrientation1:newSize image:image];
    }
    transform = [self transformForOrientation1:newSize image:image];
    return [self resizedImage1:newSize transform:transform drawTransposed:drawTransposed interpolationQuality:quality image:image];
}
- (UIImage *)croppedImage1:(CGRect)bounds image:(UIImage *)image{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}
- (void)takePicture:(DidCapturePhotoBlock)block {
    AVCaptureConnection *videoConnection = [self findVideoConnection];
    
//	UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
//	AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
//    [videoConnection setVideoOrientation:avcaptureOrientation];
    [videoConnection setVideoScaleAndCropFactor:_scaleNum];
    
	SCDLog(@"about to request a capture from: %@", _stillImageOutput);
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments) {
            SCDLog(@"attachements: %@", exifAttachments);
        } else {
            SCDLog(@"no attachments");
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        SCDLog(@"originImage:%@", [NSValue valueWithCGSize:image.size]);
//        [SCCommon saveImageToPhotoAlbum:image];
        int hhhh = SC_APP_SIZE.height;
        CGFloat squareLength = SC_APP_SIZE.width;
        CGFloat headHeight = _previewLayer.bounds.size.height - squareLength;//_previewLayer的frame是(0, 44, 320, 320 + 44)
        CGSize size = CGSizeMake(squareLength * 2, squareLength * 2);
        
        UIImage *scaledImage = [self resizedImageWithContentMode1:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh size: image.size image:image];
        SCDLog(@"scaledImage:%@", [NSValue valueWithCGSize:scaledImage.size]);
//        CGPoint beginPoint = CGPointMake(_previewLayer.bounds.size.height / ScanValue,(_previewLayer.bounds.size.width-(_previewLayer.bounds.size.height -_previewLayer.bounds.size.height / ScanValue *2.0)/1.58)*0.5);
//        CGPoint endPoint = CGPointMake(_previewLayer.bounds.size.height-_previewLayer.bounds.size.height / ScanValue, _previewLayer.bounds.size.width - (_previewLayer.bounds.size.width-(_previewLayer.bounds.size.height -_previewLayer.bounds.size.height / ScanValue*2.0)/1.58)*0.5);
        int bx = self.beginPoint.x;
        int by = self.beginPoint.y;
        int ex = self.endPoint.x ;
        int ey = self.endPoint.y ;
        CGRect cprect = CGRectMake((float)by,(float)bx,ey ,ex);
        CGRect cropFrame = [self calcRect:[scaledImage size] cropRect:cprect];
//        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
//        [UIImageJPEGRepresentation(scaledImage, 1.0) writeToFile:jpgPath atomically:YES];
        UIImage *croppedImage = [self croppedImage1:cropFrame image:scaledImage];
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        
        //if (orientation != UIDeviceOrientationPortrait)
        {
            
            CGFloat degree = -90;
            if (orientation == UIDeviceOrientationPortraitUpsideDown) {
                degree = 180;// M_PI;
            } else if (orientation == UIDeviceOrientationLandscapeLeft) {
                degree = -90;// -M_PI_2;
            } else if (orientation == UIDeviceOrientationLandscapeRight) {
                degree = 90;// M_PI_2;
            }
            SCDLog(@"xxxxxx:%f",degree);
            croppedImage = [self rotatedByDegrees1:degree size:image.size image:croppedImage];
        }
//        NSString  *jpgPath0 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test0.jpg"];
//        [UIImageJPEGRepresentation(scaledImage, 1.0) writeToFile:jpgPath0 atomically:YES];
//        CGRect cropFrame = CGRectMake(750, 340, 1300, 840);
//        SCDLog(@"cropFrame:%@", [NSValue valueWithCGRect:cropFrame]);
//        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
//        [UIImageJPEGRepresentation(scaledImage, 1.0) writeToFile:jpgPath atomically:YES];
//        UIImage *croppedImage = [scaledImage croppedImage:cropFrame];
//        SCDLog(@"croppedImage:%@", [NSValue valueWithCGSize:croppedImage.size]);
        
        
        
        
//        self.imageView.image = croppedImage;
        
        //block、delegate、notification 3选1，传值
        if (block) {
            block(croppedImage);
        }
//        else if ([_delegate respondsToSelector:@selector(didCapturePhoto:)]) {
//            [_delegate didCapturePhoto:croppedImage];
//        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCapturedPhotoSuccessfully object:croppedImage];
        }
    }];
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
	AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
	if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
		result = AVCaptureVideoOrientationLandscapeRight;
	else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
		result = AVCaptureVideoOrientationLandscapeLeft;
	return result;
}

/**
 *  切换前后摄像头
 *
 *  @param isFrontCamera YES:前摄像头  NO:后摄像头
 */
- (void)switchCamera:(BOOL)isFrontCamera {
    if (!_inputDevice) {
        return;
    }
    [_session beginConfiguration];
    
    [_session removeInput:_inputDevice];
    
    [self addVideoInputFrontCamera:isFrontCamera];
    
    [_session commitConfiguration];
}

/**
 *  拉近拉远镜头
 *
 *  @param scale 拉伸倍数
 */
- (void)pinchCameraViewWithScalNum:(CGFloat)scale {
    _scaleNum = scale;
    if (_scaleNum < MIN_PINCH_SCALE_NUM) {
        _scaleNum = MIN_PINCH_SCALE_NUM;
    } else if (_scaleNum > MAX_PINCH_SCALE_NUM) {
        _scaleNum = MAX_PINCH_SCALE_NUM;
    }
    [self doPinch];
    _preScaleNum = scale;
}

- (void)pinchCameraView:(UIPinchGestureRecognizer *)gesture {
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
	NSUInteger numTouches = [gesture numberOfTouches], i;
	for ( i = 0; i < numTouches; ++i ) {
		CGPoint location = [gesture locationOfTouch:i inView:_preview];
		CGPoint convertedLocation = [_previewLayer convertPoint:location fromLayer:_previewLayer.superlayer];
		if ( ! [_previewLayer containsPoint:convertedLocation] ) {
			allTouchesAreOnThePreviewLayer = NO;
			break;
		}
	}
	
	if ( allTouchesAreOnThePreviewLayer ) {
		_scaleNum = _preScaleNum * gesture.scale;
        
        if (_scaleNum < MIN_PINCH_SCALE_NUM) {
            _scaleNum = MIN_PINCH_SCALE_NUM;
        } else if (_scaleNum > MAX_PINCH_SCALE_NUM) {
            _scaleNum = MAX_PINCH_SCALE_NUM;
        }
        
        [self doPinch];
	}
    
    if ([gesture state] == UIGestureRecognizerStateEnded ||
        [gesture state] == UIGestureRecognizerStateCancelled ||
        [gesture state] == UIGestureRecognizerStateFailed) {
        _preScaleNum = _scaleNum;
        SCDLog(@"final scale: %f", _scaleNum);
    }
}

- (void)doPinch {
//    AVCaptureStillImageOutput* output = (AVCaptureStillImageOutput*)[_session.outputs objectAtIndex:0];
//    AVCaptureConnection *videoConnection = [output connectionWithMediaType:AVMediaTypeVideo];
    
    AVCaptureConnection *videoConnection = [self findVideoConnection];
    
    CGFloat maxScale = videoConnection.videoMaxScaleAndCropFactor;//videoScaleAndCropFactor这个属性取值范围是1.0-videoMaxScaleAndCropFactor。iOS5+才可以用
    if (_scaleNum > maxScale) {
        _scaleNum = maxScale;
    }
    
//    videoConnection.videoScaleAndCropFactor = _scaleNum;
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [_previewLayer setAffineTransform:CGAffineTransformMakeScale(_scaleNum, _scaleNum)];
    [CATransaction commit];
}

/**
 *  切换闪光灯模式
 *  （切换顺序：最开始是auto，然后是off，最后是on，一直循环）
 *  @param sender: 闪光灯按钮
 */
- (void)switchFlashMode:(UIButton*)sender {
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (!captureDeviceClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有拍照功能" delegate:nil cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *imgStr = @"";
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ([device hasFlash]) {
//        if (!sender) {//设置默认的闪光灯模式
//            device.flashMode = AVCaptureFlashModeAuto;
//        } else {
            if (device.flashMode == AVCaptureFlashModeOff) {
                device.flashMode = AVCaptureFlashModeOn;
                imgStr = @"flashing_on.png";
                
            } else if (device.flashMode == AVCaptureFlashModeOn) {
                device.flashMode = AVCaptureFlashModeAuto;
                imgStr = @"flashing_auto.png";
                
            } else if (device.flashMode == AVCaptureFlashModeAuto) {
                device.flashMode = AVCaptureFlashModeOff;
                imgStr = @"flashing_off.png";
                
            }
//        }
        
        if (sender) {
            [sender setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有闪光灯功能" delegate:nil cancelButtonTitle:@"噢T_T" otherButtonTitles: nil];
        [alert show];
    }
    [device unlockForConfiguration];
}

/**
 *  点击后对焦
 *
 *  @param devicePoint 点击的point
 */
- (void)focusInPoint:(CGPoint)devicePoint {
//    if (CGRectContainsPoint(_previewLayer.bounds, devicePoint) == NO) {
//        return;
//    }
    
    devicePoint = [self convertToPointOfInterestFromViewCoordinates:devicePoint];
	[self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
    
	dispatch_async(_sessionQueue, ^{
		AVCaptureDevice *device = [_inputDevice device];
		NSError *error = nil;
		if ([device lockForConfiguration:&error])
		{
			if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
			{
				[device setFocusMode:focusMode];
				[device setFocusPointOfInterest:point];
			}
			if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
			{
				[device setExposureMode:exposureMode];
				[device setExposurePointOfInterest:point];
			}
			[device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
			[device unlockForConfiguration];
		}
		else
		{
			SCDLog(@"%@", error);
		}
	});
}

- (void)subjectAreaDidChange:(NSNotification *)notification {
    
	CGPoint devicePoint = CGPointMake(.5, .5);
	[self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

/**
 *  外部的point转换为camera需要的point(外部point/相机页面的frame)
 *
 *  @param viewCoordinates 外部的point
 *
 *  @return 相对位置的point
 */
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = _previewLayer.bounds.size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = self.previewLayer;
    
    if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResize]) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for(AVCaptureInputPort *port in [[self.session.inputs lastObject]ports]) {
            if([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspect]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if(point.x >= blackBar && point.x <= blackBar + x2) {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if(point.y >= blackBar && point.y <= blackBar + y2) {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                    
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

/**
 *  显示/隐藏网格
 *
 *  @param toShow 显示或隐藏
 */
- (void)switchGrid:(BOOL)toShow {
    
    if (!toShow) {
        NSArray *layersArr = [NSArray arrayWithArray:_preview.layer.sublayers];
        for (CALayer *layer in layersArr) {
            if (layer.frame.size.width == 1 || layer.frame.size.height == 1) {
                [layer removeFromSuperlayer];
            }
        }
        return;
    }
    
    CGFloat headHeight = _previewLayer.bounds.size.height - SC_APP_SIZE.width;
    CGFloat squareLength = SC_APP_SIZE.width;
    CGFloat eachAreaLength = squareLength / 3;
    
    for (int i = 0; i < 4; i++) {
        CGRect frame = CGRectZero;
        if (i == 0 || i == 1) {//画横线
            frame = CGRectMake(0, headHeight + (i + 1) * eachAreaLength, squareLength, 1);
        } else {
            frame = CGRectMake((i + 1 - 2) * eachAreaLength, headHeight, 1, squareLength);
        }
        [SCCommon drawALineWithFrame:frame andColor:[UIColor whiteColor] inLayer:_preview.layer];
    }
}

////画一条线
//+ (void)drawALineWithFrame:(CGRect)frame andColor:(UIColor*)color inLayer:(CALayer*)parentLayer {
//    CALayer *layer = [CALayer layer];
//    layer.frame = frame;
//    layer.backgroundColor = color.CGColor;
//    [parentLayer addSublayer:layer];
//}

//
//AVAsset* asset = // your input
//
//AVMutableComposition *videoComposition = [AVMutableComposition composition];
//
//AVMutableCompositionTrack *compositionVideoTrack = [videoComposition  addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//
//AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//
//AVMutableVideoComposition* videoComposition = [[AVMutableVideoComposition videoComposition]retain];
//videoComposition.renderSize = CGSizeMake(320, 320);
//videoComposition.frameDuration = CMTimeMake(1, 30);
//
//AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
//
//AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
//CGAffineTransform finalTransform = // setup a transform that grows the video, effectively causing a crop
//[transformer setTransform:finalTransform atTime:kCMTimeZero];
//instruction.layerInstructions = [NSArray arrayWithObject:transformer];
//videoComposition.instructions = [NSArray arrayWithObject: instruction];
//
//exporter = [[AVAssetExportSession alloc] initWithAsset:saveComposition presetName:AVAssetExportPresetHighestQuality] ;
//exporter.videoComposition = videoComposition;
//exporter.outputURL=url3;
//exporter.outputFileType=AVFileTypeQuickTimeMovie;
//
//[exporter exportAsynchronouslyWithCompletionHandler:^(void){}];


//- (void)saveImageToPhotoAlbum:(UIImage*)image {
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//}
//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if (error != NULL) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了!" message:@"存不了T_T" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    } else {
//        SCDLog(@"保存成功111");
//    }
//}


#pragma mark ---------------private--------------
- (AVCaptureConnection*)findVideoConnection {
    AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in _stillImageOutput.connections) {
		for (AVCaptureInputPort *port in connection.inputPorts) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
            break;
        }
	}
    return videoConnection;
}



@end
