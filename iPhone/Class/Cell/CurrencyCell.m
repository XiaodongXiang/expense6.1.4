//
//  CurrencyCell.m
//  PokcetExpense
//
//  Created by ZQ on 11/22/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "CurrencyCell.h"
@implementation CurrencyCell
@synthesize symbolLabel;
@synthesize nameLabel;
@synthesize bgImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
//        
//        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
//        bgImageView.image = [UIImage imageNamed:@"cell_320_44.png"];
//        self.backgroundView = bgImageView;

		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 11.0, 225.0, 22.0)];
		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];

		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		//[nameLabel setTextColor:[UIColor colorWithRed:106.0/255 green:106.0/255 blue:106.0/255 alpha:1]];
        [nameLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];

		[self.contentView addSubview:nameLabel];
		
		
		 symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 11.0, 60.0, 22.0)];
		[symbolLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
 
		[symbolLabel setTextAlignment:NSTextAlignmentLeft];
		[symbolLabel setBackgroundColor:[UIColor clearColor]];
		//[symbolLabel setTextColor:[UIColor colorWithRed:106.0/255 green:106.0/255 blue:106.0/255 alpha:1]];
        [symbolLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
		[self.contentView addSubview:symbolLabel];
    }
    return self;
}

 



@end
