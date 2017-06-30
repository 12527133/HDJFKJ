//
//  WHMineFourCell.h
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/26.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHMineFourCell : UIView
//"我的订单"Label
@property (weak, nonatomic) IBOutlet UILabel *myOrderLabel;
//“尖角图片”
@property (weak, nonatomic) IBOutlet UIImageView *moreImageVoew;
//"查看全部订单Label"
@property (weak, nonatomic) IBOutlet UILabel *moreOrderLabel;
@property (weak, nonatomic) IBOutlet UIButton *allOrderButton;
+ (id)view;
@end
