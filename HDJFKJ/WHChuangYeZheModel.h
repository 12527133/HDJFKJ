

#import <Foundation/Foundation.h>
//创业者模型
@interface WHChuangYeZheModel : NSObject
//申请人企业名称
@property (nonatomic, strong) NSString * corporation;
//企业电话
@property (nonatomic, strong) NSString * corporationTelNo;
//企业地址，省
@property (nonatomic, strong) NSString * corporationAddrProvince;
//企业地址，市区
@property (nonatomic, strong) NSString * corporationAddrCounty;
//企业详细地址地址
@property (nonatomic, strong) NSString * corporationAddr;
//企业规模：5人以下,5-10人,10-20,20-50,50-100,100人以上
@property (nonatomic, strong) NSString * corporationScale;
//企业年限：1年以下,1-3年,3-5年,5-10年,10年以上
@property (nonatomic, strong) NSString * corporationYear;


+ (instancetype)paresChuangYeZheModelWithDictionary:(NSDictionary *)dict;

@end
