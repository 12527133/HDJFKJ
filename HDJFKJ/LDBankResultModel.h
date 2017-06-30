//
//  LDBankResultModel.h
//  HDJFKJ
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDBankResultModel : NSObject
/**
 *  返回码
 */
@property (nonatomic,copy) NSString * code;
/**
 *  返回信息
 */
@property (nonatomic,copy) NSString * message;

@end
@interface LDBankResultModel1 : NSObject
/**
 *  返回码
 */
@property (nonatomic,copy) NSString * bankinfoid;
/**
 *  返回信息
 */
@property (nonatomic,copy) NSString * cardtype;

@end
