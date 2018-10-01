//
//  ipad_CategoryTransactionCell.m
//  PocketExpense
//
//  Created by humingjing on 14-9-12.
//
//

#import "ipad_CategoryTransactionCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation ipad_CategoryTransactionCell

@synthesize timeLabel,accountLabel,payeeLabel,memoLabel,spentLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 113, 44)];
        [timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [timeLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:timeLabel];
        
        payeeLabel =[[UILabel alloc] initWithFrame:CGRectMake(128, 6, 100, 17)];
        [payeeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [payeeLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
        [payeeLabel setTextAlignment:NSTextAlignmentLeft];
        [payeeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:payeeLabel];
        
        accountLabel =[[UILabel alloc] initWithFrame:CGRectMake(128, 23, 100, 25.0)];
        [accountLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
        [accountLabel setTextColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1]];
        [accountLabel setTextAlignment:NSTextAlignmentLeft];
        [accountLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:accountLabel];
        
        spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(168+113+114-15-100, 0, 100, 44)];
        [spentLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
        [spentLabel setTextAlignment:NSTextAlignmentCenter];
        [spentLabel setBackgroundColor:[UIColor clearColor]];
        spentLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:spentLabel];
        
        memoLabel=[[UILabel alloc] initWithFrame:CGRectMake(113+168+114+15, 0, 130, 44)];
        [memoLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [memoLabel setTextColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1]];
        [memoLabel setTextAlignment:NSTextAlignmentLeft];
        [memoLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:memoLabel];
        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
