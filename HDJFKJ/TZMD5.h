//
//  TZMD5.h
//  LoveHealth
//
//  Created by _TZ on 14-9-5.
//  Copyright (c) 2014年 _TZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZMD5 : NSObject

-(NSString *) md5HexDigestWithString:(NSString *)str;



+ (NSString *)md5:(NSString *)str;

+ (NSString *)md5HexDigest:(NSString*)input;


@end
