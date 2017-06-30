//
//  LDSubmitOrderViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDSubmitOrderViewController.h"
#import "LDBankCardViewController.h"
#import "LDtest2222ViewController.h"
@interface LDSubmitOrderViewController ()

@end

@implementation LDSubmitOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = LDBackroundColor;
    
    self.navigationItem.title = @"选择银行卡";
    
    [self creatAddCardButton];
}
- (void)creatAddCardButton{
    
    //添加按钮
    UIButton  * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.enabled = NO;
    
    [addButton setBackgroundImage:[UIImage imageNamed:@"shangchuan"] forState:UIControlStateNormal];
    [self.view addSubview:addButton];
    
    [addButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(LDPadding);
        make.top.equalTo(self.view.top).offset(80);
    }];
    
    //添加银行卡
    UILabel * cardLable = [UILabel new];
    [self.view addSubview:cardLable];
    cardLable.text = @"添加银行卡";
    [cardLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addButton);
        make.left.equalTo(addButton.right).offset(LDPadding);
    }];
    
    //imageView
    UIImageView * arrorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回"]];
    [self.view addSubview:arrorImage];
    [arrorImage makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addButton);
        make.right.equalTo(self.view).offset(-LDPadding);
    }];
    
    //添加按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(40);
        make.top.equalTo(self.view.top).offset(80);
    }];
}

/**
 *  跳转控制器
 */
- (void)buttonClick{
    
    LDLogFunc;
    
    LDtest2222ViewController * bankCard = [[LDtest2222ViewController alloc] init];
    
    [self.navigationController pushViewController:bankCard animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
