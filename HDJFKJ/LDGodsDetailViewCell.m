//
//  LDGodsDetailViewCell.m
//  HDJFKJ
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDGodsDetailViewCell.h"

@implementation LDGodsDetailViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self = [[[NSBundle mainBundle]loadNibNamed:@"LDGodsDetailViewCell" owner:nil options:nil]lastObject];
    
    return self;
}


@end
