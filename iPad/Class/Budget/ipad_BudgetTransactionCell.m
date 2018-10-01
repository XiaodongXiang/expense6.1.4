//
//  ipad_BudgetTransactionCell.m
//  PocketExpense
//
//  Created by humingjing on 14-5-21.
//
//

#import "ipad_BudgetTransactionCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation ipad_BudgetTransactionCell
@synthesize bgImageView;
@synthesize nameLabel;
@synthesize spentLabel;
@synthesize categoryLabel;
@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
		
        //payee
		nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(129, 6, 220, 17)];
 		nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor colorWithRed:94/255.f green:94/255.f blue:94/255.f alpha:1];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
        nameLabel.textAlignment = NSTextAlignmentLeft;
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:nameLabel];
		
        //category
        categoryLabel =[[UILabel alloc] initWithFrame:CGRectMake(129, 23, 220, 15) ];
		[categoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [categoryLabel setTextColor:[UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1]];
		[categoryLabel setTextAlignment:NSTextAlignmentLeft];
		[categoryLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:categoryLabel];
        
        
 		spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(566-15-144, 0, 144.0, 44)];
		[spentLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
 		[spentLabel setTextAlignment:NSTextAlignmentRight];
 		[spentLabel setBackgroundColor:[UIColor clearColor]];
        [spentLabel setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
        [self addSubview:spentLabel];
		
        
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 114, 44)];
		[timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [timeLabel setTextColor:[UIColor colorWithRed:94/255.f green:94/255.f blue:94/255.f alpha:1.0]];
        
		[timeLabel setTextAlignment:NSTextAlignmentLeft];
		[timeLabel setBackgroundColor:[UIColor clearColor]];
 		[self addSubview:timeLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
