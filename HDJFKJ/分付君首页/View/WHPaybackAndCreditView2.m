

#import "WHPaybackAndCreditView2.h"

@implementation WHPaybackAndCreditView2


+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHPaybackAndCreditView2" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
        
    }
    return self;
}





























@end
