//
//  UserInfo.h
//  HDJFKJ
//
//  Created by apple on 16/3/6.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+(instancetype)sharedInstance;

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *sex;

@end
