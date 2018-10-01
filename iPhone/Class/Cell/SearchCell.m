//
//  SearchCell.m
//  Expense 5
//
//  Created by BHI_James on 4/26/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "SearchCell.h"

//@interface SearchCell (SubviewFrames)
//- (CGRect)_categoryLabelFrame;
//- (CGRect)_accountLabelFrame;
//- (CGRect)_amountLabelFrame;
//- (CGRect) _bgImageViewFrame;
//@end

@implementation SearchCell
@synthesize	categoryLabel;
@synthesize	accountLabel;
@synthesize	amountLabel;
@synthesize	bgImageView;
@synthesize dateLabel;
@synthesize noteLabel;
@synthesize cycleImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//		bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//		bgImageView.image = [UIImage imageNamed:@"cell_search.png"];
//		[self.contentView addSubview:bgImageView];
//		
//		categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//		[categoryLabel setFont:[UIFont fontWithName:@"Arial" size:15.0]];
//		[categoryLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
//		[categoryLabel setTextColor:[UIColor colorWithRed:39.0/255 green:37.0/255 blue:37.0/255 alpha:1]];
//		[categoryLabel setTextAlignment:NSTextAlignmentLeft];
//		[categoryLabel setBackgroundColor:[UIColor clearColor]];
//		[self.contentView addSubview:categoryLabel];
//		
//		amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//		[amountLabel setFont:[UIFont fontWithName:@"Arial" size:15.0]];
//		[amountLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
//		[amountLabel setTextColor:[UIColor colorWithRed:39.0/255 green:37.0/255 blue:37.0/255 alpha:1]];
//		[amountLabel setTextAlignment:NSTextAlignmentRight];
//		[amountLabel setBackgroundColor:[UIColor clearColor]];
//		[self.contentView addSubview:amountLabel];
//		
//		accountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//		[accountLabel setFont:[UIFont fontWithName:@"Arial" size:15.0]];
//		[accountLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
//		[accountLabel setTextColor:[UIColor colorWithRed:39.0/255 green:37.0/255 blue:37.0/255 alpha:1]];
//		[accountLabel setTextAlignment:NSTextAlignmentLeft];
//		[accountLabel setBackgroundColor:[UIColor clearColor]];
//		[self.contentView addSubview:accountLabel];
		
    }
    return self;
}

//-(void)layoutSubviews
//{
//	[super layoutSubviews];
//	[categoryLabel setFrame:[self _categoryLabelFrame]];
//	[amountLabel setFrame:[self _amountLabelFrame]];
//	[accountLabel setFrame:[self _accountLabelFrame]];
//	[bgImageView setFrame:[self _bgImageViewFrame]];
//}

//-(CGRect) _categoryLabelFrame
//{
//	return CGRectMake(10.0, 0.0, 160.0, 25.0);
//}
//-(CGRect) _amountLabelFrame
//{
//	return CGRectMake(175.0, 0.0, 100, 50.0);
//}
//-(CGRect) _accountLabelFrame
//{
//	return CGRectMake(10.0, 23.0, 160.0, 27.0);
//}
//
//- (CGRect)_bgImageViewFrame
//{
//	return CGRectMake(0.0, 0.0, 320, 50.0);
//}




@end
