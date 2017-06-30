//
//  XinXinAuthViewController.m
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/10.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "XinXinAuthViewController.h"

#define MARKURL  @"http://123.56.233.192/gshpay/"
@interface XinXinAuthViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) NSMutableURLRequest *request;
@property (nonatomic,copy) void (^successBlk)(void);    //授权成功回调

@end


@implementation XinXinAuthViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    
    self.title= @"学信网授权";

    [super viewDidLoad];
    //[self beginLoadRequest];
    
    [self createGobackHomePageButton];
}

/**
 * 创建导航栏右侧关闭按钮
 **/
- (void)createGobackHomePageButton{
    
    
    UIButton * backPage = [[UIButton alloc]init];
    
    backPage.frame =CGRectMake(0, 0, 30, 30);
    
    [backPage setImage:[UIImage imageNamed:@"X_guanbi"] forState:UIControlStateNormal];
    
    [backPage addTarget:self action:@selector(ClickdismissButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backPage];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem, nil];
    
}
/**
 * 关闭控制器
 **/
- (void)ClickdismissButton:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (instancetype)initWithURL:(NSString *)url successBlk:(void (^)(void))successBlk
{
    self = [super init];
    if (self) {
        //1.初始化
        self.successBlk = successBlk;
        
        //2.添加网页
        _myWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_myWebView];
        [_myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _myWebView.delegate = self;
        //3.开始加载请求
        NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        _request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:50];
        
        [self beginLoadRequest];
    }
    return self;
}

- (void)beginLoadRequest
{
    [_myWebView loadRequest:_request];
}

- (void)reloadRequest
{
    [_myWebView stopLoading];
    [_myWebView loadRequest:_request];
}


- (instancetype)initWithParam:(NSDictionary *)param successBlk:(void (^)(void))successBlk
{
    NSMutableString *pathStr = [[NSMutableString alloc] init];
    //http://auth.wecash.net:8611/credit_learn.html?/wap_v4/credit_limit.html?redirect=1?
    [pathStr appendString:@"http://auth.wecash.net:8611/credit_learn.html?"];
    [param enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (key!= nil && obj!=nil) {
            
            NSString *currPath = nil;
            if ([obj isKindOfClass:[NSString class]]) {
                currPath = [NSString stringWithFormat:@"&%@=%@",key,obj];
            } else if ([obj isKindOfClass:[NSNumber class]]) {
                currPath = [NSString stringWithFormat:@"&%@=%zi",key,[(NSNumber *)obj integerValue]];
            }
            
            if (currPath) {
                [pathStr appendString:currPath];
            }
            
        }
    }];
    
    return [self initWithURL:pathStr successBlk:successBlk];
}



#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //    XueXinAuthViewController * __weak weakSelf = self;
    if ([request.URL.path rangeOfString:@"auth_suc"].length > 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //第二次请求,请求接口
        
        [MBProgressHUD showMessage:@"正在授权"];
        NSString *url = [KBaseUrl stringByAppendingString:@"/userInfo/authByType"];
        
        NSDictionary *param = @{
                                @"userId":[LDUserInformation sharedInstance].UserId,
                                @"customerId":[LDUserInformation sharedInstance].UserId,
                                @"kind":@"0",
                                @"source":@"27569"
                                };
        NSLog(@"-----%@",param);
        
        [[LDNetworkTools sharedTools] request:POST url:url params:param callback:^(id response, NSError *error) {
            if (error != nil) {
                
                /** 1.请求错误信息  */
                NSLog(@"%@",error);
                
                /** 2.请求错误提示  */
                [MBProgressHUD showError:@"网络错误"];
            }else{
                
                
                /** 3.解析返回数据 */
                LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
                
                /** 4.code == 200请求成功 */
                if ([backInfo.errcode isEqualToString:@"200"]) {
                    [MBProgressHUD hideHUD];
                    
                    _xuexinBlock(@"1");
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                }else{
                    
                    /** 4.请求异常提示 */
                   
                    [MBProgressHUD showError:backInfo.msg];
                    
                }
                LDLog(@"%@",response);
            }
        }];
        
        return NO;
    }
    
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (error.code != NSURLErrorCancelled) {
        [MBProgressHUD showError:@"出错了，请稍后再试"];
    }
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
