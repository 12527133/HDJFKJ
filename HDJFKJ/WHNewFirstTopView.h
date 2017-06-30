//
//  WHNewFirstTopView.h
//  HDJFKJ
//
//  Created by 石伟浩 on 16/5/4.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHNewFirstTopView : UIView
//扫码button
@property (weak, nonatomic) IBOutlet UIButton *saomaButton;

//现金贷Button
@property (weak, nonatomic) IBOutlet UIButton *cashLoanButton;


+ (id)view;
@end
