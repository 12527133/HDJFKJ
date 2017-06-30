//
//  LDGoodsIDAndZhuanAnId.m
//  HDJFKJ
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDGoodsIDAndZhuanAnId.h"
#import <objc/runtime.h>

@implementation LDGoodsIDAndZhuanAnId

+(instancetype)sharedInstance{
    
    static LDGoodsIDAndZhuanAnId *instance;
    
    static dispatch_once_t oneceToken;
    
    dispatch_once(&oneceToken, ^{
    
        instance = [[LDGoodsIDAndZhuanAnId alloc]init];
        
    });
    
    return instance;
}

- (instancetype)initWithGoodsID:(NSString *)GoodsID andZhuanAnId:(NSString *)ZhuanAnId andCommodityno:(NSString *)commodityno andCategory:(NSString *)category andBusinessname:(NSString *)businessname andName:(NSString *)name andCommodityprice:(NSString *)commodityprice{
    
    if (self = [super init]) {
        
//        _goodID = GoodsID;
//        _zhuanAnID = ZhuanAnId;
//        _commodityno = commodityno;
//        _category = category;
//        _businessname = businessname;
//        _name = name;
//        _commodityprice = commodityprice;
    }
    return self;
    
}

//+ (instancetype)LDGoodsIDAndZhuanAnIdGoodsID:(NSString *)goodsID andZhuanAnId:(NSString *)ZhuanAnId andCommodityno:(NSString *)commodityno andCategory:(NSString *)category{
//    
//    return [[self alloc] initWithGoodsID:goodsID andZhuanAnId:ZhuanAnId andCommodityno:commodityno andCategory:category];
//    
//}


-(void)removeData{

    
    NSArray *array = [self getProperty:[self class]];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSString *name = obj;
        
        const char *name1 = [name UTF8String];
        
        Ivar ivar =  class_getInstanceVariable(self.class, name1);
        
        ivar = nil;
        
    }];
    
}
+(void)removeData{
    [[self sharedInstance] removeData];
}
-(NSArray *)getProperty:(Class)cls{

    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    
    return mArray.copy;
    
    

}

@end
