//
//  LDResponseModel.h
//  HDJFKJ
//
//  Created by apple on 16/3/20.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class resultModel;

@interface LDResponseModel : NSObject

@property(nonatomic,copy)NSString *code;

@property(nonatomic,copy)NSString *message;

@property(nonatomic,strong)resultModel *result;

@end

@interface resultModel : NSObject

@property(nonatomic,copy) NSString *id;

@property(nonatomic,copy) NSString *token;

@end