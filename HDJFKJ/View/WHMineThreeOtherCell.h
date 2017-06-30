//
//  WHMineThreeOtherCell.h
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHMineThreeOtherCell : UIView
/**
 * 1. 自上至下背景试图
 *
 **/
@property (weak, nonatomic) IBOutlet UIView *secondBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *threeBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *fourBackgroundVIew;

//7天待还账单按钮
@property (weak, nonatomic) IBOutlet UIButton *weekCheckButton;

//30天待还账单
@property (weak, nonatomic) IBOutlet UIButton *monthCheckButton;

//全部待还账单按钮
@property (weak, nonatomic) IBOutlet UIButton *allCheckButton;


//七天代还款
@property (weak, nonatomic) IBOutlet UILabel *weekCheckLabel;
//30天代还款
@property (weak, nonatomic) IBOutlet UILabel *monthCheckLabel;
//全部代还款
@property (weak, nonatomic) IBOutlet UILabel *allCheckLabel;


+ (id)view;


@end
