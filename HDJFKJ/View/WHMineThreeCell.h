//
//  WHMineThreeCell.h
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/26.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHMineThreeCell : UIView

//背景图
@property (weak, nonatomic) IBOutlet UIView *firstBackgroundView;

//我的账单按钮
@property (weak, nonatomic) IBOutlet UIButton *myCheckButton;

//“我的账单”Label
@property (weak, nonatomic) IBOutlet UILabel *maCheckLabel;
//"查看账单label"
@property (weak, nonatomic) IBOutlet UILabel *moreCheckLabel;
//“尖角图片”
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;

+ (id)view;
@end
