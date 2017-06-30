

#import <UIKit/UIKit.h>

@interface WHXinYongFenAgreementController : LDBaseUIViewController
@property(nonatomic,copy)NSString * mUrl;
@property(nonatomic,strong)NSURLRequest * request;
@property(nonatomic,strong)UIWebView * myWebView;


-(instancetype)initWithURL:(NSString *)url title:(NSString *)title;
@end
