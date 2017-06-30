//
//  LDFirstCell.m
//  OCLDProject
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDFirstCell.h"
#import "LDGoodsDetailModel.h"

@interface LDFirstCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstPay;
@property (weak, nonatomic) IBOutlet UILabel *displayAndDuration;

@end


@implementation LDFirstCell
- (void)setGoodsDetailModel:(LDGoodsDetailModel *)goodsDetailModel{
    
    _goodsDetailModel = goodsDetailModel;
    
    //首付金额
    NSString * payment = @"";
    if ([self.goodsDetailModel.downpayment isEqualToString:@"<null>"] || [self.goodsDetailModel.downpayment isEqualToString:@"(null)"] || [self.goodsDetailModel.downpayment isEqualToString:@""] || self.goodsDetailModel.downpayment == nil || [self.goodsDetailModel.downpayment floatValue] == 0) {
        payment = @"0首付";
    }else{
        payment = [NSString stringWithFormat:@"首付%.2f",[self.goodsDetailModel.downpayment floatValue]];
    }
    
    self.firstPay.text = [NSString stringWithFormat:@"%@",payment];
    
    if (self.AttributeString == nil) {
         self.displayAndDuration.text = @"选择期数";
        self.displayAndDuration.textColor = WHColorFromRGB(0xe84c3d);
    }else{
        self.displayAndDuration.text = self.AttributeString;
        self.displayAndDuration.textColor = WHColorFromRGB(0x323232);
    }
    
   
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
