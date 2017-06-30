

#import "WHMessageModel.h"

@implementation WHMessageModel

+ (instancetype)paresMessageWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initDealWithDictionary:dict];
    
}

- (id)initDealWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
  
    self.mid = [NULLOBJ([dict objectForKey:@"MID"]) integerValue];
    self.isread = [NULLOBJ([dict objectForKey:@"isread"]) integerValue];
    self.cumid = [NULLOBJ([dict objectForKey:@"cumid"]) integerValue];
    self.icon = NULLOBJ([dict objectForKey:@"icon"]);
    self.title = NULLOBJ([dict objectForKey:@"title"]);
    self.publishtime = NULLOBJ([dict objectForKey:@"publishtime"]);
    self.content = NULLOBJ([dict objectForKey:@"content"]) ;
    
    return self;
}











@end
