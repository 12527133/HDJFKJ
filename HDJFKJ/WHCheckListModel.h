

#import <Foundation/Foundation.h>

@interface WHCheckListModel : NSObject

//账单状态
@property (nonatomic, assign) NSInteger  status;
//期供金额
@property (nonatomic, strong) NSString * periodamount;
//到期日期
@property (nonatomic, strong) NSString * duedate;
//期次
@property (nonatomic, strong) NSString * period;


+ (instancetype)paresCheckListWithDictionary:(NSDictionary *)dict;




@end
