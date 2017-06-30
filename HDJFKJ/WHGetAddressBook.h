

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface WHGetAddressBook : NSObject

+ (BOOL)getAddressBookMessage;

/** 读取出通讯录  */
+ (NSMutableArray *)returnAddressBookMessage;

+ (NSMutableArray *)returnAddressBookArray;
@end
