//
//  WHNewFirstMiddleView.m
//  HDJFKJ
//
//  Created by 石伟浩 on 16/5/4.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "WHNewFirstMiddleView.h"

@implementation WHNewFirstMiddleView


+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHNewFirstMiddleView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}
@end
