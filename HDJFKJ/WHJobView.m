

#import "WHJobView.h"

@implementation WHJobView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHJobView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}
@end
