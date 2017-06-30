//
//  UserInfo.m
//  HDJFKJ
//
//  Created by apple on 16/3/6.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+(instancetype)sharedInstance{
    
    static UserInfo *instance;
    
    static dispatch_once_t oneceToken;
    
    dispatch_once(&oneceToken, ^{
        
        instance = [[UserInfo alloc]init];
        
    });
    
    return instance;
}




@end
