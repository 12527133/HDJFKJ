

#import <UIKit/UIKit.h>

@class WHQROrderModel,WHOrderListModel;

@interface WHWithOutOrderCell : UITableViewCell

/** WHWithOrder  */
@property (nonatomic,strong) WHQROrderModel * orderModel;
/** WHOrderListModel  */
@property (nonatomic,strong) WHOrderListModel * orderListModel;

@end
