

#import "HDBaseInfoNextVC.h"
#import <JavaScriptCore/JavaScriptCore.h>


@protocol TestJSExport <JSExport>
JSExportAs
(calculateForJS  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)handleFactorialCalculateWithNumber:(NSNumber *)number
 );
- (void)pushViewController:(NSString *)view title:(NSString *)title;
@end



@interface HDBaseInfoNextVC ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) JSContext *context;
@end

@implementation HDBaseInfoNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /** 清缓存 */
    [self cleanCacheAndCookie];
    
    NSString * string =self.userName;
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * urlString = [NSString stringWithFormat:@"%@?mobile=%@&userName=%@&idCode=%@&token=%@",self.accessToken.url,[LDUserInformation sharedInstance].phoneNumber,string,self.userNo,self.accessToken.nhAccessToken];
    
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - 64)];
    self.webView = webView;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.paginationMode = UIWebPaginationModeUnpaginated;
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    [self createLeftNavButton];
}

//3.创建导航栏左侧按钮
- (void)createLeftNavButton{
    
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30 , 40)];
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(clickNavLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftItem, nil];
    
}
- (void)clickNavLeftButton:(UIButton *)sender{
    
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/** 清缓存 */
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{


}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    //把出错信息打出来
    NSLog(@"webview didFailLoadWithError %@ , and err is %@",webView.debugDescription, error.debugDescription);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    NSLog(@"request.URL.path === %@",request.URL.path);
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 以 html title 设置 导航栏 title
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    
    
    // 禁用 页面元素选择
    //[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用 长按弹出ActionSheet
   // [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    // Undocumented access to UIWebView's JSContext
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    // 打印异常
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"exceptionValue === %@", exceptionValue);
    };
    
    // 以 JSExport 协议关联 native 的方法
    self.context[@"android"] = self;
    
    // 以 block 形式关联 JavaScript function
    self.context[@"log"] =
    ^(NSString *str)
    {
        NSLog(@"%@", str);
    };
    
    // 以 block 形式关联 JavaScript function
    self.context[@"alert"] =
    ^(NSString *str)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"msg from js" message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    };
    
    __block typeof(self) weakSelf = self;
    self.context[@"addSubView"] =
    ^(NSString *viewname)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 500, 300, 100)];
        view.backgroundColor = [UIColor redColor];
        UISwitch *sw = [[UISwitch alloc]init];
        [view addSubview:sw];
        [weakSelf.view addSubview:view];
    };
    //多参数
    self.context[@"mutiParams"] =
    ^(NSString *a,NSString *b,NSString *c)
    {
        NSLog(@"%@ %@ %@",a,b,c);
    };
    
    
    self.context[@"_close"] =
    ^(NSString * success){
        NSLog(@"android。%@",success);
        
        if ([success isEqualToString:@"undefined"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            
            
        }
    };
}

- (void)success{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

#pragma mark - JSExport Methods

- (void)handleFactorialCalculateWithNumber:(NSNumber *)number
{
    NSLog(@"JSnumber === %@", number);
    
    NSNumber *result = [self calculateFactorialOfNumber:number];
    
    NSLog(@"%@", result);
    
    [self.context[@"showResult"] callWithArguments:@[result]];
}



#pragma mark - Factorial Method
- (NSNumber *)calculateFactorialOfNumber:(NSNumber *)number
{
    NSInteger i = [number integerValue];
    if (i < 0)
    {
        return [NSNumber numberWithInteger:0];
    }
    if (i == 0)
    {
        return [NSNumber numberWithInteger:1];
    }
    
    NSInteger r = (i * [(NSNumber *)[self calculateFactorialOfNumber:[NSNumber numberWithInteger:(i - 1)]] integerValue]);
    
    return [NSNumber numberWithInteger:r];
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
