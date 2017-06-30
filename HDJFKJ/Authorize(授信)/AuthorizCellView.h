

#import <UIKit/UIKit.h>

@interface AuthorizCellView : UIView
+ (id)view;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
