

#import "WHHomeGoodsModel.h"

@implementation WHHomeGoodsModel

+ (instancetype)paresGoodWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
   
    self.id = NULLOBJ([dict objectForKey:@"id"]);
    self.pic = NULLOBJ([dict objectForKey:@"pic"]);
    self.name = NULLOBJ([dict objectForKey:@"name"]);
    self.star = [NULLOBJ([dict objectForKey:@"star"]) floatValue];
    self.sale = [NULLOBJ([dict objectForKey:@"sale"]) integerValue];
    self.businessname = NULLOBJ([dict objectForKey:@"businessname"]);
    self.privilege = [NULLOBJ([dict objectForKey:@"privilege"]) integerValue];
    self.duration = [NULLOBJ([dict objectForKey:@"duration"]) integerValue];
    self.periodamount = [NULLOBJ([dict objectForKey:@"periodamount"]) floatValue];
    self.downpayment = [NULLOBJ([dict objectForKey:@"downpayment"]) floatValue];
    
    return self;
}




















@end
