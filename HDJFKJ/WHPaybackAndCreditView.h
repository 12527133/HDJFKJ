//
//  WHPaybackAndCreditView.h
//  HDJFKJ
//
//  Created by 石伟浩 on 16/6/15.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHPaybackAndCreditView : UIView
+ (id)view;
//还款提示Label
@property (weak, nonatomic) IBOutlet UILabel *paybackLabel;
//去登录label
@property (weak, nonatomic) IBOutlet UILabel *goLoginLabel;
//视图上按钮
@property (weak, nonatomic) IBOutlet UIButton *paybackButton;
@end
