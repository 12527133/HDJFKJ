//
//  LDAdvancedInformation.h
//  HDJFKJ
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDAdvancedInformation : UIViewController
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


@end
