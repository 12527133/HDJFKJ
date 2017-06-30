

#import "WHCashLoanSixCiew.h"

@implementation WHCashLoanSixCiew


+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHCashLoanSixCiew" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}
@end
