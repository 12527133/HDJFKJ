

#import "WHCommodity.h"

@implementation WHCommodity


+ (instancetype)paresCommodityWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    if (self == [super init]) {
        self.duration = [NULLOBJ([dict objectForKey:@"duration"]) integerValue];
        self.id = NULLOBJ([dict objectForKey:@"id"]);
        self.pic = NULLOBJ([dict objectForKey:@"pic"]);
        self.name = NULLOBJ([dict objectForKey:@"name"]);
        self.periodamount = [NULLOBJ([dict objectForKey:@"periodamount"]) floatValue];
    }
    return self;
}
















@end
