

#import <UIKit/UIKit.h>
#import "HDFirstPageOrderInfo.h"
@interface HDFirstPageOrderCell : UITableViewCell
@property (nonatomic, strong) HDFirstPageOrderInfo * orderInfo;

@property (weak, nonatomic) IBOutlet UILabel *commodityNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UIButton *orderButton;


@end
