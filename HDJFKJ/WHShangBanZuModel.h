

#import <Foundation/Foundation.h>

@interface WHShangBanZuModel : NSObject

//单位名称
@property (nonatomic, strong) NSString * company;
//职业：公务人员，教师，普通职员，工人，其他
@property (nonatomic, strong) NSString * work;
//单位规模:10人以下,10-100人,100人以上
@property (nonatomic, strong) NSString * companyScale;
//现单位工作年限：1年以下，1-3年，3-5年，5-10年，10年以上
@property (nonatomic, strong) NSString * workYear;
//总工作年限：1年以下，1-3年，3-5年，5-10年，10年以上
@property (nonatomic, strong) NSString * fullWorkYear;
//职务【沿用】:1 高级管理人员,11 厅局级以上,12 处级,13 科级,14 一般干部,2 一般管理人员,3 一般正式员工,4 非正式员工,5 无,6 企业负责人,7 中层管理人员,9 其他
@property (nonatomic, strong) NSString * position;
//单位地址 - 省/直辖市
@property (nonatomic, strong) NSString * companyAddrProvince;
//单位地址 - 市/区/县
@property (nonatomic, strong) NSString * companyAddrCounty;
//单位地址 - 街/楼/市
@property (nonatomic, strong) NSString * companyAddrTown;
//单位电话
@property (nonatomic, strong) NSString * companyTelNo;




+ (instancetype)paresShangBanModelWithDictionary:(NSDictionary *)dict;











@end
