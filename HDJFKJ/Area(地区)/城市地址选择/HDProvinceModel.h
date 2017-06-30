

#import <Foundation/Foundation.h>
#import "HDCityModel.h"
@interface HDProvinceModel : NSObject

/** 省份编码 */
@property (nonatomic, strong) NSString * areaId;

/** 省份名称 */
@property (nonatomic, strong) NSString * areaName;

/** 城市数组 */
@property (nonatomic, strong) NSArray * cities;



@end
