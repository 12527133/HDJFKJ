//
//  QRViewController.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRView.h"
#import "QRUtil.h"

@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate,QRViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;


@property (nonatomic, strong) QRView *qrView;

@property (nonatomic, strong) UILabel * tishiLabel;

@property (nonatomic, strong) UIView * qrContentView;

@property (nonatomic, strong) UIImageView * qrImageView;

@property (nonatomic, strong) UIImage * qrImage;

@property (nonatomic, strong) UIButton * backHomePage;

@property (nonatomic, strong) UIActivityIndicatorView * activity;

@property (nonatomic, strong) UILabel * activLabel;

@property (nonatomic, strong) NSTimer * timer;
@end

@implementation QRViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码/条形码";
    [self createGobackHomePageButton];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];//指定进度轮的大小
    
    self.activity.center = self.view.center;
    
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    
    [self.view addSubview:self.activity];
    
    [self.activity startAnimating];
    
    self.activLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.activity.frame.origin.y+40, LDScreenWidth, 13)];
    
    self.activLabel.textColor = [UIColor whiteColor];
    self.activLabel.font = [UIFont systemFontOfSize:13];
    self.activLabel.textAlignment = NSTextAlignmentCenter;
    self.activLabel.text = @"正在加载...";
    [self.view addSubview:self.activLabel];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self.backHomePage.titleLabel.text isEqualToString:@"相册"]) {
        
        [self defaultConfig];       //初始化配置,主要是二维码的配置
        [self configUI];
        [self updateLayout];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWXVC) name:@"dismissWX" object:nil];
        
        //************************************************
        if (![_session isRunning]) {
            
            [self defaultConfig];
        }
        self.view.backgroundColor = [UIColor clearColor];
        
        if([self.activity isAnimating]){
            
            [self.activity stopAnimating];
            
            
        }
        
        [self.activity removeFromSuperview];
        [self.activLabel removeFromSuperview];
    }
    
    
    
}

- (void)createGobackHomePageButton{
    self.backHomePage = [[UIButton alloc]init];
    self.backHomePage.size = CGSizeMake(50, 30);
    
    [self.backHomePage setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
    [self.backHomePage setTitle:@"相册" forState:UIControlStateNormal];
    [self.backHomePage addTarget:self action:@selector(clickOpenPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.backHomePage];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:leftItem, nil];
    
}
- (void)clickOpenPhoto:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"相册"]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
    
    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        [UIView animateWithDuration:0.35f animations:^{
            self.qrContentView.frame = CGRectMake(0, LDScreenHeight, LDScreenHeight, LDScreenHeight);
        } completion:^(BOOL finished) {
            self.qrContentView.hidden = YES;
            
            [sender setTitle:@"相册" forState:UIControlStateNormal];
            
            //************************************************
            if (![_session isRunning]) {
                
                [self defaultConfig];
            }
            self.view.backgroundColor = [UIColor clearColor];
        }];
        
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    self.qrImage = info[@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.qrContentView.frame = CGRectMake(0, 0, LDScreenWidth, LDScreenHeight);
    self.qrContentView.hidden = NO;
    [self addImageToQRContentView];
    
    [self.backHomePage setTitle:@"取消" forState:UIControlStateNormal];
    
    
}
- (void)addImageToQRContentView{
    self.qrImageView = [[UIImageView alloc]init];
    
    if (self.qrImage.size.width/self.qrImage.size.height > LDScreenWidth/self.view.frame.size.height) {
        
        
        self.qrImageView.frame = CGRectMake(0, 0, LDScreenWidth, self.qrImage.size.height * LDScreenWidth/self.qrImage.size.width);
    }
    else{
        
        self.qrImageView.frame = CGRectMake(0, 0, self.qrImage.size.width * self.qrContentView.frame.size.height/self.qrImage.size.height , self.qrContentView.frame.size.height);
        
    }
    
    self.qrImageView.image = self.qrImage;
    
    self.qrImageView.center = self.qrContentView.center;
    
    [self.qrContentView addSubview:self.qrImageView];
    
    self.qrImageView.userInteractionEnabled = YES;
    
    
    [HDLoading showWithImageWithString:@"正在识别二维码"];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.75f
                                              target:self
                                            selector:@selector(readPhotoQR)
                                            userInfo:nil
                                             repeats:YES];
    
    //    //添加图片的收拾
    //    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidLongPressed:)];
    //    longPressGes.minimumPressDuration = 1.0f;
    //    [self.qrImageView addGestureRecognizer:longPressGes];
}

- (UIView *)qrContentView{
    
    if (!_qrContentView) {
        self.qrContentView = [[UIView alloc]initWithFrame:self.view.frame];
        self.qrContentView.backgroundColor =WHColorFromRGB(0xf0f0f0);
    }
    return _qrContentView;
}

