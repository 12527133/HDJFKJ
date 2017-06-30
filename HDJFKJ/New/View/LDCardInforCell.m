//
//  LDCardInforCell.m
//  HDJFKJ
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDCardInforCell.h"
@interface LDCardInforCell()

@property (weak, nonatomic) IBOutlet UILabel *shenfenLabel;
@property (weak, nonatomic) IBOutlet UILabel *danweiLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *noInfoLabel;

@end
@implementation LDCardInforCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setReviewModel:(LDReviewModel *)reviewModel{
    _reviewModel = reviewModel;
    
    if (reviewModel.company == nil) {
        reviewModel.company = @"";
    }
    
    if ([reviewModel.occupation isEqualToString:@"1"]){
        self.shenfenLabel.text = @"身份：学生";
        
        self.danweiLabel.text = [NSString stringWithFormat:@"学校名称：%@",reviewModel.company];
        
        
    }
    else if ([reviewModel.occupation isEqualToString:@"2"]){
        self.shenfenLabel.text = @"身份：上班族";
        self.danweiLabel.text = [NSString stringWithFormat:@"现单位名称：%@",reviewModel.company];
        
       
    }else if ([reviewModel.occupation isEqualToString:@"3"]) {
        self.shenfenLabel.text = @"身份：创业者";
        self.danweiLabel.text = [NSString stringWithFormat:@"公司名称：%@",reviewModel.company];
        
        
    }
    else{
        self.shenfenLabel.text = @"身份：";
        self.danweiLabel.text = [NSString stringWithFormat:@"现单位名称：%@",@""];
        
        
    }
    
    if ([self.customInfo.workInfo isEqualToString:@"1"]) {
        self.statusLabel.text = @"已完善";
        self.statusLabel.textColor = LDRGBColor(50, 50, 50, 0.5);
    }else{
        self.statusLabel.text = @"未完善";
        self.statusLabel.textColor =WHColorFromRGB(0x4297d6) ;
    }
    
    
    if ([self.shenfenLabel.text isEqualToString:@"身份："] && ([self.danweiLabel.text isEqualToString:@"现单位名称："] || [self.danweiLabel.text isEqualToString:@"公司名称："] || [self.danweiLabel.text isEqualToString:@"学校名称："])) {
        self.noInfoLabel.hidden = NO;
        
    }else{
        self.noInfoLabel.hidden = YES;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
