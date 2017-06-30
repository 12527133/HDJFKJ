

#import <UIKit/UIKit.h>
typedef void(^ComplationBlock)(NSString * password);
@interface WHPasswordView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * textField;

@property (nonatomic, strong) UIView * passwordView;

@property (nonatomic, strong) NSMutableArray * pointArray;

@property (nonatomic, strong) UIButton * button;

@property (nonatomic, copy) ComplationBlock complationBlock;

@end
