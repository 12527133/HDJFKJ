//
//  WHMineFirstCell.h
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/26.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHMineFirstCell : UIView
//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//查看个人详情按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *userName;
//信用积分
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
//真实姓名
@property (weak, nonatomic) IBOutlet UILabel *xingmingLabel;
//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIImageView *shimingImageView;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;


+ (id)view;




@end
