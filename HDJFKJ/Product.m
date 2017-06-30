//
//  Product.m
//  Demo3_Search_Bar
//
//  Created by tarena on 15/7/27.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "Product.h"

@implementation Product

+(NSArray *)demoData{
    Product *p1 = [[Product alloc]init];
    p1.name = @"iPhone4";
    p1.type = ProductTypeDevice;
    
    Product *p2 = [[Product alloc]init];
    p2.name = @"iPhone5S";
    p2.type = ProductTypeDevice;
    
    Product *p3 = [[Product alloc]init];
    p3.name = @"iPhone6 Plus";
    p3.type = ProductTypeDevice;
    
    Product *p4 = [[Product alloc]init];
    p4.name = @"OS X Yosemite";
    p4.type = ProductTypeSoftware;
    
    Product *p5 = [[Product alloc]init];
    p5.name = @"OS X EI Captain";
    p5.type = ProductTypeSoftware;
    
    Product *p6 = [[Product alloc]init];
    p6.name = @"AirPort Time Capsule";
    p6.type = ProductTypeOther;
    
    return @[p1,p2,p3,p4,p5,p6];
    
}


@end







