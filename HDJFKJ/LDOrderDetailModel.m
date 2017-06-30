//
//  LDOrderDetailModel.m
//  HDJFKJ
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDOrderDetailModel.h"

@implementation LDOrderDetailModel

+(instancetype)sharedInstance{
    
    static LDOrderDetailModel *instance;
    
    static dispatch_once_t oneceToken;
    
    dispatch_once(&oneceToken, ^{
        
        instance = [[LDOrderDetailModel alloc]init];
        
    });
    
    return instance;
}

@end
@implementation LDOrderDetailBackModel

@end