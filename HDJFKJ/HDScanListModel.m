

#import "HDScanListModel.h"
#import "WHQROrderModel.h"
@implementation HDScanListModel

- (void)setList:(NSMutableArray *)list{

    _list = [WHQROrderModel mj_objectArrayWithKeyValuesArray:list];
}

@end
