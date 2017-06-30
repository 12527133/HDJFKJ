//
//  LDBankCardViewCell.m
//  HDJFKJ
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBankCardViewCell.h"

@implementation LDBankCardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    //self = [super initWithFrame:frame];
    
    self = [[[NSBundle mainBundle]loadNibNamed:@"LDBankCardViewCell" owner:nil options:nil]lastObject];
    
    
    return self;
}

- (void)setLabelFont{
    
    self.bankName.font = [UIFont systemFontOfSize:15*bili];
    self.bankType.font = [UIFont systemFontOfSize:13*bili];
    self.xinghaoLabel.font = [UIFont systemFontOfSize:22*bili];
    self.bankNumber.font = [UIFont systemFontOfSize:25*bili];

    
    
    
    
    
    
}

@end
