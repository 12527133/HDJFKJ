//
//  LDBankCodeViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBankCodeViewController.h"

@interface LDBankCodeViewController ()
@property (nonatomic,strong) UIButton * getCodeButton;

@end

@implementation LDBankCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证手机号";
    self.view.backgroundColor = LDBackroundColor;
    
    [self creatSubView];
}

- (void)creatSubView{
    //note
    UILabel * note = [UILabel new];
    [self.view addSubview:note];
    note.font = LD15Font;
    note.alpha = 0.5;
    note.numberOfLines = 0;
    note.text = @"绑定银行卡需要短信确认,验证码已发送志手机:15712951966,请安提示操作.";
    [note makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.top).offset(80);
        make.left.equalTo(self.view.left).offset(LDPadding);
        make.right.equalTo(self.view).offset(-LDPadding);
        
    }];
    
    //line
    UILabel * line1 = [UILabel new];
    [self.view addSubview:line1];
    line1.backgroundColor = LDLineColor;
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(0.5);
        make.top.equalTo(note.bottom).offset(LDPadding);
        
    }];
    
    //验证码
    UITextField * codeText = [UITextField new];
    [self.view addSubview:codeText];
    codeText.backgroundColor = [UIColor whiteColor];
    codeText.placeholder = @"    填写验证码";
    codeText.font = LD15Font;
    [codeText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(LDPadding);
        make.top.equalTo(line1.bottom).offset(LDPadding);
        make.size.equalTo(CGSizeMake(200, 40));
    }];
    
    //重新获取
    UIButton * getCode = [UIButton buttonWithType:UIButtonTypeCustom];
//    getCode.backgroundColor  =[UIColor redColor];
    self.getCodeButton = getCode;
    [self.view addSubview:getCode];
    [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCode setTitle:@"重新获取(59)" forState:UIControlStateSelected];
    
    [getCode addTarget:self action:@selector(getCodeButotnClick) forControlEvents:UIControlEventTouchUpInside];
    [getCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeText.right).offset(LDPadding);
        make.right.equalTo(self.view).offset(-LDPadding);
        make.centerY.equalTo(codeText);
    }];
    
    //line2
    UILabel * line2 = [UILabel new];
    [self.view addSubview:line2];
    line2.backgroundColor = LDLineColor;
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(codeText.bottom).offset(LDPadding);
        make.height.equalTo(0.5);
    }];
    
    //下一步
   UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    nextButton.backgroundColor = [UIColor redColor];
    [nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.bottom).offset(LDPadding);
        make.left.equalTo(self.view).offset(LDPadding);
        make.right.equalTo(self.view).offset(-LDPadding);
        make.height.equalTo(50);
    }];
    
    //文字
    UILabel * nextLable = [UILabel new];
    [self.view addSubview:nextLable];
    nextLable.text = @"下一步";
    [nextLable makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(nextButton);
        
    }];
    
    //收不到验证码
    UIButton * notGetCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:notGetCode];
    [notGetCode addTarget:self action:@selector(notGetCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [notGetCode makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-LDPadding);
        make.top.equalTo(nextButton.bottom).offset(LDPadding);
        make.size.equalTo(CGSizeMake(100, 30));
    }];
    
    //文字
    UILabel * notGetCodeLable = [UILabel new];
    [self.view addSubview:notGetCodeLable];
    notGetCodeLable.text = @"收不到验证码?";
    notGetCodeLable.alpha = 0.5;
    notGetCodeLable.font = LD15Font;
    [notGetCodeLable makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(notGetCode);
    }];
}
- (void)notGetCodeButtonClick{
    LDLogFunc;
}
- (void)nextButtonClick{

    LDLogFunc;
}
/**
 *  获取验证码
 */
- (void)getCodeButotnClick{
    self.getCodeButton.selected = YES;
    LDLogFunc;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
