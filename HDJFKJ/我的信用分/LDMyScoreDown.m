//
//  LDMyScoreDown.m
//  HDJFKJ
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDMyScoreDown.h"
#import "LDMySoreModel.h"

@interface LDMyScoreDown ()



@end



@implementation LDMyScoreDown

- (void)setSoreModel:(LDMySoreModel *)SoreModel{

    _SoreModel = SoreModel;
    
    
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
