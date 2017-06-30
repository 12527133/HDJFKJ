

#import "WHCashLoanFourView.h"

@implementation WHCashLoanFourView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHCashLoanFourView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
