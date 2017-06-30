

#import "WHAddBankCardView.h"

@implementation WHAddBankCardView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHAddBankCardView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}
@end
