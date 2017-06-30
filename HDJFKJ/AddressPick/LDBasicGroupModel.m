//
//  LDGroupModel.m
//  HDJFKJ
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBasicGroupModel.h"

@implementation LDBasicGroupModel

- (NSMutableArray *)LDBasicGroupModel{
    if (!_BasicModel) {
        
        _BasicModel = [[NSMutableArray alloc] init];
    }
    return  _BasicModel;

}
@end
