//
//  ipad_CategoryCmpCell.m
//  PocketExpense
//
//  Created by MV on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ipad_CategoryCmpCell.h"

@implementation ipad_CategoryCmpCell
@synthesize nameLabel;
@synthesize amount1Label;
@synthesize amount2Label;
@synthesize diffAmountLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
        
 		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 100.0, 30.0)];	
 		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
        
		[nameLabel setTextColor:[UIColor colorWithRed:40.0/255 green:139.0/255 blue:176.0/255 alpha:1]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		[nameLabel setTextColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1.f]];
 		[self.contentView addSubview:nameLabel];
		
		amount1Label = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 0.0, 70.0, 30.0)];
		[amount1Label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
 		[amount1Label setTextColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1.f]];
		[amount1Label setTextAlignment:NSTextAlignmentLeft];//how to set the LabelText center
 		[amount1Label setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:amount1Label];
	
        amount2Label = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 0.0, 70.0, 30.0)];
		[amount2Label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
 		[amount2Label setTextColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1.f]];
		[amount2Label setTextAlignment:NSTextAlignmentLeft];//how to set the LabelText center
 		[amount2Label setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:amount2Label];

        diffAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(250.0, 0.0, 60.0, 30.0)];
		[diffAmountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
 		[diffAmountLabel setTextColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1.f]];
		[diffAmountLabel setTextAlignment:NSTextAlignmentRight];//how to set the LabelText center
 		[diffAmountLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:diffAmountLabel];
        self.backgroundColor = [UIColor clearColor];

	}
    return self;
}
 





@end
