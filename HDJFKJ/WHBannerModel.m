

#import "WHBannerModel.h"

@implementation WHBannerModel

+ (instancetype)paresBannerWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    if (self == [super init]) {
        
        self.id = NULLOBJ([dict objectForKey:@"id"]);
        self.pic = NULLOBJ([dict objectForKey:@"pic"]);
    }
    return self;
}


@end
