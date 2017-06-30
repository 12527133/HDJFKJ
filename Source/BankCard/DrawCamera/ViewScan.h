//
//  ViewController.h
//  TestCamera
//
//  Created by zzzili on 13-9-24.
//  Copyright (c) 2013年 zzzili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraBankDrawView.h"
@protocol ViewScanDelegate <NSObject>

//- (void)didTakePicture:(SCNavigationController*)navigationController image:(UIImage*)image;

- (void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name;
- (void)sendBankCardName:(NSString *)name;
- (void)sendBankCardNum:(NSString *)num;
- (void)sendBankCardImage:(UIImage *)BankCardImage;
- (void)sendBackAction;
@end

@interface ViewScan : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_captureInput;
    AVCaptureStillImageOutput *_captureOutput;
    AVCaptureVideoPreviewLayer *_preview;
    AVCaptureDevice *_device;
    
}

@property (retain, nonatomic) UIView *cameraView;
@property (nonatomic, retain) CALayer *customLayer;
@property(nonatomic,strong)CameraDrawView *drawView;
@property(nonatomic,copy)dispatch_block_t successBlock;
@property(nonatomic,strong)UIImage * numImage;
@property(nonatomic,strong)NSString * cardInfo;
@property (nonatomic, assign) id <ViewScanDelegate> ViewScanDelegate;
- (void)cancelAction;
@end

