//
//  NSString+MXRegularExpression.h
//  LifeCircle
//
//  Created by apple apple on 15/11/26.
//  Copyright © 2015年 shuangxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MXRegularExpression)

// 类方法,判断字符串是不是邮箱地址
+(BOOL)isEmailAddress:(NSString*)candidate;
/**
 *  信用卡
 *
 *  @return <#return value description#>
 */
- (BOOL)isCreditCard;
- (BOOL)isIDCard;
- (BOOL)isZhengNumber;//正整数

-(NSNumber *)asNumber;
- (BOOL)isNumber;//0和正整数,自然数

- (BOOL)isUserName;
- (BOOL)isRegisterPassword;
- (BOOL)isPassword;
- (BOOL)isChinese;

// 字符串是否是邮箱地址
- (BOOL)isEmail;

// 字符串是否是网址
- (BOOL)isUrl;

// 字符串是否是电话号码
- (BOOL)isTelephone:(NSString *)patternStr;
//判断是否是固定电话
- (BOOL)isLandlinetelephone;
// 字符串是否是手机号码
- (BOOL) isCellPhoneNum;
@end
