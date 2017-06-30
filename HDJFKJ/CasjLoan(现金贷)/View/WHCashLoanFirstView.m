

#import "WHCashLoanFirstView.h"

@implementation WHCashLoanFirstView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHCashLoanFirstView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
