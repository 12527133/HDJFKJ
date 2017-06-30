

#import "WHCheckListModel.h"

@implementation WHCheckListModel

+ (instancetype)paresCheckListWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    
    self.status = [NULLOBJ([dict objectForKey:@"status"]) integerValue];
    self.periodamount = NULLOBJ([dict objectForKey:@"periodamount"]);
    self.duedate = NULLOBJ([dict objectForKey:@"duedate"]);
    self.period = NULLOBJ([dict objectForKey:@"period"]);
        
    
    return self;
}

@end
