//
//  LDOtherInforCell.m
//  HDJFKJ
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDOtherInforCell.h"
@interface LDOtherInforCell ()

@property (weak, nonatomic) IBOutlet UILabel *yunyingshangLabel;
@property (weak, nonatomic) IBOutlet UILabel *xuexinwangLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end
@implementation LDOtherInforCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setReviewModel:(LDReviewModel *)reviewModel{
    _reviewModel = reviewModel;
    
    if ([_reviewModel.operatorAuthorizeStatus isEqualToString:@"1"]) {
        
        self.yunyingshangLabel.text = @"运营商：已授信";
    }
    else {
        self.yunyingshangLabel.text = @"运营商：未授信";
    
    }

    if ([_reviewModel.learningAuthorizeStatus isEqualToString:@"1"]) {
        
        self.xuexinwangLabel.text = @"学信网：已授信";
    }
    else {
        self.xuexinwangLabel.text = @"学信网：未授信";
        
    }
    
    if ([_reviewModel.learningAuthorizeStatus isEqualToString:@"1"] && [_reviewModel.operatorAuthorizeStatus isEqualToString:@"1"] && [_reviewModel.taobaoAuthorizeStatus isEqualToString:@"1"]){
    
        self.statusLabel.text = @"已完善";
        self.statusLabel.textColor = LDRGBColor(50, 50, 50, 0.5);
    }
    else{
    
        self.statusLabel.text = @"未完善";
        self.statusLabel.textColor =WHColorFromRGB(0x4279d6) ;
    }
    
    //0表示不需要授信，1表示需要授信
    if ([self.force.authFlag isEqualToString:@"0"]) {
    
        self.titleLable.text = @"授权信息(非必填)";
    }else{
    
        self.titleLable.text = @"授权信息(运营商必填)";
    }
    
    
}
















- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
