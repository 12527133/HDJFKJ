//
//  LDTextTableViewController.h
//  HDJFKJ
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDIDCardModel.h"

@interface LDBaseInformationTableViewController : LDBaseUIViewController
/**
 *  工作类型
 */
@property (nonatomic,strong) NSString * jobType;
/**
 *  哪个流程"zhuce","xiadan","wode","xianjindai"取值情况:四个字符串,
 */
@property (nonatomic,copy) NSString * fromeWhere;
@property (nonatomic,strong) LDIDCardModel * baseModel;

//身份证界面是否重新上传了基本信息
@property (nonatomic, assign) BOOL sendUserMessage;

//原来的工作类型
//@property (nonatomic, strong) NSString * oldJobType;
@end
