//
//  HMJActivityIndicator.m
//  PocketExpense
//
//  Created by humingjing on 14-8-13.
//
//

#import "HMJActivityIndicator.h"

#define WITH 100
#define INDICATOR_WITH 20

@implementation HMJActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-WITH)/2,(self.frame.size.height-WITH)/2, WITH, WITH)];
//        _bgImage.image = [UIImage imageNamed:@"Rounded_Rectangle.png"];
        [self addSubview:_bgImage];
        
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.frame = CGRectMake((self.frame.size.width-INDICATOR_WITH)/2,(self.frame.size.height-INDICATOR_WITH)/2 , INDICATOR_WITH, INDICATOR_WITH);
        _indicator.hidden=NO;
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self addSubview:_indicator];
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

@end
