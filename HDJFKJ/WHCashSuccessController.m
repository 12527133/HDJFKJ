

#import "WHCashSuccessController.h"


@interface WHCashSuccessController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * LDWebView;

@property (nonatomic,strong) NSMutableURLRequest *request;

@end

@implementation WHCashSuccessController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark - 操作网页 <Delegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString * str = request.URL.absoluteString;
    
    LDLog(@"%@",str);
    
        if ([str containsString:@"submitThirdSignResult.do"]){

        [self.navigationController popViewControllerAnimated:NO];
        
        NSNotification * notice = [NSNotification notificationWithName:@"beiYinH5success" object:nil userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        

    }
    
    
    return YES;
}
//1131
- (void)viewDidLoad {
    
   
    [super viewDidLoad];
    
    self.title= @"电子签名";
    
    if ((self.applyId != nil)&&(self.applyId.length != 0)) {
        
    //正式地址http://101.200.145.195:8088/stcash
        
    NSString * str = [NSString stringWithFormat:@"http://101.200.145.195:8088/stcash/credit-report/xinyang/hudongbeiyin.html?applyId=%@",self.applyId];
        
    //测试地址
//    NSString * str = [NSString stringWithFormat:@"http://123.56.136.151:8088/stcash/credit-report/xinyang/hudongbeiyin.html?applyId=%@",self.applyId];
    
        self.LDWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
        self.LDWebView.scalesPageToFit = YES;
        NSURL * url = [NSURL URLWithString:str];
        self.LDWebView.delegate = self;
        
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        
        [self.LDWebView loadRequest:request];
        
        [self.view addSubview:self.LDWebView];
    
    }else{
    
        [self showFailViewWithString:@"applyID为空"];
    }
 
    
}


@end
