

#import "WHBaseInfoModel.h"
//请求到的数据的用户基本信息
@implementation WHBaseInfoModel


+ (instancetype)paresBaseInfoModelWithDictionary:(NSDictionary *)dict{
    
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    
    
    
    if (self == [super init]) {
        
        self.addrCounty = NULLOBJ([dict objectForKey:@"addrCounty"]);
        self.addrProvince = NULLOBJ([dict objectForKey:@"addrProvince"]);
        self.addrTown = NULLOBJ([dict objectForKey:@"addrTown"]);
        self.birth = NULLOBJ([dict objectForKey:@"birth"]);
        self.education = NULLOBJ([dict objectForKey:@"education"]);
        self.email = NULLOBJ([dict objectForKey:@"email"]);
        self.idName = NULLOBJ([dict objectForKey:@"idName"]);
        self.idNo = NULLOBJ([dict objectForKey:@"idNo"]);
        self.marital = NULLOBJ([dict objectForKey:@"marital"]);
        self.occupation = NULLOBJ([dict objectForKey:@"occupation"]);
        self.regAddrCounty = NULLOBJ([dict objectForKey:@"regAddrCounty"]);
        self.regAddrProvince = NULLOBJ([dict objectForKey:@"regAddrProvince"]);
        self.regAddrTown = NULLOBJ([dict objectForKey:@"regAddrTown"]);
        self.sex = NULLOBJ([dict objectForKey:@"sex"]);
        self.isNewRecord = NULLOBJ([dict objectForKey:@"isNewRecord"]);
        self.idTermBegin = NULLOBJ([dict objectForKey:@"idTermBegin"]);
        self.idTermEnd = NULLOBJ([dict objectForKey:@"idTermEnd"]);
        self.faceVerified = NULLOBJ([dict objectForKey:@"faceVerified"]);
        
    }
    return self;
}




























@end
