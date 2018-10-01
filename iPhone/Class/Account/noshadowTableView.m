//
//  noshadowTableView.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/27.
//
//

#import "noshadowTableView.h"

@interface noshadowTableView ()
{
    __weak UIView* wrapperView;
}
@end


@implementation noshadowTableView


- (void) didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    
    //  iOS7
    if(wrapperView == nil && [[[subview class] description] isEqualToString:@"UITableViewWrapperView"])
        wrapperView = subview;
    
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    //  iOS7
    for(UIView* subview in wrapperView.subviews)
    {
        if([[[subview class] description] isEqualToString:@"UIShadowView"])
            [subview setHidden:YES];
    }
}
-(void)removeShadowView
{
    for(UIView* subview in wrapperView.subviews)
    {
        if([[[subview class] description] isEqualToString:@"UIShadowView"])
            [subview setHidden:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
