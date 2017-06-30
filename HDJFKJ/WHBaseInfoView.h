

#import <UIKit/UIKit.h>

@interface WHBaseInfoView : UIView
//创建View的类方法
+ (id)view;
//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//婚姻
@property (weak, nonatomic) IBOutlet UITextField *maritalTextField;
//选择婚姻按钮
@property (weak, nonatomic) IBOutlet UIButton *maritalButton;

//教育程度
@property (weak, nonatomic) IBOutlet UITextField *educationTextField;
//选择教育程度按钮
@property (weak, nonatomic) IBOutlet UIButton *educationButton;

//身份证
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;

@property (weak, nonatomic) IBOutlet UITextField *juzhuTextField;

@property (weak, nonatomic) IBOutlet UITextField *juzhuDetailTextField;
//住址按钮
@property (weak, nonatomic) IBOutlet UIButton *juzhuButton;
////户籍省市
//@property (weak, nonatomic) IBOutlet UITextField *hujiTextField;
////户籍按钮
//@property (weak, nonatomic) IBOutlet UIButton *hujiButton;
//户籍详细地址
@property (weak, nonatomic) IBOutlet UITextView * hujiDetailTextView;

//邮箱
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

//身份证开始时间
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
//身份证结束时间
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
//下一步按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//人脸识别button
@property (weak, nonatomic) IBOutlet UIButton *shibieButton;

@end
