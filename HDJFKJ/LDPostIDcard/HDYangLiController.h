

#import "LDBaseUIViewController.h"
typedef void (^PhotoCompletionBlock)();
@interface HDYangLiController : LDBaseUIViewController
@property (nonatomic, strong) PhotoCompletionBlock completionBlock;
@end
