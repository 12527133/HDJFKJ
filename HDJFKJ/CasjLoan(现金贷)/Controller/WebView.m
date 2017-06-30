//
//  WebView.m
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/12.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "WebView.h"

@interface WebView ()

@end

@implementation WebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"北银贷款申请书";
    
    [self createURL];
}


-(instancetype)initWithURL:(NSString *)url{
    
    self = [super init];
    if (self) {
        self.mUrl = url;
    }
    return self;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
-(void)createURL{
    
    UIWebView * web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSURL * url = [NSURL URLWithString:self.mUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
