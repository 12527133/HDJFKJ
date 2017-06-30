//
//  LDUserInformation.h
//  HDJFKJ
//
//  Created by apple on 16/3/20.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDUserInformation : NSObject


+(instancetype)sharedInstance;

@property(nonatomic,copy)NSString *token;

@property(nonatomic,copy)NSString *UserId;
@property(nonatomic,copy)NSString *phoneNumber;
@property(nonatomic,copy)NSString *passWord;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *locationCity;

@property(nonatomic,copy)NSString *locationName;

/** 通知的唯一标示 */
@property (nonatomic, strong) NSString * deviceToken;

/** 跟新提示版本号，用于选择哪个通讯录 */
@property (nonatomic, strong) NSString * iosVerson;
@end


@interface LDBackInformation : NSObject

/** 2.0接口返回结果 */
@property(nonatomic,copy)NSString *code;

@property(nonatomic,copy)NSString *message;

@property (nonatomic, strong) id result;

/** 1.0接口返回结果 */

/** 返回码*/
@property (nonatomic, strong) NSString * errcode;

/** 返回信息*/
@property (nonatomic, strong) NSString * msg;

/** 返回数据*/
@property (nonatomic, strong) NSDictionary * object;

@end
