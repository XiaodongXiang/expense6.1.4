//
//  ipad_CusSettingCell.m
//  PocketExpense
//
//  Created by MV on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ipad_CusSettingCell.h"

@implementation ipad_CusSettingCell
@synthesize stringLabel;
@synthesize line1,line2,line3;
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        stringLabel =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 44)];
        [stringLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16]];
        
 		[stringLabel setTextColor:[UIColor blackColor] ];
		[stringLabel setTextAlignment:NSTextAlignmentLeft];
		[stringLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:stringLabel];
        
         line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 1)];
        [line1 setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:line1];
         
         line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 230, 1)];
         [line2 setBackgroundColor: [UIColor colorWithRed:180.f/255.f  green:180.f/255.f blue:180.f/255.f alpha:1.f]];
        [self.contentView addSubview:line2];
        
        line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 230, 1)];
        [line3 setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:line3];
        line3.hidden = YES;
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(selected)
    {

    }
    else {

        
    }

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animate
{
    if(highlighted)
    {

    }
    else {

        
    }

    [super setHighlighted:highlighted animated:animate];
}

@end
