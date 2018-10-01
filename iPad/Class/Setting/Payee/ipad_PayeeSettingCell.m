//
//  ipad_PayeeSettingCell.m
//  PocketExpense
//
//  Created by MV on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ipad_PayeeSettingCell.h"

@implementation ipad_PayeeSettingCell
@synthesize categoryLabel,memoLabel,payeeLabel,bgImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
 		bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 480, 50)];
        self.backgroundView = bgImage;
        payeeLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, 1, 160, 30.0)];
        [payeeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];
 		[payeeLabel setTextColor:[UIColor  colorWithRed:94/255.f green:94/255.f blue:94/255.f alpha:1]];
		[payeeLabel setTextAlignment:NSTextAlignmentLeft];
		[payeeLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:payeeLabel];

        
		categoryLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, 25  , 160, 20.0) ];
		[categoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
        
		[categoryLabel setTextColor:[UIColor colorWithRed:172.f/255 green:173.0/255 blue:178.0/255 alpha:1]];
		[categoryLabel setTextAlignment:NSTextAlignmentLeft];
		[categoryLabel setBackgroundColor:[UIColor clearColor]];
  		[self.contentView addSubview:categoryLabel];
		
				
        memoLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [memoLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        
 		[memoLabel setTextColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1]];
		[memoLabel setTextAlignment:NSTextAlignmentLeft];
		[memoLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:memoLabel];

        self.backgroundColor = [UIColor clearColor];

        
 	}
    return self;
}



@end
