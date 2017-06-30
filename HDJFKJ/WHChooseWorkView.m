

#import "WHChooseWorkView.h"

@implementation WHChooseWorkView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHChooseWorkView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
