
#import "HDMaterialModel.h"
#import "HDPictureModel.h"
@implementation HDMaterialModel

- (void)setLiushui:(NSArray *)liushui{
    _liushui = [HDPictureModel mj_objectArrayWithKeyValuesArray:liushui];
}

- (void)setZichan:(NSArray *)zichan{
    _zichan = [HDPictureModel mj_objectArrayWithKeyValuesArray:zichan];
}

- (void)setOthers:(NSArray *)others{
    _others = [HDPictureModel mj_objectArrayWithKeyValuesArray:others];
}

@end
