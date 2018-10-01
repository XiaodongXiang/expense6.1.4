//
//  HMJSyncIndicatorView.m
//  PocketExpense
//
//  Created by humingjing on 14/12/23.
//
//

#import "HMJSyncIndicatorView.h"
#define WITH 100
#define INDICATOR_WITH 20

@implementation HMJSyncIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-WITH)/2,(self.frame.size.height-WITH)/2, WITH, WITH)];
        _bgImage.image = [UIImage imageNamed:@"Rounded_Rectangle.png"];
        [self addSubview:_bgImage];
        
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.frame = CGRectMake((self.frame.size.width-INDICATOR_WITH)/2,(self.frame.size.height-INDICATOR_WITH)/2 - INDICATOR_WITH+7 , INDICATOR_WITH, INDICATOR_WITH);
        _indicator.hidden = NO;
        [self addSubview:_indicator];
        [_indicator startAnimating];
        _remidnerLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-WITH)/2 ,(self.frame.size.height-WITH)/2+ 50+7, WITH, INDICATOR_WITH)];
        _remidnerLabel.textColor = [UIColor whiteColor];
        [_remidnerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        _remidnerLabel.text = @"Syncing";
        _remidnerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_remidnerLabel];
        

        
    }
    return self;
}


- (void)rotateViewAccordingToStatusBarOrientation:(NSNotification *)notification
{
    
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8)
        return;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat angle = 0.0;
    CGRect newFrame = self.window.bounds;
    CGSize statusBarSize = CGSizeZero;// [[UIApplication sharedApplication] statusBarFrame].size;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            newFrame.size.height -= statusBarSize.height;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = - M_PI / 2.0f;
            
            newFrame.origin.x += statusBarSize.width;
            newFrame.size.width -= statusBarSize.width;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI / 2.0f;
            
            newFrame.size.width -= statusBarSize.width;
            break;
        default: // as UIInterfaceOrientationPortrait
            angle = 0.0;
            newFrame.origin.y += statusBarSize.height;
            newFrame.size.height -= statusBarSize.height;
            break;
    }
    self.transform = CGAffineTransformMakeRotation(angle);
    self.frame = newFrame;
    //    if(!ISPAD)
    //    {
    //        self.view.transform = CGAffineTransformMakeRotation(angle);
    //        self.view.frame = newFrame;
    //    }
}

@end
