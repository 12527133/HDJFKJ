//
//  LDBottomTaoBaoCell.m
//  OCLDProject
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBottomTaoBaoCell.h"

#import "LDGoodsDetailModel.h"


@interface LDBottomTaoBaoCell ()
@property (weak, nonatomic) IBOutlet UILabel *bussniessName;
@property (weak, nonatomic) IBOutlet UILabel *bussniesPlace;
@property (weak, nonatomic) IBOutlet UILabel *bussnissPhone;

@end



@implementation LDBottomTaoBaoCell



- (void)setGoodsDetailModel:(LDGoodsDetailModel *)goodsDetailModel{
    
    _goodsDetailModel = goodsDetailModel;
    self.bussniessName.text = [NSString stringWithFormat:@"商家名称: %@",goodsDetailModel.businessname];
    
    self.bussniesPlace.text = [NSString stringWithFormat:@"商家地址: %@",goodsDetailModel.address];
    
    self.bussnissPhone.text = @"暂无商家电话";
    
    //self.bussnissPhone.text = [NSString stringWithFormat:@"商家电话: %@",@"110"];

    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.callPhoneButton.layer.cornerRadius = 5.0;
    self.callPhoneButton.layer.borderColor = [WHColorFromRGB(0x4276d6) CGColor];
    self.callPhoneButton.layer.borderWidth = 1.0;
    
}
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
