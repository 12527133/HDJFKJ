//
//  LDReviewModel.m
//  HDJFKJ
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDReviewModel.h"
#import "HDPictureModel.h"
@implementation LDReviewModel
- (NSArray *)hdCustContactsList{

    if (!_hdCustContactsList) {
        _hdCustContactsList = [NSArray array];
    }
    return _hdCustContactsList;
}
- (void)setPicList:(NSMutableArray *)picList{

    NSMutableArray * picArr = [[NSMutableArray alloc]init];
    if (picList.count > 0) {
        for (NSString * picStr in picList) {
            
            HDPictureModel * picModel = [[HDPictureModel alloc]init];
            picModel.picUrl = picStr;
            [picArr addObject:picModel];
        }
        
    }
    
    _picList = picArr;
}

+ (NSDictionary *)mj_objectClassInArray{

    return @{
            
             
             @"hdCustContactsList":@"LDReviewOtherModel"
             
             };

}
@end


@implementation LDReviewContactModel


@end


@implementation LDReviewOtherModel


@end
