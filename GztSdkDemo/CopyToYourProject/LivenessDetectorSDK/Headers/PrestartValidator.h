//
//  AsyncPrestartValidator.h
//  LivenessDetector
//
//  Created by Jiteng Hao on 16/1/11.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AsyncPrestartValidatorDelegate.h"
#import "AsyncLivenessDetectorDelegate.h"
#import "PhotoImage.h"
#import "SessionManagerConfig.h"

@interface PrestartValidator : NSObject<AsyncLivenessDetectorDelegate>


- (BOOL) setConfig: (SessionManagerConfig *) config
           withDelegate: (id<AsyncPrestartValidatorDelegate>) delegate
         withError:(NSError **) error;

- (BOOL) unInit: (NSError **) error;

- (BOOL) restartSession;

- (BOOL) doDetection: (PhotoImage *) photoContent
           withError:(NSError *__autoreleasing *)error;

@end
