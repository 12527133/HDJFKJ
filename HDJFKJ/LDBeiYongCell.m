//
//  LDBeiYongCell.m
//  HDJFKJ
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBeiYongCell.h"
#import "SDCycleScrollView.h"

@interface LDBeiYongCell ()<SDCycleScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *downView;

@property (weak, nonatomic) IBOutlet UILabel *businessName;
@property (weak, nonatomic) IBOutlet UIImageView *star;

@property (weak, nonatomic) IBOutlet UILabel *businessPlace;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;

@property (weak, nonatomic) IBOutlet UIImageView *star3;

@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;




@end


@implementation LDBeiYongCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
//    self.headerImage.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
}

-(void)setHeaderModel:(LDBusinessDetailHeaderModel *)headerModel{
    
    if (_headerModel != headerModel) {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _headerModel = headerModel;
    self.businessName.text = headerModel.name;
    self.businessPlace.text = headerModel.address;
    self.phoneNumber.text = [NSString stringWithFormat:@"电话: %@",headerModel.phone];
        
        if ([headerModel.star floatValue] == 3.0) {//评分3
            self.star1.hidden = NO;
            self.star2.hidden = NO;
            self.star3.hidden = NO;
            self.star4.hidden = YES;
            self.star5.hidden = YES;
        }
        if ([headerModel.star floatValue] > 3.0 && [headerModel.star floatValue] < 4.0 ){//评分3.5
            self.star1.hidden = NO;
            self.star2.hidden = NO;
            self.star3.hidden = NO;
            
            self.star4.hidden = NO;
            self.star5.hidden = YES;
        }
        if ([headerModel.star floatValue] == 4.0) {//评分4.0
            self.star1.hidden = NO;
            self.star2.hidden = NO;
            self.star3.hidden = NO;
            
            self.star4.hidden = NO;
            self.star5.hidden = YES;
        }
        if ([headerModel.star floatValue] > 4.0 && [headerModel.star floatValue] < 5.0){//评分4.5
            self.star1.hidden = NO;
            self.star2.hidden = NO;
            self.star3.hidden = NO;
            
            self.star4.hidden = NO;
            self.star5.hidden = NO;
        }
        if ([headerModel.star floatValue] == 5.0){//评分5
            self.star1.hidden = NO;
            self.star2.hidden = NO;
            self.star3.hidden = NO;
            
            self.star4.hidden = NO;
            self.star5.hidden = NO;
        }
 
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)setFrame:(CGRect)frame{
//    
//
//
//   
//    
//}
@end
