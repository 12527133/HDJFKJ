//
//  WHMineThreeCell.m
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/26.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "WHMineThreeCell.h"

@implementation WHMineThreeCell

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHMineThreeCell" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
