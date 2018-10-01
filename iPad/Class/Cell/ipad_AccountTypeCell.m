//
//  ipad_AccountTypeCell.m
//  PocketExpense
//
//  Created by MV on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ipad_AccountTypeCell.h"

@implementation ipad_AccountTypeCell
 
@synthesize nameLabel;
@synthesize headImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {

		headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
		[self.contentView addSubview:headImageView];
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(46.0, 0.0, 220.0, 43.0)];
		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
		[nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:nameLabel];

    }
    return self;
}






@end