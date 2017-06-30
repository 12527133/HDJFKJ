

#import "HDProvinceModel.h"

@implementation HDProvinceModel

- (void)setCities:(NSArray *)cities{

    _cities = [HDCityModel mj_objectArrayWithKeyValuesArray:cities];
}


@end
