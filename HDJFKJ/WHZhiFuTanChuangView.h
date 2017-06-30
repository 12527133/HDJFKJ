

#import <UIKit/UIKit.h>

@interface WHZhiFuTanChuangView : UIView
+ (id)view;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) NSString * orderNo;


@end
