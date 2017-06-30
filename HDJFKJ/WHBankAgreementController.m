

#import "WHBankAgreementController.h"

@interface WHBankAgreementController ()

@end

@implementation WHBankAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"银行卡用户服务协议";
    
    
    [self createURL];
}
-(instancetype)initWithURL:(NSString *)url{
    
    self = [super init];
    if (self) {
        self.mUrl = url;
    }
    return self;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
-(void)createURL{
    
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - 64)];
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
