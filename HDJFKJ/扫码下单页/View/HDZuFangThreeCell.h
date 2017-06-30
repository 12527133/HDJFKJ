

#import <UIKit/UIKit.h>
#import "WHQROrderModel.h"

@interface HDZuFangThreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *shenqingBianhaoLabel;

@property (weak, nonatomic) IBOutlet UILabel *shenqingriqiLabel;

@property (weak, nonatomic) IBOutlet UILabel *yewuyuanLabel;

@property (weak, nonatomic) IBOutlet UILabel *shangjiaLabel;

@property (weak, nonatomic) IBOutlet UIButton *xieyiButton;


@property (nonatomic,strong) WHQROrderModel * detailModel;
@end
