//
//  LoanAgreementViewController.h
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/12.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanAgreementViewController : LDBaseUIViewController

@property(nonatomic,copy)NSString * myUrl;
@property(nonatomic,strong)NSURLRequest * request;
@property(nonatomic,strong)UIWebView * WebView;

-(instancetype)initWithURL:(NSString *)url;


@end
