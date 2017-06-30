

#import "HDWHLoadFailView.h"

@implementation HDWHLoadFailView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HDWHLoadFailView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
