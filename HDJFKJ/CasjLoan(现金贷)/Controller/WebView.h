//
//  WebView.h
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/12.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebView : LDBaseUIViewController

@property(nonatomic,copy)NSString * mUrl;
@property(nonatomic,strong)NSURLRequest * request;
@property(nonatomic,strong)UIWebView * myWebView;


-(instancetype)initWithURL:(NSString *)url;

@end
