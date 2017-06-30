//
//  NSString+MXRegularExpression.m
//  LifeCircle
//
//  Created by apple apple on 15/11/26.
//  Copyright © 2015年 shuangxing. All rights reserved.
//

#import "NSString+MXRegularExpression.h"

@implementation NSString (MXRegularExpression)

+ (BOOL)isEmailAddress:(NSString*)candidate
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

-(NSNumber *)asNumber;{
    NSString *regEx = @"^-?\\d+.?\\d?";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    BOOL isMatch            = [pred evaluateWithObject:self];
    if (isMatch) {
        return [NSNumber numberWithDouble:[self doubleValue]];
    }
    return nil;
}

- (BOOL)isUserName
{
    NSString *      regex = @"(^[A-Za-z0-9]{3,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isIDCard
{
    NSString *      regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
- (BOOL)isRegisterPassword{
    NSString *      regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,32}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
- (BOOL)isPassword
{
    NSString *      regex = @"(^[A-Za-z0-9]{6,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
- (BOOL)isChinese
{
    NSString *      regex = @"[\u4E00-\u9FA5]{1,20}(?:·[\u4E00-\u9FA5]{1,20})*";
    
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *      regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
- (BOOL)isNumber//0和正整数,自然数
{
    NSString *      regex = @"\\d+";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
- (BOOL)isZhengNumber//正整数
{
    NSString *      regex = @"[1-9][0-9]*";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isCreditCard
{
    NSString *      regex = @"((?:4\\d{3})|(?:5[1-5]\\d{2})|(?:6011)|(?:3[68]\\d{2})|(?:30[012345]\\d))[ -]?(\\d{4})[ -]?(\\d{4})[ -]?(\\d{4}|3[4,7]\\d{13})";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isUrl
{
    NSString *      regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isLandlinetelephone{
    NSString * PHS = @"^0\\d{2}-\\d{8}|0\\d{3}-\\d{8}|0\\d{3}-\\d{7}$";
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    return [regextestphs evaluateWithObject:self];
}

- (BOOL)isTelephone:(NSString *)patternStr
{
    NSString *pattern = @"^1[34578]\\d{9}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
    
    

}

- (BOOL) isCellPhoneNum{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return  [regextestmobile evaluateWithObject:self];
}

@end
