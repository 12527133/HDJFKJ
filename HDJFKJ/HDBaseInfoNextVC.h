

#import <UIKit/UIKit.h>
#import "HDAccessToken.h"

#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSExport <JSExport>
JSExportAs
(calculateForJS  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)handleFactorialCalculateWithNumber:(NSNumber *)number
 );
- (void)pushViewController:(NSString *)view title:(NSString *)title;

- (void)success;
@end

@interface HDBaseInfoNextVC : UIViewController

@property (nonatomic, strong) HDAccessToken * accessToken;

@property (nonatomic, strong) NSString * userName;

@property (nonatomic, strong) NSString * userNo;

@end
