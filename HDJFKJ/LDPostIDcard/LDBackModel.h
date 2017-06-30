//
//  LDBackModel.h
//  HDJFKJ
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDBackModel : NSObject
/**
 *  反面
 */
@property(nonatomic,copy) NSString * idCardBackImg;
/**
 *  手持
 */
@property(nonatomic,copy) NSString * idCardFaceImg;
/**
 *  正面
 */
@property(nonatomic,copy) NSString * idCardFrontImg;

@end
