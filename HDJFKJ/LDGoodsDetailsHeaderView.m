//
//  LDGoodsDetailsHeaderView.m
//  HDJFKJ
//
//  Created by apple on 16/3/24.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDGoodsDetailsHeaderView.h"

@implementation LDGoodsDetailsHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self = [[[NSBundle mainBundle]loadNibNamed:@"LDGoodsDetailsHeaderView" owner:nil options:nil]lastObject];
    
    return self;
}
@end
