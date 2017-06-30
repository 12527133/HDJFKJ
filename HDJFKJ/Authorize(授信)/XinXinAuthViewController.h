//
//  XinXinAuthViewController.h
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/10.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XueXinBlock)(NSString * string);
@interface XinXinAuthViewController : LDBaseUIViewController


@property(nonatomic,strong)UIWebView * myWebView;

- (instancetype)initWithURL:(NSString *)url successBlk:(void(^)(void))successBlk;
- (instancetype)initWithParam:(NSDictionary *)param successBlk:(void(^)(void))successBlk;

@property (nonatomic, copy) XueXinBlock xuexinBlock;
@end
