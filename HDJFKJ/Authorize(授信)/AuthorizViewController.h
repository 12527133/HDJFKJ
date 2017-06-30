//
//  AuthorizViewController.h
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/10.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizViewController : LDBaseUIViewController


//现金贷下单需要的数据
@property (nonatomic, strong) NSMutableDictionary * params;

@property (nonatomic, strong) NSString * fromWhere;

@end
