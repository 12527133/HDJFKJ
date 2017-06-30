

#import "LDBaseTableViewController.h"
#import "WHAddressBookModel.h"

typedef void (^CustCompletionBlock)(WHAddressBookModel * customer);
@interface HDSearchCustController : LDBaseTableViewController
@property (nonatomic, strong) UISearchController  *searchVC;

/** 搜索结果数组 */
@property (nonatomic, strong) NSArray * groupArray;

@property (nonatomic, strong) CustCompletionBlock completionBlock;
@end
