

#import "HDCityModel.h"

@implementation HDCityModel

- (void)setCounties:(NSArray *)counties{

    _counties = [HDAreaModel mj_objectArrayWithKeyValuesArray:counties];
}

@end
