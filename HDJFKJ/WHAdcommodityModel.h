//
//  WHAdcommodityModel.h
//  HDJFKJ
//
//  Created by 石伟浩 on 16/3/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHAdcommodityModel : NSObject

//序号
@property (nonatomic, assign) NSInteger  sn;
//商品id
@property (nonatomic, strong) NSString * ids;
//商品图片url
@property (nonatomic, strong) NSString * pic;



+ (instancetype)paresAdcommodityWithDictionary:(NSDictionary *)dict;









@end
