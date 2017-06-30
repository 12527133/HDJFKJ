

#import "WHEntrepreneursView.h"

@implementation WHEntrepreneursView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHEntrepreneursView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
