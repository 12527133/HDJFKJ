

#import "WHQROrderModel.h"
#import "HDQRCommodity.h"
@implementation WHQROrderModel


+(instancetype)sharedInstance{
    
    static WHQROrderModel *instance;
    
    static dispatch_once_t oneceToken;
    
    dispatch_once(&oneceToken, ^{
        
        instance = [[WHQROrderModel alloc]init];
        
    });
    
    return instance;
}



- (void)setCommoditys:(NSArray *)commoditys{

    _commoditys = [HDQRCommodity mj_objectArrayWithKeyValuesArray:commoditys];
}

@end
