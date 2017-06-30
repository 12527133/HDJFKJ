

#import <Foundation/Foundation.h>
#import "HDAreaModel.h"

@interface HDCityModel : NSObject

/** 城市编码 */
@property (nonatomic, strong) NSString * areaId;

/** 城市名称 */
@property (nonatomic, strong) NSString * areaName;

/** 县市数组 */
@property (nonatomic, strong) NSArray * counties;
@end
