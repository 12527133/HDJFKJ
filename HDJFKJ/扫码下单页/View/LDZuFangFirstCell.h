

#import <UIKit/UIKit.h>
#import "WHQROrderModel.h"

@interface LDZuFangFirstCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic,strong) WHQROrderModel * detailModel;

@end
