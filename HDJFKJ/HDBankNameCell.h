

#import <UIKit/UIKit.h>

@interface HDBankNameCell : UITableViewCell

@property (nonatomic, strong) UIImageView * iconImage;

@property (nonatomic, strong) UILabel * bankNameLabel;

- (void)createSubViews;
@end
