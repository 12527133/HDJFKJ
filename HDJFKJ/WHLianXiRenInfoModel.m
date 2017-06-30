

#import "WHLianXiRenInfoModel.h"

@implementation WHLianXiRenInfoModel



+ (instancetype)paresRelationInfoModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    if (self == [super init]) {
        
        
        self.name1 = NULLOBJ([dict objectForKey:@"name1"]);
        self.relation1 = NULLOBJ([dict objectForKey:@"relation1"]);
        self.phone1 = NULLOBJ([dict objectForKey:@"phone1"]);
        self.name2 = NULLOBJ([dict objectForKey:@"name2"]);
        self.relation2 = NULLOBJ([dict objectForKey:@"relation2"]);
        self.phone2 = NULLOBJ([dict objectForKey:@"phone2"]);
        self.name3 = NULLOBJ([dict objectForKey:@"name3"]);
        self.relation3 = NULLOBJ([dict objectForKey:@"relation3"]);
        self.phone3 = NULLOBJ([dict objectForKey:@"phone3"]);
        
        
    }
    return self;
}


















































@end
