

#import "WHShangBanZuModel.h"

@implementation WHShangBanZuModel


+ (instancetype)paresShangBanModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    if (self == [super init]) {
        
        
        self.company = NULLOBJ([dict objectForKey:@"company"]);
        self.work = NULLOBJ([dict objectForKey:@"work"]);
        self.companyScale = NULLOBJ([dict objectForKey:@"companyScale"]);
        self.workYear = NULLOBJ([dict objectForKey:@"workYear"]);
        self.fullWorkYear = NULLOBJ([dict objectForKey:@"fullWorkYear"]);
        self.position = NULLOBJ([dict objectForKey:@"position"]);
        self.companyAddrProvince = NULLOBJ([dict objectForKey:@"companyAddrProvince"]);
        self.companyAddrCounty = NULLOBJ([dict objectForKey:@"companyAddrCounty"]);
        self.companyAddrTown = NULLOBJ([dict objectForKey:@"companyAddrTown"]);
        self.companyTelNo = NULLOBJ([dict objectForKey:@"companyTelNo"]);
        
        
    }
    return self;
}



@end
