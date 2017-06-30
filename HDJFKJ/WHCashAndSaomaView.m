

#import "WHCashAndSaomaView.h"

@implementation WHCashAndSaomaView


+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHCashAndSaomaView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;        
    }
    return self;
}
@end
