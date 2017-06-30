//
//  WHAdcommodityModel.m
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "WHAdcommodityModel.h"

@implementation WHAdcommodityModel

+ (instancetype)paresAdcommodityWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    if (self == [super init]) {
        self.sn = [[dict objectForKey:@"sn"] integerValue];
        self.ids = [dict objectForKey:@"id"];
        self.pic = [dict objectForKey:@"pic"];
    }
    return self;
}





@end
