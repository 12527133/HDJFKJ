

#import <UIKit/UIKit.h>

@interface HDChooseBankView : UIView
+ (id)view;

@property (weak, nonatomic) IBOutlet UIButton *closeBankButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
