//
//  ViewController.m
//  ZhongAn
//
//  Created by Xiaoyang Lin on 16/1/18.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import "ExampleStartViewController.h"
#import "LivenessDetectionViewController.h"
#import "ExampleResultViewController.h"
#import "CaptureIDCardPhotoViewController.h"
#import "CaptureDatabaseImageViewController.h"
#import "RegisterResultViewController.h"
#import "OnDatabaseImageCapturedEventListener.h"
#import "TZMD5.h"
#import "AFNetworkTool.h"

@interface ExampleStartViewController () <OnDatabaseImageCapturedEventListener>

@end

//NSString *invitationCode;
//NSString *password;

@implementation ExampleStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    invitationCode = @"bjhdjfkj";
//    password = @"2112B7626D";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) unwindToHomeViewController:(UIStoryboardSegue *)segue {

}

/**
 *  开始活体检测
 *
 *  @param sender 
 */
- (IBAction)startLivenessDetection:(UIButton *)sender {
    NSLog(@"开始活体检测");
    
    //获取storyboard和viewcontroller对象

    UIStoryboard *board = [UIStoryboard storyboardWithName: @"LivenessDetection" bundle: nil];
    
    LivenessDetectionViewController* livenessViewController = (LivenessDetectionViewController*) [board instantiateViewControllerWithIdentifier: @"LivenessDetectionStoryboard"];
    
    __weak typeof(self) weakSelf = self;
    
//    [livenessViewController passValues:invitationCode withSecondValue:password];
    //    invitationCode = @"bjhdjfkj";
    //    password = @"2112B7626D";
     // 弹出活体检测算法界面
    [self presentViewController:livenessViewController animated:YES completion:^{
        
         // 以下样例代码展示了如何初始化活体检测
        
        NSError *error;
        BOOL isSuccess;
        isSuccess = [livenessViewController setConfigLivenessDetection: weakSelf
                                                             withError: &error];
        NSLog(@"活体检测算法初始化结果: %@", (isSuccess ? @"成功" : @"失败"));
    }];
}


/////////////////// 结果回调函数 /////////////////////

/**
 *  活体检测成功的回调
 *
 *  @param detectedFrame 返回检测到的图像
 */
- (void) onLivenessSuccess: (DetectedFrame*)detectedFrame {
    NSLog(@"活体检测成功");
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        // 获取storyboard和viewcontroller对象
      
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        ExampleResultViewController* resultViewController = (ExampleResultViewController *) [board instantiateViewControllerWithIdentifier: @"resultStoryboard"];
        
        //显示等待dialog
        __block UIAlertView * alert;
        dispatch_async(dispatch_get_main_queue(), ^() {
            alert = [[UIAlertView alloc] initWithTitle:@"请稍等" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            [alert show];
        });
        
        
        // 展示结果页面
        [self presentViewController:resultViewController animated:YES completion:^{
            
            dispatch_async(dispatch_get_main_queue(), ^() {
                
                
                [resultViewController setLivenessResult:@"通过" withVerificationResult:@"没有比对" withVerificationImage: detectedFrame.verificationDataFull];
                
                
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
            });
        }];
    }];
    
}
- (NSString *)getCurrentTimeWithFormat:(NSString *)format{
    //把当前时间转化成字符串
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = format;
    NSString* nowDateString = [fmt stringFromDate:now];
    return nowDateString;
}

