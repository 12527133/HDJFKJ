//
//  LDReviewContactCell.m
//  HDJFKJ
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDReviewContactCell.h"

@interface LDReviewContactCell()

@property (weak, nonatomic) IBOutlet UILabel *relation1;

@property (weak, nonatomic) IBOutlet UILabel *relation2;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (weak, nonatomic) IBOutlet UILabel *noInfoLabel;

@end
@implementation LDReviewContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setReviewModel:(LDReviewModel *)reviewModel{

    _reviewModel = reviewModel;
    
    if (![self.customInfo.contactInfo isEqualToString:@"1"]) {
        self.statusLabel.text = @"未完善";
        self.statusLabel.textColor = WHColorFromRGB(0x4279d6);
    }
    else{
        self.statusLabel.text = @"已完善";
        self.statusLabel.textColor = LDRGBColor(50, 50, 50, 0.5);
    }
    
    
   
    
    for (LDReviewOtherModel * reviewOther in _reviewModel.hdCustContactsList) {
        if ([reviewOther.type isEqualToString:@"1"]) {
            self.relation1.text = [NSString stringWithFormat:@"第一联系人：%@",reviewOther.name];
        }
        if ([reviewOther.type isEqualToString:@"2"]) {
            self.relation2.text = [NSString stringWithFormat:@"第二联系人：%@",reviewOther.name];
        }
    }
    
    if (_reviewModel.hdCustContactsList.count > 1) {
        self.noInfoLabel.hidden = YES;
    }
    else{
        self.noInfoLabel.hidden = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