- (void)imageViewDidLongPressed:(UILongPressGestureRecognizer *)ges {
    
    
    UIView * coverView = nil;
    //因为长按手势开始和结束会调用两次这个方法，所以按自己的逻辑处理
    if(ges.state == UIGestureRecognizerStateBegan) {
        coverView = [[UIView alloc]initWithFrame:self.view.frame];
        [self readPhotoQR];
        
        coverView.backgroundColor = [UIColor blackColor];
        [UIView animateWithDuration:0.35f animations:^{
            coverView.alpha = 0.5;
        }];
        
    } else if(ges.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.35f animations:^{
            coverView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [coverView removeFromSuperview];
        }];
        
    }else if(ges.state == UIGestureRecognizerStateChanged) {
        
        
        
    }
    
    
}

- (void)readPhotoQR {
    
    [_timer invalidate];
    UIImage *srcImage = self.qrImageView.image;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    CIQRCodeFeature *feature = [features firstObject];
    
    NSString *result = feature.messageString;
    
    if ([result isEqualToString:@""] || result.length == 0) {
        
        [HDLoading showFailViewWithString:@"识别失败"];
        
        
        [UIView animateWithDuration:0.35f animations:^{
            self.qrContentView.frame = CGRectMake(0, LDScreenHeight, LDScreenHeight, LDScreenHeight);
        } completion:^(BOOL finished) {
            self.qrContentView.hidden = YES;
            
            [self.backHomePage setTitle:@"相册" forState:UIControlStateNormal];
            
            //************************************************
            if (![_session isRunning]) {
                
                [self defaultConfig];
            }
            self.view.backgroundColor = [UIColor clearColor];
        }];
    } else {
        
        NSLog(@"QRCode is %@",result);
        [self pop:nil];
        self.qrUrlBlock(result);
        
    }
}



- (void)dismissWXVC{
    [self pop:nil];
}

- (void)defaultConfig {
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    AVCaptureConnection *outputConnection = [_output connectionWithMediaType:AVMediaTypeVideo];
    outputConnection.videoOrientation = [QRUtil videoOrientationFromCurrentDeviceOrientation];
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =[QRUtil screenBounds];
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    _preview.connection.videoOrientation = [QRUtil videoOrientationFromCurrentDeviceOrientation];
    
    [_session startRunning];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [_preview removeFromSuperlayer];
    [_session stopRunning];
}

- (void)configUI {
    
    
    
    [self.view addSubview:self.qrView];
    
    [self.view addSubview:self.tishiLabel];
    
    [self.view addSubview:self.qrContentView];
    self.qrContentView.hidden = YES;
}

- (void)updateLayout {
    
    
    
    _qrView.center = CGPointMake([QRUtil screenBounds].size.width / 2, [QRUtil screenBounds].size.height / 2);
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - self.qrView.transparentArea.width) / 2,
                                 (screenHeight - self.qrView.transparentArea.height) / 2,
                                 self.qrView.transparentArea.width,
                                 self.qrView.transparentArea.height);
    
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
}

- (void)pop:(UIButton *)button {
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}



#pragma mark QRViewDelegate
-(void)scanTypeConfig:(QRItem *)item {
    
    if (item.type == QRItemTypeQRCode) {
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
    } else if (item.type == QRItemTypeOther) {
        
        _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode128Code,
                                        AVMetadataObjectTypeQRCode];
    }
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    
    NSLog(@" %@",stringValue);
    [self pop:nil];
    if (self.qrUrlBlock) {
        self.qrUrlBlock(stringValue);
    }
    
    
    [self creatXMLFileWithAuthcode:stringValue];
}


#pragma mark - Getter and Setter
- (UILabel *)tishiLabel{
    if (!_tishiLabel) {
        
        float originY = 150 * self.view.frame.size.width/375;
        
        _tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, originY , self.view.frame.size.width, 30)];
        
        _tishiLabel.text = @"将条形码/二维码放入框中";
        _tishiLabel.textAlignment = NSTextAlignmentCenter;
        _tishiLabel.textColor = [UIColor whiteColor];
        _tishiLabel.font = [UIFont systemFontOfSize:20];
        
    }
    return _tishiLabel;
}




-(QRView *)qrView {
    
    if (!_qrView) {
        
        CGRect screenRect = [QRUtil screenBounds];
        _qrView = [[QRView alloc] initWithFrame:screenRect];
        
        
        float bainkuang = 280 * self.view.frame.size.width/375;
        
        _qrView.transparentArea = CGSizeMake(bainkuang, bainkuang);
        
        _qrView.backgroundColor = [UIColor clearColor];
        _qrView.delegate = self;
        
        
        NSLog(@"%f",_qrView.frame.origin.y);
        
        
    }
    return _qrView;
}

- (void)creatXMLFileWithAuthcode:(NSString *)authcode{
    
}

@end
