//
//  Product.h
//  Demo3_Search_Bar
//
//  Created by tarena on 15/7/27.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义一个枚举类型，来描述产品的类别
typedef NS_ENUM(NSInteger, ProductType){
    ProductTypeDevice,
    ProductTypeSoftware,
    ProductTypeOther
};

@interface Product : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic)ProductType type;

+(NSArray *)demoData;

@end








