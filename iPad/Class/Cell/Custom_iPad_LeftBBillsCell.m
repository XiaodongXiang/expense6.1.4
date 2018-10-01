//
//  Custom_iPad_LeftBBillsCell.m
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "Custom_iPad_LeftBBillsCell.h"
#import "PokcetExpenseAppDelegate.h"


@implementation Custom_iPad_LeftBBillsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 330, 60)];
        [self.contentView addSubview:_bgImageView];
        
        //category
        _categoryIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 28.0, 28.0)];
        _categoryIconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_categoryIconImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 7, 100, 20)];
        [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
        [_nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_nameLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 29.0, 164.0, 15)];
        [_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_dateLabel setTextColor:[UIColor colorWithRed:166.f/255 green:166.f/255 blue:166.f/255 alpha:1.f]];
        [_dateLabel setTextAlignment:NSTextAlignmentLeft];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_dateLabel];
        
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 16, 378-230, 20)];
        _amountLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
        [_amountLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
        [_amountLabel setTextAlignment:NSTextAlignmentRight];
        [_amountLabel setBackgroundColor:[UIColor clearColor]];
        _amountLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_amountLabel];
        
        UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, 378, EXPENSE_SCALE)];
        bottomLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [self.contentView addSubview:bottomLine];
        
    }
    return self;
}


@end
