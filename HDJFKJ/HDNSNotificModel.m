

#import "HDNSNotificModel.h"

@implementation HDNSNotificModel

+(instancetype)sharedInstance{
    
    static HDNSNotificModel *instance;
    
    static dispatch_once_t oneceToken;
    
    dispatch_once(&oneceToken, ^{
        
        instance = [[HDNSNotificModel alloc] init];
        
    });
    
    return instance;
}

@end
