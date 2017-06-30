

#import "HDFirstPageModel.h"

@implementation HDFirstPageModel


- (void)setBanner:(NSArray *)banner{

    _banner = [HDFirstPageBanner mj_objectArrayWithKeyValuesArray:banner];
}

@end
