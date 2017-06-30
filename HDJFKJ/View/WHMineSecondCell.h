//
//  WHMineSecondCell.h
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/26.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHMineSecondCell : UIView

//我的银行卡
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
//我的信用分
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
//我的银行卡背景图
@property (weak, nonatomic) IBOutlet UIView *leftBackgroundView;
//我的信用分背景图
@property (weak, nonatomic) IBOutlet UIView *rightBackgroundView;

+ (id)view;
@end
