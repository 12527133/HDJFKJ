

#import <UIKit/UIKit.h>
#import "LDNewOrderDetailModel.h"
@interface HDNewOrderThirdCell : UITableViewCell

@property (nonatomic,strong) LDNewOrderDetailModel * orderDetailModel;

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *yewuyuanLabel;

@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel;
@end
