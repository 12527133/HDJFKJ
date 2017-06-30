

#import "WHRightButtonView.h"

@implementation WHRightButtonView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHRightButtonView" owner:nil options:nil] lastObject];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
   
    return self;
}


@end
