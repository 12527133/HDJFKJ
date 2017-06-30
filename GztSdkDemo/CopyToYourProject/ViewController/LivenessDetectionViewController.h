//
//  LivenessDetectionViewController.h
//  LivenessDetectionViewSDK
//
//  Created by Jiteng Hao on 16/1/11.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewUpdateEventDelegate.h"
#import "LivenessResultDelegate.h"

@interface LivenessDetectionViewController : UIViewController <ViewUpdateEventDelegate>

/**
 *  启动活体检测
 *
 *  @param delegate 委托对象
 *  @param error    出错信息
 *
 *  @return 是否成功
 */
- (BOOL) setConfigLivenessDetection: (id<LivenessResultDelegate>) delegate
                     withError: (NSError **) error;
-(void)passValues:(NSString *)value1 withSecondValue:(NSString*)value2;

@end
