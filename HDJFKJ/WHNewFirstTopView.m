//
//  WHNewFirstTopView.m
//  HDJFKJ
//
//  Created by 石伟浩 on 16/5/4.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "WHNewFirstTopView.h"

@implementation WHNewFirstTopView


+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHNewFirstTopView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}
@end
