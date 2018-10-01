//
//  ChartTitleBtn.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/13.
//

#import "ChartTitleBtn.h"

@implementation ChartTitleBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"xia"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateSelected];
        
        self.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:17];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    
    UIFont* font = [UIFont fontWithName:FontSFUITextMedium size:17];
    CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    self.width = size.width+40;
}

-(void)setHighlighted:(BOOL)highlighted{};

-(void)layoutSubviews{
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(self.width - 30 , 0, 25, self.height);

    self.titleLabel.frame = CGRectMake(0, 0, self.width - 25, self.height);

    self.titleLabel.textColor = [UIColor blackColor];

}

@end
