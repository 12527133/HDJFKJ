

#import <UIKit/UIKit.h>
typedef void (^OrderListCompletionBlock)(id object);
@interface HDLoanOrderView : UIView

@property (nonatomic, strong) NSArray * statusArray;

@property (nonatomic, strong) NSString * orderStatus;

@property (nonatomic, assign) NSInteger orderType;

@property (nonatomic, strong) UICollectionView * collectionView;


@property (nonatomic, strong) OrderListCompletionBlock completionBlock;

- (id)initWithFrame:(CGRect)frame;

- (void)createView;

- (void)getOrderRequest;

@end
