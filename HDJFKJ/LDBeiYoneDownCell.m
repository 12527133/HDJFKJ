//
//  LDBeiYoneDownCell.m
//  HDJFKJ
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBeiYoneDownCell.h"

@interface LDBeiYoneDownCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *butCounts;

@property (weak, nonatomic) IBOutlet UILabel *firstPay;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;

@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

//@property (weak, nonatomic) IBOutlet UILabel *bussnessName;

@property (weak, nonatomic) IBOutlet UILabel *monthPay;


@property (weak, nonatomic) IBOutlet UILabel *duration;

@end


@implementation LDBeiYoneDownCell
-(void)setCellModel:(LDBusinessDetailCellModel *)cellModel{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _cellModel = cellModel;
    self.goodsName.text  =cellModel.name;
    self.butCounts.text = [NSString stringWithFormat:@"%@人已购买",cellModel.sale];
    
    self.firstPay.text = [NSString stringWithFormat:@"%@首付",NIL0STR(cellModel.privilege)];
    
    //,cellModel.duration
    self.monthPay.text = [NSString stringWithFormat:@"￥%@",cellModel.periodamount];
    
    self.duration.text = [NSString stringWithFormat:@"%@",cellModel.duration];
    
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.pic] placeholderImage:[UIImage imageNamed:@"商品 1:1"]];

    if ([cellModel.star floatValue] == 3.0) {//评分3
        self.star1.hidden = NO;
        self.star2.hidden = NO;
        self.star3.hidden = NO;
        self.star4.hidden = YES;
        self.star5.hidden = YES;
    }
    if ([cellModel.star floatValue] > 3.0 && [cellModel.star floatValue] < 4.0 ){//评分3.5
        self.star1.hidden = NO;
        self.star2.hidden = NO;
        self.star3.hidden = NO;

        self.star4.hidden = NO;
        self.star5.hidden = YES;
    }
    if ([cellModel.star floatValue] == 4.0) {//评分4.0
        self.star1.hidden = NO;
        self.star2.hidden = NO;
        self.star3.hidden = NO;

        self.star4.hidden = NO;
        self.star5.hidden = YES;
    }
    if ([cellModel.star floatValue] > 4.0 && [cellModel.star floatValue] < 5.0){//评分4.5
        self.star1.hidden = NO;
        self.star2.hidden = NO;
        self.star3.hidden = NO;

        self.star4.hidden = NO;
        self.star5.hidden = NO;
    }
    if ([cellModel.star floatValue] == 5.0){//评分5
        self.star1.hidden = NO;
        self.star2.hidden = NO;
        self.star3.hidden = NO;

        self.star4.hidden = NO;
        self.star5.hidden = NO;
    }


}
- (void)setHeaderModel:(LDBusinessDetailHeaderModel *)headerModel{
//    self.bussnessName.text = headerModel.name;

}

- (void)awakeFromNib {

    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setFrame:(CGRect)frame
{


    
    [super setFrame:frame];
}

@end
