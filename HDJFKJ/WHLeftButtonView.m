

#import "WHLeftButtonView.h"

@implementation WHLeftButtonView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHLeftButtonView" owner:nil options:nil] lastObject];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    
    return self;
}

@end
