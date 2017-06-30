//
//  LDBusinessAndPlaceView.m
//  HDJFKJ
//
//  Created by apple on 16/3/25.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBusinessAndPlaceView.h"

@implementation LDBusinessAndPlaceView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self = [[[NSBundle mainBundle]loadNibNamed:@"LDBusinessAndPlaceView" owner:nil options:nil]lastObject];
    
    return self;
}

@end
