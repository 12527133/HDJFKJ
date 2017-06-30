

#import <UIKit/UIKit.h>
#import "LDNewOrderListModel.h"

@interface HDOrderListCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *commodityNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) LDNewOrderListModel * listModel;



@end
