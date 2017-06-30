//
//  LDReviewInforCell.m
//  HDJFKJ
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDReviewInforCell.h"
@interface LDReviewInforCell()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *noInfoLabel;
@end


@implementation LDReviewInforCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.shibieLabel.layer.cornerRadius = 3.0;
    self.shibieLabel.layer.borderWidth=0.5;
    self.shibieLabel.layer.borderColor=[WHColorFromRGB(0x4a90e2) CGColor];
}

- (void)setReviewModel:(LDReviewModel *)reviewModel{
    _reviewModel = reviewModel;
    
    /** 身份证号，姓名都不为空，给控件赋值，隐藏玩笑信息Label  */
    if (_reviewModel.idName != nil && _reviewModel.idNo != nil) {
        /** 姓名*/
        self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",_reviewModel.idName];
        /** 身份证号  */
        self.cardNumLabel.text = [NSString stringWithFormat:@"身份证号：%@",_reviewModel.idNo];
        
        /** 隐藏完善信息Label*/
        self.noInfoLabel.hidden = YES;
    }
    else{
        
        /** 显示完善信息Label*/
        self.noInfoLabel.hidden = NO;
        
//        self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",@""];
//        self.cardNumLabel.text = [NSString stringWithFormat:@"身份证号：%@",@""];
        
    }
    
    
    /** 根据人脸识别标示 判断是否显示人脸识别提示  */
    if ([_reviewModel.faceVerified isEqualToString:@"1"]) {
    
        self.shibieLabel.hidden = NO;
    }
    else{
        self.shibieLabel.hidden = YES;
    }

    
    
    /** 更加是否人脸识别，判断是否完善了基本信息  */
    if ( [_reviewModel.faceVerified isEqualToString:@"1"]){
    
        self.statusLabel.text = @"已完善";
        self.statusLabel.textColor = LDRGBColor(50, 50, 50, 0.5);
        
        
    }
    else{
    
        self.statusLabel.text = @"未完善";
        self.statusLabel.textColor = WHColorFromRGB(0x4279d6);
    
    }
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
