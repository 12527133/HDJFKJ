

#import <Foundation/Foundation.h>

@interface WHBaseInfoModel : NSObject

//居住地址----市/区/县
@property (nonatomic, strong) NSString * addrCounty;
//居住地址 - 省/直辖市
@property (nonatomic, strong) NSString * addrProvince;
//居住地址 - 街/楼/市
@property (nonatomic, strong) NSString * addrTown;
//出生日期
@property (nonatomic, strong) NSString * birth;
//教育程度【未沿用】：1 高中及以下,2 大学,3 硕士,4 博士
@property (nonatomic, strong) NSString * education;
//邮箱
@property (nonatomic, strong) NSString * email;
//真实姓名
@property (nonatomic, strong) NSString * idName;
//身份证号
@property (nonatomic, strong) NSString * idNo;
//
@property (nonatomic, strong) NSString * isNewRecord;
//婚姻状况：-1其他,0 未婚,1 已婚
@property (nonatomic, strong) NSString * marital;
//身份：1 学生,2 上班族,3 创业者
@property (nonatomic, strong) NSString * occupation;
//户籍所在地 - 市/区/县
@property (nonatomic, strong) NSString * regAddrCounty;
//户籍所在地 - 省/直辖市
@property (nonatomic, strong) NSString * regAddrProvince;
//户籍所在地 - 街/楼/市
@property (nonatomic, strong) NSString * regAddrTown;
//性别：男，女
@property (nonatomic, strong) NSString * sex;
//身份证开始时间
@property (nonatomic, strong) NSString * idTermBegin;
//身份证结束时间
@property (nonatomic, strong) NSString * idTermEnd;
//是否人脸识别
@property (nonatomic, strong) NSString * faceVerified;
@property (nonatomic, strong) NSString * faceSimilarity;
@property (nonatomic, strong) NSString * faceResult;

/** 居住地址 */
@property (nonatomic, strong) NSString * homeProvince;
@property (nonatomic, strong) NSString * homeCity;
@property (nonatomic, strong) NSString * homeArea;
@property (nonatomic, strong) NSString * homeProvinceCode;
@property (nonatomic, strong) NSString * homeCityCode;
@property (nonatomic, strong) NSString * homeAreaCode;
@property (nonatomic, strong) NSString * homeAddress;


+ (instancetype)paresBaseInfoModelWithDictionary:(NSDictionary *)dict;















@end
