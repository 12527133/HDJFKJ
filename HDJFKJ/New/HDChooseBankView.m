

#import "HDChooseBankView.h"

@implementation HDChooseBankView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HDChooseBankView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
