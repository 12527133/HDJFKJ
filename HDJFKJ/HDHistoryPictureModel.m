

#import "HDHistoryPictureModel.h"
#import "HDHistoryPictureList.h"
@implementation HDHistoryPictureModel


- (void)setOthers:(NSArray *)others{

    _others = [HDHistoryPictureList mj_objectArrayWithKeyValuesArray:others];
}

@end
