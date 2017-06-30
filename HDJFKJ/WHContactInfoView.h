

#import <UIKit/UIKit.h>

@interface WHContactInfoView : UIView


@property (strong, nonatomic) UIView * topView;
@property (nonatomic, strong) UILabel * topLabel;


@property (nonatomic, strong) UILabel * titleLabel1;
@property (nonatomic, strong) UIView * relatioView1;

@property (strong, nonatomic)  UITextField *contactName1;
@property (strong, nonatomic)  UITextField *relationship1;
@property (strong, nonatomic)  UITextField *phoneNumber1;
@property (strong, nonatomic)  UIButton *contactButton1;
@property (strong, nonatomic)  UIButton *relationButton1;
@property (strong, nonatomic)  UIView * noRelationView1;
@property (strong, nonatomic)  UIButton * noRelationButton1;


@property (nonatomic, strong) UILabel * titleLabel2;
@property (nonatomic, strong) UIView * relatioView2;

@property (strong, nonatomic)  UITextField *contactName2;
@property (strong, nonatomic)  UITextField *relationship2;
@property (strong, nonatomic)  UITextField *phoneNumber2;
@property (strong, nonatomic)  UIButton *contactButton2;
@property (strong, nonatomic)  UIButton *relationButton2;
@property (strong, nonatomic)  UIView * noRelationView2;
@property (strong, nonatomic)  UIButton * noRelationButton2;

@property (strong, nonatomic)  UIButton *nextButton;


- (void)createSubViews;






















@end
