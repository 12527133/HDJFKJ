

#import "HDHistoryPictureList.h"
#import "HDPictureModel.h"
@implementation HDHistoryPictureList


- (void)setPicList:(NSArray *)picList{


    _picList = [HDPictureModel mj_objectArrayWithKeyValuesArray:picList];
}

@end
