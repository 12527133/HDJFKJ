//
//  ScranResultViewController.m
//  BanCardScan
//
//  Created by zhangchunlin on 15/5/27.
//  Copyright (c) 2015年 Aptogo Limited. All rights reserved.
//

#import "ScranResultViewController.h"

@interface ScranResultViewController ()

@end

@implementation ScranResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.okButton.layer setCornerRadius:5];
    //self.resultLabel.text = self.info;
    //self.resultImage.image = self.image;
    //self.view.backgroundColor = [ UIColor clearColor];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    int width = frame.size.width;
    int height = frame.size.height;
    CGRect frame1 = CGRectMake(0, 0, height, width);
    
    //self.drawView = [[CameraDrawView alloc]initWithFrame:frame1];
    //self.drawView.backgroundColor = [UIColor clearColor];
    
    UIView * AllView = [[UIView alloc] initWithFrame:frame1];
    
    AllView.backgroundColor = [UIColor lightGrayColor];
    int w_1_9 = width * 1 / 9;
    int w_2_9 = width * 2 / 9;
    int w_3_9 = width * 3 / 9;
    UIView * TopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height, w_2_9)];
    TopView.backgroundColor = [UIColor darkGrayColor];
    
    CGRect rect = CGRectMake(10, w_2_9 / 4, height, w_2_9 / 2);
    UILabel *lable = [[UILabel alloc] initWithFrame:rect];
    lable.text = @"确认信息";
    lable.textColor = [UIColor redColor];
    lable.font = [UIFont boldSystemFontOfSize:19];
    lable.backgroundColor = [UIColor clearColor];
    //lable.transform=CGAffineTransformMakeRotation(M_PI/2);
    lable.textAlignment = NSTextAlignmentLeft;
    [TopView addSubview:lable];
    
    UILabel *txtlable = [[UILabel alloc] initWithFrame:CGRectMake(0, w_2_9, height, w_1_9)];
    txtlable.text = @"请核对信息，确认无误.";
    txtlable.textColor = [UIColor blackColor];
    txtlable.font = [UIFont boldSystemFontOfSize:15];
    txtlable.backgroundColor = [UIColor clearColor];
    //lable.transform=CGAffineTransformMakeRotation(M_PI/2);
    txtlable.textAlignment = NSTextAlignmentLeft;
    
    [AllView addSubview:TopView];
    [AllView addSubview:txtlable];
    
    _resultImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, w_2_9 + w_1_9, height,w_2_9)];
    if (self.image != NULL) {
        _resultImage.image = self.image;
    }
    [AllView addSubview:_resultImage];
    
    
    _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, w_2_9 + w_1_9 + w_2_9, height, w_3_9)];
    if (self.info) {
        _resultLabel.text = self.info;
    }
    else
        _resultLabel.text = @"";
    _resultLabel.textColor = [UIColor blackColor];
    _resultLabel.font = [UIFont boldSystemFontOfSize:11];
    _resultLabel.numberOfLines = 8;
    _resultLabel.backgroundColor = [UIColor clearColor];
    //lable.transform=CGAffineTransformMakeRotation(M_PI/2);
    _resultLabel.textAlignment = NSTextAlignmentLeft;
    [AllView addSubview:_resultLabel];
    
//    _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _BackButton.frame = CGRectMake(height*3/11, 145+80+180, height*2/11, height*2/11/3);
//    _BackButton.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:51/255.0 alpha:1];;
//    [_BackButton setTitle:@"再次扫描" forState:UIControlStateNormal];
//    [_BackButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [AllView addSubview:_BackButton];
//
//    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _okButton.frame = CGRectMake(height*6/11, 145+80+180, height*2/11, height*2/11/3);
//    _okButton.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:51/255.0 alpha:1];;
//    [_okButton setTitle:@"确定" forState:UIControlStateNormal];
//    [_okButton addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
//    [AllView addSubview:_okButton];
    _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _BackButton.frame = CGRectMake(height/2 - height/11, w_2_9 + w_1_9 + w_2_9 +w_3_9, height*2/11, w_1_9);
    _BackButton.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:51/255.0 alpha:1];;
    [_BackButton setTitle:@"再次扫描" forState:UIControlStateNormal];
    [_BackButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [AllView addSubview:_BackButton];
    
    [self.view addSubview:AllView];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)dealloc {
//    [_resultImage release];
//    [_resultLabel release];
//    [_okButton release];
//    [super dealloc];
//}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.ScranViewDelegate && [self.ScranViewDelegate respondsToSelector:@selector(SendBankCardSta:)]) { // 如果协议响应了sendIDcardValue:方法
        [self.ScranViewDelegate SendBankCardSta:0]; // 通知执行协议方法
    }
}

- (IBAction)okAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.ScranViewDelegate && [self.ScranViewDelegate respondsToSelector:@selector(SendBankCardSta:)]) { // 如果协议响应了sendIDcardValue:方法
        [self.ScranViewDelegate SendBankCardSta:1]; // 通知执行协议方法
    }
}
-(void) SetInfo:(UIImage *)image Info:(NSString *)info
{
    if (info) {
        self.info = info;
    }
    if (image) {
        self.image = image;
    }
    
}
#pragma mark ---------rotate(only when this controller is presented, the code below effect)-------------
//<iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
//iOS6+
- (BOOL)shouldAutorotate
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //    return [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationLandscapeRight;
}
#endif
@end
