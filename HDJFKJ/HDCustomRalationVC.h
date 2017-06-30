

#import "LDBaseUIViewController.h"
#import "WHAddressBookModel.h"
typedef void(^AddressBookBlock)(WHAddressBookModel * addBook);

@interface HDCustomRalationVC : LDBaseUIViewController

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) AddressBookBlock addressBook;

@end
