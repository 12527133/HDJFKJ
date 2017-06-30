

#import <UIKit/UIKit.h>
#import "HDFirstPageDebtInfo.h"
@interface HDFirstPageCheckCell : UITableViewCell

@property (nonatomic, strong) HDFirstPageDebtInfo * debtInfo;
@property (weak, nonatomic) IBOutlet UILabel *repaymentAmtLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *huankuanLabel;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;


@property (weak, nonatomic) IBOutlet UIButton *checkButton;


@property (weak, nonatomic) IBOutlet UIButton *huankuanButton;


@end
