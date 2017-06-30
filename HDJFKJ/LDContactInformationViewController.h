//
//  LDContactInformationViewController.h
//  HDJFKJ
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDContactInformationViewController : LDBaseUIViewController

@property(nonatomic,assign) BOOL  isZhuCe;

/**
 *  是否是学生
 */
@property (nonatomic,assign) BOOL  isStudent;
/**
 *  是否是创业者
 */
@property (nonatomic,assign) BOOL isEntrepreneurs;
/**
 *  是否是上班族
 */
@property (nonatomic,assign) BOOL isWorker;

/**
 *  哪个流程
 */
@property (nonatomic,copy) NSString * fromeWhere;

//从信用分跳转过来，判断是否完善过联系人信息，没有完善过，不请求信息
@property (nonatomic, strong) NSString * isFinsh;
@end