- (void)sendYanzhengRequest:(DetectedFrame*)detectedFrame{
   

    NSString * urlString = @"http://124.192.161.110:8080/face/decrypt/verify/check";
    NSString * accesskey = [NSString stringWithFormat:@"%@%@%@",@"bjhdjfkj",@"2112B7626D",[self getCurrentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]];
    
    NSDictionary * parmater = [NSMutableDictionary dictionary];
    [parmater setValue:@"bjhdjfkj" forKey:@"accessId"];
    [parmater setValue:[TZMD5 md5:accesskey] forKey:@"accessKey"];
    [parmater setValue:[self getCurrentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"] forKey:@"timeStamp"];
    
    [parmater setValue:@"22018219900309667X" forKey:@"userId"];
    [parmater setValue:[@"曹来东" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userName"];
    
    
    [parmater setValue:@"99.9" forKey:@"trueNegativeRate"];
    
    NSString* base64 = [detectedFrame.verificationDataFull base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    

    [parmater setValue:base64 forKey:@"dataPackage"];
    
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parmater options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString * see = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [AFNetworkTool postJSONWithUrl:urlString parameters:see success:^(NSDictionary * responseObject) {
        
        //responseObject = [AFJSONResponseSerializer serializer];
        
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",[responseObject valueForKey:@"result"]);
        NSLog(@"12345678");
        
        
        
     
    } fail:^{
        
        NSLog(@"1wwwwww8");
        
        [HDLoading showFailViewWithString:@"验证失败"];
    }];
    
}



/**
 *  活体检测失败的回调
 *
 *  @param sessionState  活体检测的返回状态
 *  @param detectedFrame 返回检测到的图像
 */
- (void) onLivenessFail: (int)sessionState withDetectedFrame: (DetectedFrame*)detectedFrame {
    NSLog(@"活体检测失败");
    
    [self dismissViewControllerAnimated:YES completion:^{
        // 获取storyboard和viewcontroller对象
         
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        
        ExampleResultViewController* resultViewController = (ExampleResultViewController *) [board instantiateViewControllerWithIdentifier: @"resultStoryboard"];
        
        //显示等待dialog
        __block UIAlertView * alert;
        dispatch_async(dispatch_get_main_queue(), ^() {
            alert = [[UIAlertView alloc] initWithTitle:@"请稍等" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            [alert show];
        });
        
        
        // 展示结果页面
        [self presentViewController:resultViewController animated:YES completion:^{
            
            dispatch_async(dispatch_get_main_queue(), ^() {
                
                [resultViewController setLivenessResult:@"不通过" withVerificationResult:@"没有比对" withVerificationImage: nil];
                [alert dismissWithClickedButtonIndex:0 animated:YES];
            });
            
        }];
    }];
}

/**
 *  取消按钮的操作方法
 */
- (void) onLivenessCancel {
    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fanpaiAction:(id)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"RegistrationPage" bundle: nil];
    
    CaptureDatabaseImageViewController *captureRecentPhotoViewController = (CaptureDatabaseImageViewController *) [board instantiateViewControllerWithIdentifier: @"CaptureIDCardStoryboard"];
    
    //设置翻拍
    __weak typeof(self) weakSelf = self;
    
//    [captureRecentPhotoViewController passValues:invitationCode withSecondValue:password];
    
    [captureRecentPhotoViewController startDatabaseImageCapture:weakSelf
                                                 withAccessInfo:nil
                                                withCaptureMode:IDCARD_FRONT];
    
    [self presentViewController:captureRecentPhotoViewController animated:YES completion:nil];
}

/**
 *  捕获到合格的登记照片时的回调函数
 *
 *  @param imageContent 图片内容。如需网络传输，请调用UIImageJPEGRepresentation(imageContent, 0.7)
 *  @param face 检测到的人脸信息。如果为nil表示未检测到或检测到多张人脸
 *  @param error 错误信息
 */
- (void) onDatabaseImageTaken: (UIImage*) imageContent
             withDetectedFace: (FaceRect*) face
                    withError: (NSError *) error {
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //显示翻拍照结果
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
            
            RegisterResultViewController * registerResultViewController = (RegisterResultViewController*) [board instantiateViewControllerWithIdentifier: @"RegisterResultViewStoryboard"];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                [self presentViewController:registerResultViewController animated:YES completion:^{
                    
                    [registerResultViewController setResultImage:imageContent];
                    
                }];
            }];
        });
        
    });
}

/**
 *  用户点击取消按钮后的响应事件
 */
- (void) onCancelCapture {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
