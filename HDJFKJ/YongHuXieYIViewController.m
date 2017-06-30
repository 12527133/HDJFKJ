//
//  YongHuXieYIViewController.m
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/12.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "YongHuXieYIViewController.h"

@interface YongHuXieYIViewController ()

@end

@implementation YongHuXieYIViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)dealloc{

    LDLog(@"销毁用户注册协议控制器");
}
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"用户协议";
    [super viewDidLoad];
    [self createURL];
}

-(instancetype)initWithURL:(NSString *)url{

    self = [super init];
    if (self) {
        self.string = url;
    }
    return self;
}


-(void)createURL{
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - 64)];
    self.url = [NSURL URLWithString:self.string];
    self.request = [NSURLRequest requestWithURL:self.url];
    [webView loadRequest:self.request];
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
