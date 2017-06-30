//
//  WHMineThreeOtherCell.m
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "WHMineThreeOtherCell.h"

@implementation WHMineThreeOtherCell

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHMineThreeOtherCell" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
