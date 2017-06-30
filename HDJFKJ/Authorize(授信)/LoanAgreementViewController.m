//
//  LoanAgreementViewController.m
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/12.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LoanAgreementViewController.h"

@interface LoanAgreementViewController ()

@end

@implementation LoanAgreementViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createURL];
    
}

-(instancetype)initWithURL:(NSString *)url{

    self = [super init];
    if (self) {
        self.myUrl = url;
    }
    return self;

}


-(void)createURL{

    UIWebView * webView =[[UIWebView alloc]initWithFrame:self.view.bounds];
    NSURL * url = [NSURL URLWithString:self.myUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];

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
