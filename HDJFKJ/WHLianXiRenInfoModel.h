

#import <Foundation/Foundation.h>

@interface WHLianXiRenInfoModel : NSObject
//联系人1姓名
@property (nonatomic, strong) NSString * name1;
//联系人1关系
@property (nonatomic, strong) NSString * relation1;
//联系人1电话
@property (nonatomic, strong) NSString * phone1;
//联系人2姓名
@property (nonatomic, strong) NSString * name2;
//联系人2关系
@property (nonatomic, strong) NSString * relation2;
//联系人2电话
@property (nonatomic, strong) NSString * phone2;
//联系人3姓名
@property (nonatomic, strong) NSString * name3;
//联系人3关系
@property (nonatomic, strong) NSString * relation3;
//联系人3电话
@property (nonatomic, strong) NSString * phone3;






+ (instancetype)paresRelationInfoModelWithDictionary:(NSDictionary *)dict;








@end
