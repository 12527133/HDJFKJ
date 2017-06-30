

#import "HDSubmitOrder.h"

@implementation HDSubmitOrder

+(instancetype)shardSubmitOrder{

    static HDSubmitOrder * instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[HDSubmitOrder alloc]init];
    });
    
    return instance;

}


- (void)setAttributeNull{

    [[HDSubmitOrder shardSubmitOrder] setApplyAmount:nil];
    [[HDSubmitOrder shardSubmitOrder] setDownpayment:nil];
    [[HDSubmitOrder shardSubmitOrder] setTotalAmount:nil];
    [[HDSubmitOrder shardSubmitOrder] setPackageId:nil];
    [[HDSubmitOrder shardSubmitOrder] setCaseId:nil];
    [[HDSubmitOrder shardSubmitOrder] setCaseDetail:nil];
    [[HDSubmitOrder shardSubmitOrder] setBusinessId:nil];
    [[HDSubmitOrder shardSubmitOrder] setBankcardId:nil];
    [[HDSubmitOrder shardSubmitOrder] setOrderNo:nil];
    [[HDSubmitOrder shardSubmitOrder] setTermial:nil];
    [[HDSubmitOrder shardSubmitOrder] setCommoditys:nil];
    [[HDSubmitOrder shardSubmitOrder] setLoanType:nil];
    [[HDSubmitOrder shardSubmitOrder] setGoodsName:nil];


}


@end
