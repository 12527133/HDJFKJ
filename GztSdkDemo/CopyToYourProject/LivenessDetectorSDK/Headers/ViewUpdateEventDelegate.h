//
//  AsyncLivenessDetectorDelegate.h
//  LivenessDetectionViewSDK
//
//  Created by Jiteng Hao on 16/1/12.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncPrestartValidatorDelegate.h"
#import "AsyncLivenessDetectorDelegate.h"

@protocol ViewUpdateEventDelegate <NSObject, AsyncLivenessDetectorDelegate, AsyncPrestartValidatorDelegate>


@optional
/**
 * 初始化成功的回调
 */
- (void) onInitializeSucc;

/**
 * 初始化失败的回调
 */
- (void) onInitializeFail:(NSError *) error;

@end
