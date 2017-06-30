

#import "WHStudentView.h"

@implementation WHStudentView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHStudentView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
