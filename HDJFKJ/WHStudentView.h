

#import <UIKit/UIKit.h>

@interface WHStudentView : UIView

+ (id)view;

@property (weak, nonatomic) IBOutlet UITextField *schoolName;

@property (weak, nonatomic) IBOutlet UITextField *faculty;

@property (weak, nonatomic) IBOutlet UITextField *schoolSity;

@property (weak, nonatomic) IBOutlet UITextView *schoolDetailTextView;

@property (weak, nonatomic) IBOutlet UIButton *schoolDetailButton;

@property (weak, nonatomic) IBOutlet UITextView *dormitoryTextView;

@property (weak, nonatomic) IBOutlet UIButton *dormitoryButton;

@property (weak, nonatomic) IBOutlet UITextField *money;

@property (weak, nonatomic) IBOutlet UIButton *schoolButton;

@property (weak, nonatomic) IBOutlet UIButton *nextbutton;
@end
