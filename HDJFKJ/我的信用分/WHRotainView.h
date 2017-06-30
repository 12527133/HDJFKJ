

#import <UIKit/UIKit.h>

@interface WHRotainView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bangbangtang;
@property (weak, nonatomic) IBOutlet UIView *bbBGView;

@property (weak, nonatomic) IBOutlet UIButton *buzaitishiButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (void)imageRotain2;

+ (id)view;
- (void)imageRotain;
@end
