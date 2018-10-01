//
//  CurrencyCell.m
//  PokcetExpense
//
//  Created by ZQ on 11/22/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "ipad_CurrencyCell.h"

@interface ipad_CurrencyCell (SubviewFrames)
- (CGRect) _nameLabelFrame;
- (CGRect) _symbolLabelFrame;
- (CGRect) _bgImageViewFrame;

@end

@implementation ipad_CurrencyCell
@synthesize symbolLabel;
@synthesize nameLabel;
@synthesize bgImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 44.0)];
        bgImageView.image = [UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"];
        self.backgroundView = bgImageView;
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 16.0, 225.0, 22.0)];
		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		//[nameLabel setTextColor:[UIColor colorWithRed:106.0/255 green:106.0/255 blue:106.0/255 alpha:1]];
        [nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
        
		[self.contentView addSubview:nameLabel];
		
		
        symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 16.0, 60.0, 22.0)];
		[symbolLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        
		[symbolLabel setTextAlignment:NSTextAlignmentLeft];
		[symbolLabel setBackgroundColor:[UIColor clearColor]];
		//[symbolLabel setTextColor:[UIColor colorWithRed:106.0/255 green:106.0/255 blue:106.0/255 alpha:1]];
        [symbolLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
		[self.contentView addSubview:symbolLabel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}




@end
