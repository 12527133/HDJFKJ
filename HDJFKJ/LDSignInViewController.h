//
//  LDSignInViewController.h
//  HDJFKJ
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LDSignInViewController : LDBaseUIViewController

//跳转标识，从设置到登录页，设置为41，点返回到首页
@property (nonatomic, assign) NSInteger indexFlag;
@property (nonatomic,strong ) UITextField * pasWrod;
@property (nonatomic,copy )NSString * number;
@property (nonatomic,copy )NSString * fromWhere;

@end
