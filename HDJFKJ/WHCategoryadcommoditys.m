
#import "WHCategoryadcommoditys.h"

@implementation WHCategoryadcommoditys


+ (instancetype)paresCategoryadcommoditysWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    
//    if (self = [super init]){
//        self.category = NULLOBJ([dict objectForKey:@"category"]) ;
//        self.commoditys = [dict objectForKey:@"commoditys"];
//    
//    }
//    return self;
    
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
   
    self.category = NULLOBJ([dict objectForKey:@"category"]) ;
    self.commoditys = [dict objectForKey:@"commoditys"];
    return self;
}










@end
