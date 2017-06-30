

#import "WHShouYeModel.h"

@implementation WHShouYeModel




+ (instancetype)paresShouYeWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    if (self == [super init]) {
        self.region = NULLOBJ([dict objectForKey:@"region"]);
        self.repaystatus = NULLOBJ([dict objectForKey:@"repaystatus"]);
        self.messagecount = NULLOBJ([dict objectForKey:@"messagecount"]) ;
        self.banner = [dict objectForKey:@"banner"];
        self.bannerdown = [dict objectForKey:@"bannerdown"];
        self.categoryadcommoditys = [dict objectForKey:@"categoryadcommoditys"];
    }
    return self;
}














@end
