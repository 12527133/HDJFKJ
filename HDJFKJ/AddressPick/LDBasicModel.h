//
//  LDBasicModel.h
//  HDJFKJ
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDBasicModel : NSObject
@property (nonatomic,copy) NSString * lableText;
@property (nonatomic,copy) NSString * textFieldPlaceholder;
@property (nonatomic,copy) NSString * keyboardType;
@property (nonatomic,copy) NSString * textField;
+ (instancetype)LDBasicModelWiDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
