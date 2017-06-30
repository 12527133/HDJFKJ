

#import <UIKit/UIKit.h>
#import "HDFirstPageModel.h"
@interface HDFirstPageScoreCell : UITableViewCell
@property (nonatomic, strong) HDFirstPageModel * firstPageModel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UIButton *scoreButton;

@end
