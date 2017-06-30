//
//  LDBusinessDetailsHeaderView.m
//  HDJFKJ
//
//  Created by apple on 16/3/22.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBusinessDetailsHeaderView.h"

@implementation LDBusinessDetailsHeaderView

-(instancetype)initWithFrame:(CGRect)frame{

   self = [super initWithFrame:frame];

    self = [[[NSBundle mainBundle]loadNibNamed:@"LDBusinessDetailsHeaderView" owner:nil options:nil]lastObject];
    
    return self;
}

@end
