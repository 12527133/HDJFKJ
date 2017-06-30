//
//  ResultViewController.h
//  ZhongAn
//
//  Created by Xiaoyang Lin on 16/1/18.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetectedFrame.h"

@interface ExampleResultViewController : UIViewController

/**
 *  设置结果页面的信息
 *
 *  @param resultText         活体检测结果文字
 *  @param verificationResult 身份比对结果
 *  @param verificationResultImage 身份比对结果回显
 */
//- (void) setLivenessResult: (NSString*) resultText;

- (void) setLivenessResult: (NSString*) resultText
    withVerificationResult: (NSString*) verificationResult
    withVerificationImage : (NSData*) ImageData;

@end
