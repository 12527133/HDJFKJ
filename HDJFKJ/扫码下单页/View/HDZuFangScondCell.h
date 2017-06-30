

#import <UIKit/UIKit.h>
#import "WHQROrderModel.h"

@interface HDZuFangScondCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *kehuxingmingLabel;

@property (weak, nonatomic) IBOutlet UILabel *kehushoujiLabel;

@property (weak, nonatomic) IBOutlet UILabel *qizuriqiLabel;

@property (weak, nonatomic) IBOutlet UILabel *daoqiriqiLabel;

@property (weak, nonatomic) IBOutlet UILabel *shoufufangshiLabel;


@property (nonatomic,strong) WHQROrderModel * detailModel;
@end
