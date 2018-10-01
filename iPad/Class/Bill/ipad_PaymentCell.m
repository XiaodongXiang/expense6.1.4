//
//  ipad_PaymentCell.m
//  PocketExpense
//
//  Created by humingjing on 14-5-18.
//
//

#import "ipad_PaymentCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation ipad_PaymentCell
@synthesize dateLabel;
@synthesize accountLabel;
@synthesize amountLabel;
@synthesize bgImageView;
@synthesize categoryImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
        
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 60.0)];
        bgImageView.image = [UIImage imageNamed:@"cell_a1_320_50.png"];
        self.backgroundView = bgImageView;
        
        
        categoryImage =[[UIImageView alloc] initWithFrame:CGRectMake(13.0, 13.0, 30,30)];
        [self.contentView addSubview:categoryImage];
        
        accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 1, 120, 35) ];
        [accountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];
        [accountLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1.f]];
        [accountLabel setTextAlignment:NSTextAlignmentLeft];
        [accountLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:accountLabel];
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 0, 340, 59)];
        [amountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
        [amountLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1.f]];
        [amountLabel setTextAlignment:NSTextAlignmentRight];
        [amountLabel setBackgroundColor:[UIColor clearColor]];
        amountLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:amountLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 27, 120, 25) ];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
        [dateLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1]];
        [dateLabel setTextAlignment:NSTextAlignmentLeft];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:dateLabel];
    }
    return self;
}



@end
