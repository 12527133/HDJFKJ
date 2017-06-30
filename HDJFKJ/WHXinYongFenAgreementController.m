

#import "WHXinYongFenAgreementController.h"

@interface WHXinYongFenAgreementController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView * web;

@property (nonatomic, strong) NSString * firstUrl;

@property (nonatomic, strong) NSString * currentUrl;
@end

@implementation WHXinYongFenAgreementController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createURL];
    
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
    
    
    if (self.web.canGoBack) {
        [self.web goBack];
    }
    else{
    
        [self.navigationController popViewControllerAnimated:YES];
    }

}


-(instancetype)initWithURL:(NSString *)url title:(NSString *)title{
    
    self = [super init];
    if (self) {
        self.mUrl = url;
        self.title = title;
    }
    return self;
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
-(void)createURL{
    
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - 64)];
    //[web goBack];
    self.web.scalesPageToFit = YES;
    
    self.web.delegate = self;
    //web.paginationMode = UIWebPaginationModeUnpaginated;
    NSURL * url = [NSURL URLWithString:self.mUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
    [self.view addSubview:self.web];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.firstUrl == nil) {
        self.firstUrl = request.URL.path;
    }
    
    self.currentUrl = request.URL.path;
    
    NSLog(@"%@",request.URL.path);
    
    return YES;
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
