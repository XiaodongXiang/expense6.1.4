//
//  CategorySelectCell.m
//  PokcetExpense
//
//  Created by ZQ on 12/6/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "CategorySelectCell.h"


@implementation CategorySelectCell
@synthesize nameLabel;
@synthesize bgImageView1,bgImageView2;
@synthesize headImageView;
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		bgImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad_cell_484_44.png"]];
		[bgImageView1 setFrame:CGRectMake(0, 0, 484, 44.0)];

	 	
        bgImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad_cell_sel_484_44.png"]];
		[bgImageView2 setFrame:CGRectMake(0, 0, 484, 44.0)];


		headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40.0, 6.0, 30, 30.0)];
		[self.contentView addSubview:headImageView];
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 0.0, 220.0, 44.0)];
 		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];
 		[nameLabel setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
	 	[self.contentView addSubview:nameLabel];

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.backgroundView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
    
}


@end