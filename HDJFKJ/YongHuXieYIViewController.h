//
//  YongHuXieYIViewController.h
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/12.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YongHuXieYIViewController : LDBaseUIViewController
@property(nonatomic,strong)NSString * string;
@property(nonatomic,strong)NSURL * url;
@property(nonatomic,strong)NSURLRequest * request;




-(instancetype)initWithURL:(NSString *)url;

@end
