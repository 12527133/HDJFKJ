

#import "WHClassifySubView.h"

@implementation WHClassifySubView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHClassifySubView" owner:nil options:nil] lastObject];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
