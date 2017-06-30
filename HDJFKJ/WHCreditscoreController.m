//
//  WHCreditscoreController.m
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "WHCreditscoreController.h"
#import "WHUserLoginModel.h"
#import "WHXinYongFenAgreementController.h"
@interface WHCreditscoreController ()
@property (nonatomic, strong) WHUserLoginModel * user;

@end

@implementation WHCreditscoreController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.user = [WHUserLoginModel createuserInfoModel];
    self.scoreLabel.text =[NSString stringWithFormat:@"%ld",(long)self.user.creditscore] ;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的信用分";
    
    
}

- (IBAction)clickMoreScoreButton:(UIButton *)sender {
    
    WHXinYongFenAgreementController * webView = [[WHXinYongFenAgreementController alloc]initWithURL:@"http://123.56.233.192/appagree/creditScore.html"];
    [self.navigationController pushViewController:webView animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
