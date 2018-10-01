//
//  ipad_LeftBillsCell.m
//  PocketExpense
//
//  Created by 刘晨 on 16/3/1.
//
//

#import "ipad_LeftBillsCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation ipad_LeftBillsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 330, 60)];
        [self.contentView addSubview:bgImageView];
        
        //category
        categoryIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 28.0, 28.0)];
        categoryIconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:categoryIconImage];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 7, 100, 20)];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
        [nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 29.0, 164.0, 15)];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [dateLabel setTextColor:[UIColor colorWithRed:166.f/255 green:166.f/255 blue:166.f/255 alpha:1.f]];
        [dateLabel setTextAlignment:NSTextAlignmentLeft];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:dateLabel];
        
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 16, 378-230, 20)];
        amountLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
        [amountLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
        [amountLabel setTextAlignment:NSTextAlignmentRight];
        [amountLabel setBackgroundColor:[UIColor clearColor]];
        amountLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:amountLabel];

        UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, 378, EXPENSE_SCALE)];
        bottomLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [self.contentView addSubview:bottomLine];
        
    }
    return self;
}
@end
