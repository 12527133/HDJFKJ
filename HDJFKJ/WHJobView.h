

#import <UIKit/UIKit.h>

@interface WHJobView : UIView
+ (id)view;
//公司名称
@property (weak, nonatomic) IBOutlet UITextField *companyName;

//职业
@property (weak, nonatomic) IBOutlet UITextField *job;
//选择职业按钮
@property (weak, nonatomic) IBOutlet UIButton *jobButton;
//单位规模
@property (weak, nonatomic) IBOutlet UITextField *companySize;
//单位规模按钮
@property (weak, nonatomic) IBOutlet UIButton *companySizeButton;
//现单位工作年限
@property (weak, nonatomic) IBOutlet UITextField *nowYear;
//现单位工作年限选择按钮
@property (weak, nonatomic) IBOutlet UIButton *nowYearButton;
//总工作年年限
@property (weak, nonatomic) IBOutlet UITextField *sumYearNum;
//总工作年限选择按钮
@property (weak, nonatomic) IBOutlet UIButton *sumYearNumButton;
//职务
@property (weak, nonatomic) IBOutlet UITextField *post;
//职务选择按钮
@property (weak, nonatomic) IBOutlet UIButton *postButton;
//单位地址
@property (weak, nonatomic) IBOutlet UITextField *companyPlace;
//单位地址选择按钮
@property (weak, nonatomic) IBOutlet UIButton *companyPlaceButton;
//单位详细地址
@property (weak, nonatomic) IBOutlet UITextView *companyDetailPlace;
//单位详细地址按钮
@property (weak, nonatomic) IBOutlet UIButton *companyDetailPlaceButton;
//单位电话区号
@property (weak, nonatomic) IBOutlet UITextField *companyQuHao;
//单位电话
@property (weak, nonatomic) IBOutlet UITextField *companyPhone;
//下一步按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
