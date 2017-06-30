//
//  WHMineFourCell.m
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/26.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "WHMineFourCell.h"

@implementation WHMineFourCell

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHMineFourCell" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
