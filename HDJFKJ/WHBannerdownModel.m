

#import "WHBannerdownModel.h"

@implementation WHBannerdownModel

+ (instancetype)paresBannerdownWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    if (self == [super init]) {
        self.pose = [NULLOBJ([dict objectForKey:@"pose"]) integerValue];
        self.id = NULLOBJ([dict objectForKey:@"id"]);
        self.pic = NULLOBJ([dict objectForKey:@"pic"]);
    }
    return self;
}


@end
