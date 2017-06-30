//
//  LDTextTableViewCell.h
//  HDJFKJ
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDBasicModel;

@interface LDBaseInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *downLine;
@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (nonatomic,strong) LDBasicModel * baseModel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *lable;

@property (weak, nonatomic) IBOutlet UIButton *addressBookButton;


@end
