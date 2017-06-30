//
//  LDIDCardModel.h
//  HDJFKJ
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDIDCardModel : NSObject
/**
 *  姓名
 */
@property (nonatomic,copy) NSString * name;
/**
 *  性别
 */
@property (nonatomic,copy) NSString * sex;
/**
 *  民族
 */
@property (nonatomic,copy) NSString * folk;
/**
 *  生日
 */
@property (nonatomic,copy) NSString * birthday;
/**
 *  地址
 */
@property (nonatomic,copy) NSString * address;
/**
 *  身份证号
 */
@property (nonatomic,copy) NSString * IDCardNumber;
/**
 *  有效期
 */
@property (nonatomic,copy) NSString * idTermBegin;
@property (nonatomic,copy) NSString * idTermEnd;
@property (nonatomic,copy) NSString * IDCardTimer;
/**
 *  工作类型
 */
@property (nonatomic,copy) NSString * jobType;

@end
