

#import <UIKit/UIKit.h>

@interface WHEntrepreneursView : UIView
+ (id)view;

@property (weak, nonatomic) IBOutlet UITextField *companyName;

@property (weak, nonatomic) IBOutlet UITextField *companyPhone;

@property (weak, nonatomic) IBOutlet UITextField *companyQuHao;

@property (weak, nonatomic) IBOutlet UITextField *companySize;

@property (weak, nonatomic) IBOutlet UITextField *companyPlace;

@property (weak, nonatomic) IBOutlet UITextField *sumYear;

@property (weak, nonatomic) IBOutlet UITextView *conmanyDetailPlace;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *sumYearButton;

@property (weak, nonatomic) IBOutlet UIButton *comanySizeButton;

@property (weak, nonatomic) IBOutlet UIButton *companyDetailButton;

@property (weak, nonatomic) IBOutlet UIButton *companyPlaceButton;


@end
