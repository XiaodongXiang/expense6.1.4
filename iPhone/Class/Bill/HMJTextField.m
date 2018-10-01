//
//  HMJTextField.m
//  PocketExpense
//
//  Created by humingjing on 14-3-31.
//
//

#import "HMJTextField.h"
#import "AppDelegate_iPhone.h"

@implementation HMJTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawPlaceholderInRect:(CGRect)rect

{
    
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentNatural];
    
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSDictionary *attrexpense = @{NSForegroundColorAttributeName:[UIColor colorWithRed:166.f/255.f green:166.f/255.f blue:166.f/255.f alpha:1] , NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0],NSParagraphStyleAttributeName:ps};
    
//    NSDictionary *attrexpense = @{NSForegroundColorAttributeName: [appDelegate_iphone.epnc getGrayColor_156_156_156] , NSFontAttributeName: [UIFont fontWithName:@"Avenir LT 65 Medium" size:10.0],NSParagraphStyleAttributeName:ps};

    [[self placeholder] drawInRect:rect withAttributes:attrexpense];
}

@end
