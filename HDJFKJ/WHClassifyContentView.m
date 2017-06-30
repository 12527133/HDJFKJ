

#import "WHClassifyContentView.h"

@implementation WHClassifyContentView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHClassifyContentView" owner:nil options:nil] lastObject];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
