

#import <Foundation/Foundation.h>
//学生的信息
@interface WHStudentInfoModel : NSObject
//学校
@property (nonatomic, strong) NSString * school;
//学院
@property (nonatomic, strong) NSString * academy;
//学校地址，省
@property (nonatomic, strong) NSString * schoolAddressProvince;
//市区
@property (nonatomic, strong) NSString * schoolAddressCounty;
//学校详细地址
@property (nonatomic, strong) NSString * schoolAddressDetail;
//宿舍号
@property (nonatomic, strong) NSString * domitory;
//偿还能力
@property (nonatomic, strong) NSString * periodUndertake;

+ (instancetype)paresStudentInfoModelWithDictionary:(NSDictionary *)dict;

@end
