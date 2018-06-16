//
//  Expense.m
//  PokcetExpense
//
//  Created by ZQ on 9/27/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "ipad_PayeeSearchCell.h"

@implementation ipad_PayeeSearchCell
@synthesize categoryLabel,payeeLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
 		payeeLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 250, 39.0)];
        [payeeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        
 		[payeeLabel setTextColor:[UIColor colorWithRed:82.0/255 green:104.0/255 blue:148.0/255 alpha:1]];
		[payeeLabel setTextAlignment:NSTextAlignmentLeft];
		[payeeLabel setBackgroundColor:[UIColor clearColor]];
        [payeeLabel setHighlightedTextColor:[UIColor whiteColor]];
 		[self.contentView addSubview:payeeLabel];
        
		categoryLabel =[[UILabel alloc]initWithFrame:CGRectMake(270,0, 255, 39)];
        [categoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        
 		[categoryLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
		[categoryLabel setTextAlignment:NSTextAlignmentRight];
		[categoryLabel setBackgroundColor:[UIColor clearColor]];
        [categoryLabel setHighlightedTextColor:[UIColor whiteColor]];
  		[self.contentView addSubview:categoryLabel];

        self.backgroundColor = [UIColor clearColor];

 	}
    return self;
}




@end
