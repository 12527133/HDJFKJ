

#import <UIKit/UIKit.h>

@interface WHBankAgreementController : LDBaseUIViewController
@property(nonatomic,copy)NSString * mUrl;
@property(nonatomic,strong)NSURLRequest * request;
@property(nonatomic,strong)UIWebView * myWebView;


-(instancetype)initWithURL:(NSString *)url;
@end
