//
//  ResultViewController.m
//  ZhongAn
//
//  Created by Xiaoyang Lin on 16/1/18.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import "ExampleResultViewController.h"

@interface ExampleResultViewController ()

// 展示活体检测结果的Label
@property (weak, nonatomic) IBOutlet UILabel *livenessResultLabel;
@property (nonatomic,strong) UIImageView * leftImageView;

@end

NSData *portraitData;

@implementation ExampleResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置结果页面的信息
 *
 *  @param resultText         活体检测结果文字
 *  @param verificationResult 身份比对结果
 */
//- (void) setLivenessResult: (NSString*) resultText {
//    [_livenessResultLabel setText:resultText];
//
//}

- (void) setLivenessResult: (NSString*) resultText
    withVerificationResult: (NSString*) verificationResult
    withVerificationImage : (NSData*) ImageData {
    
    [_livenessResultLabel setText:resultText];
    
    portraitData = ImageData;
    NSLog(@"%@",ImageData);

    //    NSLog(@"#################%@#############",portraitData);
}

@end
