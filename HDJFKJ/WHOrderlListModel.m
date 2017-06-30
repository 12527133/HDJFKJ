//
//  WHOrderlListModel.m
//  HDJFKJ
//
//  Created by 石伟浩 on 16/4/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "WHOrderlListModel.h"

@implementation WHOrderlListModel
+ (instancetype)paresOrderListWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    if (self == [super init]) {
        self.ids = [NULLOBJ([dict objectForKey:@"id"]) integerValue];
        self.businessid = [NULLOBJ([dict objectForKey:@"businessid"]) integerValue];
        self.businessname = NULLOBJ([dict objectForKey:@"businessname"]);
        self.pic = NULLOBJ([dict objectForKey:@"pic"]);
        self.commodityname = NULLOBJ([dict objectForKey:@"commodityname"]);
        self.category = NULLOBJ([dict objectForKey:@"category"]);
        self.apply_amount = [NULLOBJ([dict objectForKey:@"applyamount"]) floatValue];
        self.privilege = [NULLOBJ([dict objectForKey:@"privilege"]) integerValue];
        self.duration = [NULLOBJ([dict objectForKey:@"duration"]) integerValue];
        self.periodamount = [NULLOBJ([dict objectForKey:@"periodamount"]) floatValue];
        self.status = NULLOBJ([dict objectForKey:@"status"]);
        
        
    }
    return self;
}











@end
