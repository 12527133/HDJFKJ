//
//  LDNewOrderDetailCell.m
//  HDJFKJ
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDNewOrderDetailCell.h"
#import "LDNewOrderDetailModel.h"

@interface LDNewOrderDetailCell ()
/**
 *  首付金额
 */
@property (weak, nonatomic) IBOutlet UILabel *firstPay;
/**
 *  分期金额
 */
@property (weak, nonatomic) IBOutlet UILabel *stagePay;
/**
 *  分期数
 */
@property (weak, nonatomic) IBOutlet UILabel *duration;
/**
 *  月还款金额
 */
@property (weak, nonatomic) IBOutlet UILabel *monthPay;


@property (weak, nonatomic) IBOutlet UILabel *leftLabel1;

@property (weak, nonatomic) IBOutlet UILabel *leftlabel2;

@end


@implementation LDNewOrderDetailCell
- (void)setOrderDetailModel:(LDNewOrderDetailModel *)orderDetailModel{

    _orderDetailModel = orderDetailModel;
    
   
    
    self.monthPay.text = [NSString stringWithFormat:@"%@(%@)",self.orderDetailModel.bankName,orderDetailModel.cardNo];
    
    
    self.firstPay.text = [NSString stringWithFormat:@"￥%.2fx%@期",[orderDetailModel.periodAmount floatValue],orderDetailModel.duration];
    
    self.stagePay.text = [NSString stringWithFormat:@"￥%.2f",[orderDetailModel.downpayment floatValue]];
    
    
    

}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.leftLabel1.font = [UIFont systemFontOfSize:13*bili];
    
    self.leftlabel2.font = [UIFont systemFontOfSize:13*bili];
    
    
    self.duration.font = [UIFont systemFontOfSize:13*bili];
    
    self.firstPay.font = [UIFont systemFontOfSize:14*bili];
    
    self.stagePay.font = [UIFont systemFontOfSize:14*bili];
    
    self.monthPay.font = [UIFont systemFontOfSize:13*bili];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
