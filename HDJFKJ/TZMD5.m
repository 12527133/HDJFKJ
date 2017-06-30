//
//  TZMD5.m
//  LoveHealth
//
//  Created by _TZ on 14-9-5.
//  Copyright (c) 2014年 _TZ. All rights reserved.
//

#import "TZMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation TZMD5

-(NSString *) md5HexDigestWithString:(NSString *)str

{
    
    NSString * key = [self getMd5_32Bit_String:@"juju5dmm123"];
    NSString * str1 = [self getMd5_32Bit_String:str];
    NSString * password = [str1 stringByAppendingString:key];
    return [self getMd5_32Bit_String:password];
    
}


- ( NSString *)getMd5_32Bit_String:( NSString *)srcString{
    
    const char *cStr = [srcString UTF8String ];
    
    unsigned char digest[ CC_MD5_DIGEST_LENGTH ];
    
    CC_MD5 ( cStr, strlen (cStr), digest );
    
    NSMutableString *result = [ NSMutableString stringWithCapacity : CC_MD5_DIGEST_LENGTH * 2 ];
    
    for ( int i = 0 ; i < CC_MD5_DIGEST_LENGTH ; i++)
        
        [result appendFormat : @"%02x" , digest[i]];
    
    return result;
    
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result];
    }
    return ret;
}




@end
