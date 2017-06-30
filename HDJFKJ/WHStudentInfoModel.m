

#import "WHStudentInfoModel.h"

@implementation WHStudentInfoModel

+ (instancetype)paresStudentInfoModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    if (self == [super init]) {
        
        self.school = NULLOBJ([dict objectForKey:@"school"]);
        self.academy = NULLOBJ([dict objectForKey:@"academy"]);
        self.schoolAddressProvince = NULLOBJ([dict objectForKey:@"schoolAddressProvince"]);
        self.schoolAddressCounty = NULLOBJ([dict objectForKey:@"schoolAddressCounty"]);
        
        self.schoolAddressDetail = NULLOBJ([dict objectForKey:@"schoolAddressDetail"]);
        self.domitory = NULLOBJ([dict objectForKey:@"domitory"]);
        self.periodUndertake = NULLOBJ([dict objectForKey:@"periodUndertake"]);
        
        
    }
    return self;
}


@end
