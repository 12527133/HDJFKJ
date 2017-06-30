//
//  LDJobTabbleViewController.h
//  HDJFKJ
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDJobTabbleViewController : UIViewController
/**
 *  哪个流程
 */
@property (nonatomic,copy) NSString * fromeWhere;

//新的工作类型
@property (nonatomic, strong) NSString * jobType;

//原来的工作类型
//@property (nonatomic, strong) NSString * oldJobType;

@end
