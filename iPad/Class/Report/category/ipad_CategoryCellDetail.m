//
//  ipad_CategoryCell.m
//  PocketExpense
//
//  Created by Tommy on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ipad_CategoryCellDetail.h"
#import "PokcetExpenseAppDelegate.h"

@implementation ipad_CategoryCellDetail
@synthesize bgImageView;
@synthesize nameLabel;
@synthesize spentLabel;
@synthesize percentLabel;
 @synthesize colorLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 420, 60)];
        bgImageView.image = [UIImage imageNamed:@"ipad_cell_420_60.png"];
        self.backgroundView = bgImageView;
 		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 250.0, 40.0)];
 		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
		[nameLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
  		[self.contentView addSubview:nameLabel];
		
        
        colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 40.0, 9.0, 9.0)];
		[colorLabel setTextColor:[UIColor clearColor]];
		[colorLabel setTextAlignment:NSTextAlignmentRight];
		[colorLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:colorLabel];
        
		percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 100, 30.0) ];
		[percentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
		[percentLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1.0]];
		[percentLabel setTextAlignment:NSTextAlignmentLeft];
		[percentLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:percentLabel];
        
        
        spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.0, 0, 160, 60.0)];
        [spentLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
		[spentLabel setTextAlignment:NSTextAlignmentRight];//how to set the LabelText center
 		[spentLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:spentLabel];

        self.backgroundColor = [UIColor clearColor];

	}
    return self;
}

 




@end
