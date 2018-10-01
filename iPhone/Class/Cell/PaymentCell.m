//
//  PaymentCell.m
//  Expense 5
//
//  Created by BHI_James on 5/14/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "PaymentCell.h"
#import "PokcetExpenseAppDelegate.h"

@interface PaymentCell (SubviewFrames)

@end

@implementation PaymentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{

		
        _categoryImage =[[UIImageView alloc] initWithFrame:CGRectMake(9, 17, 28,28)];
		[self.contentView addSubview:_categoryImage];
        
		_accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 14, 200, 20) ];
 		[_accountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        [_accountLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
      	[_accountLabel setTextAlignment:NSTextAlignmentLeft];
		[_accountLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:_accountLabel];
		
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-200-15, 21, 200, 20)];
        [_amountLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
		[_amountLabel setTextColor:[UIColor colorWithRed:166.0/255 green:166.0/255 blue:166.0/255 alpha:1.f]];
      	[_amountLabel setTextAlignment:NSTextAlignmentRight];
		[_amountLabel setBackgroundColor:[UIColor clearColor]];
        _amountLabel.adjustsFontSizeToFitWidth = YES;
		[self.contentView addSubview:_amountLabel];
		
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 36, 120, 15) ];
		[_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_dateLabel setTextColor:[UIColor colorWithRed:166.0/255 green:166.0/255 blue:166.0/255 alpha:1]];
      	[_dateLabel setTextAlignment:NSTextAlignmentLeft];
		[_dateLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:_dateLabel];
        
        //设置背景图片
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(53, 52-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
        line.backgroundColor = [UIColor colorWithRed:218/255.f green:218/255.f blue:218/255.f alpha:1];
        [self.contentView addSubview:line];
    
    }
    return self;
}




@end
