

#import "WHChuangYeZheModel.h"

@implementation WHChuangYeZheModel



+ (instancetype)paresChuangYeZheModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.corporation = NULLOBJ([dict objectForKey:@"corporation"]);
    self.corporationTelNo = NULLOBJ([dict objectForKey:@"corporationTelNo"]);
    self.corporationAddrProvince = NULLOBJ([dict objectForKey:@"corporationAddrProvince"]);
    self.corporationAddrCounty = NULLOBJ([dict objectForKey:@"corporationAddrCounty"]);
    self.corporationAddr = NULLOBJ([dict objectForKey:@"corporationAddr"]);
    self.corporationScale = NULLOBJ([dict objectForKey:@"corporationScale"]);
    self.corporationYear = NULLOBJ([dict objectForKey:@"corporationYear"]);
    return self;
}


@end
