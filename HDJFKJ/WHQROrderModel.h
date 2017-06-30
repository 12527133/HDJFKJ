

#import <Foundation/Foundation.h>

@interface WHQROrderModel : NSObject

+(instancetype)sharedInstance;


//商品包id--
@property (nonatomic, strong) NSString * packageId;

//商品总价--
@property (nonatomic, strong) NSString * totalPrice;

//首付金额--
@property (nonatomic, strong) NSString * downpayment;

//商户id--
@property (nonatomic, strong) NSString * businessId;
@property (nonatomic, strong) NSString * bussinessId;

//商户名称--
@property (nonatomic, strong) NSString * businessName;
@property (nonatomic, strong) NSString * bussinessName;

//专案id--
@property (nonatomic, strong) NSString * casesId;
@property (nonatomic, strong) NSString * caseId;

//专案期次--
@property (nonatomic, strong) NSString * duration;

//期供金额--
@property (nonatomic, strong) NSString * periodAmount;

//时间--
@property (nonatomic, strong) NSString * scanTime;
@property (nonatomic, strong) NSString * scanDate;
//分期金额--
@property (nonatomic, strong) NSString * applyAmount;

//商品列表--
@property (nonatomic, strong) NSArray * commoditys;

//状态
@property (nonatomic, strong) NSString * status;
//业务员名称
@property (nonatomic, strong) NSString * saleMan;

/** 租房添加 **/

@property (nonatomic, strong) NSString * applyDate;

@property (nonatomic, strong) NSString * name;

@property (nonatomic, strong) NSString * phone;


@end
