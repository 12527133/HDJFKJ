//
//  LDBasicModel.m
//  HDJFKJ
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBasicModel.h"

@implementation LDBasicModel 

+ (instancetype)LDBasicModelWiDict:(NSDictionary *)dict{
    
    return [[self alloc]initWithDict:dict];
    
}

-(instancetype)initWithDict:(NSDictionary *)dict{

    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

@end
